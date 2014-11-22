require 'spec_helper'

describe Cart, ".sub_total" do
  # shopping_cart_items.inject(0) {|sum, item| item.total + sum}

  before(:each) do
    @cart = create(:cart_with_two_5_dollar_items)
  end

  it "should calculate subtotal correctly" do
    @cart.sub_total.should == 10.00
  end

  it "should give the number of cart items" do
    @cart.number_of_shopping_cart_items.should == 2
  end

  it "should give the number of cart items" do
    variant = FactoryGirl.create(:variant)
    @cart.add_variant(variant.id, @cart.user, 2)
    @cart.number_of_shopping_cart_items.should == 4
  end
end

describe Cart, " instance methods" do
  before(:each) do
    @cart = create(:cart_with_two_5_dollar_items)
  end

  context 'change_main_sale(variant, customer)' do
    it 'should add item to cart' do
      variant = FactoryGirl.create(:variant)
      @cart.change_main_sale(variant, nil)
      @cart.reload
      expect(@cart.shopping_cart_items.map(&:variant_id).include?(variant.id)).to be_truthy
    end
  end

  context '.has_main_sale_already?' do
    it 'should be true' do
      variant1 = FactoryGirl.create(:variant)
      variant2 = FactoryGirl.create(:variant)
      cart_item = FactoryGirl.create(:cart_item, :variant => variant2)
      Variant.stubs(:default_preorder_item_ids).returns([variant2.id])
      @cart.stubs(:shopping_cart_items).returns([cart_item])
      @cart.has_main_sale_already?.should be_truthy
    end
    it 'should be false' do
      variant1 = FactoryGirl.create(:variant)
      variant2 = FactoryGirl.create(:variant)
      cart_item = FactoryGirl.create(:cart_item, :variant => variant1)
      Variant.stubs(:default_preorder_item_ids).returns([variant2.id])
      @cart.stubs(:shopping_cart_items).returns([cart_item])
      @cart.has_main_sale_already?.should be_falsey
    end
  end

  context " add_items_to_checkout" do

    before(:each) do
      @order = create(:in_progress_order)
    end

    it 'should add item to in_progress orders' do
      @cart.add_items_to_checkout(@order)
      @order.order_items.size.should == 2
    end

    it 'should keep items already in order to in_progress orders' do
      @cart.add_items_to_checkout(@order)
      @cart.add_items_to_checkout(@order)
      @order.order_items.size.should == 2
    end

    it 'should add only needed items already in order to in_progress orders' do
      @cart.add_items_to_checkout(@order)
      @cart.shopping_cart_items.push(create(:cart_item))
      @cart.add_items_to_checkout(@order)
      @order.order_items.size.should == 3
    end

    it 'should remove items not in cart to in_progress orders' do
      @cart.shopping_cart_items.push(create(:cart_item))
      @cart.add_items_to_checkout(@order) ##
      @order.order_items.size.should == 3
      cart = create(:cart_with_two_5_dollar_items)
      cart.add_items_to_checkout(@order)
      @order.order_items.size.should == 2
    end
  end

  context ".save_user(u)" do
    #pending "test for save_user(u)"
    it 'should assign the user to the cart' do
      user = create(:user)
      @cart.save_user(user)
      @cart.user.should == user
    end
  end

end

describe Cart, '' do

  before(:each) do
    @cart = create(:cart_with_two_items)
  end

  context 'mark_items_purchased(order)' do
    it 'should mark cart items as purchased' do

      order = create(:order)
      order.stubs(:variant_ids).returns(@cart.cart_items.collect{|ci| ci.variant_id})
      @cart.mark_items_purchased(order)
      @cart.cart_items.each do |ci|
        ci.reload.item_type_id.should == ItemType::PURCHASED_ID
      end
    end

    it 'should not mark cart items as purchased if it isnt in the order' do

      order = create(:order)
      order.stubs(:variant_ids).returns([])
      @cart.mark_items_purchased(order)
      @cart.cart_items.each do |ci|
        ci.reload.item_type_id.should_not == ItemType::PURCHASED_ID
      end
    end
  end
end

describe Cart, ".add_variant" do
  # need to stub variant.sold_out? and_return(false)
  before(:each) do
    @cart = create(:cart_with_two_5_dollar_items)
    @variant = create(:variant)
  end

  it 'should add variant to cart' do
    Variant.any_instance.stubs(:sold_out?).returns(false)
    cart_item_size = @cart.shopping_cart_items.size
    @cart.add_variant(@variant.id, @cart.user)
    @cart.shopping_cart_items.size.should == cart_item_size + 1
  end

  it 'should add quantity of variant to cart' do
    Variant.any_instance.stubs(:sold_out?).returns(false)
    cart_item_size = @cart.shopping_cart_items.size
    @cart.add_variant(@variant.id, @cart.user)
    @cart.add_variant(@variant.id, @cart.user)
    @cart.cart_items.each do |item|
      #puts "#{item.variant_id} : #{@variant.id}  (#{item.quantity})"
      item.quantity.should == 2 if item.variant_id == @variant.id
    end

    @cart.shopping_cart_items.size.should == cart_item_size + 1
  end

  it 'should add quantity of variant to saved_cart_items if out of stock' do
    Variant.any_instance.stubs(:sold_out?).returns(true)
    cart_item_size = @cart.shopping_cart_items.size
    @cart.add_variant(@variant.id, nil)

    @cart.shopping_cart_items.size.should == cart_item_size
    @cart.saved_cart_items.size.should == 1
  end
end

describe Cart, ".remove_variant" do
  it 'should inactivate variant in cart' do
    @cart = create(:cart_with_two_items)
    variant_ids =  @cart.cart_items.collect {|ci| ci.variant.id }
    @cart.remove_variant(variant_ids.first)
    @cart.cart_items.each do |ci|
      ci.active.should be_falsey if ci.variant.id == variant_ids.first
    end
  end
end

describe  ".merge_with_previous_cart! " do
  before(:each) do
    @user = create(:user)
    @variant1 = create(:variant, price: 1.00)
    @variant2 = create(:variant, price: 5.00)
    @variant3 = create(:variant, price: 30.00)
    @cart       = create(:cart, user: @user)
    @cart_item  = create(:cart_item, cart: @cart, user: @user, variant: @variant1, quantity: 2)
  end

  context 'with each cart having one item' do
    it 'should add items from previous cart' do
      previous_cart = create(:cart, user: @user)
      cart_item2    = create(:cart_item, cart: previous_cart, user: @user, variant: @variant2)
      @cart.merge_with_previous_cart!
      @cart.reload
      expect(@cart.cart_items.map(&:variant_id).include?(@variant1.id)).to be_truthy
      expect(@cart.cart_items.map(&:variant_id).include?(@variant2.id)).to be_truthy
    end
  end

  context 'with each cart having the same' do
    it 'should add items from previous cart' do
      previous_cart = create(:cart, user: @user)
      cart_item2    = create(:cart_item, cart: previous_cart, user: @user, variant: @variant1, quantity: 1)
      @cart.merge_with_previous_cart!
      @cart.reload
      expect(@cart.cart_items.map(&:variant_id).include?(@variant1.id)).to be_truthy
      expect(@cart.cart_items.size).to eq 1
      expect(@cart.cart_items.first.quantity).to eq 2
    end
  end
end
