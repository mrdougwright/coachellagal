class WrongSettingsError < StandardError ; end
class WelcomeController < ApplicationController
  skip_before_filter :redirect_to_welcome
  layout 'welcome'

  def index
    @best_selling_products = Product.limit(5)
    @product_types = ProductType.all
    @user = User.new
  end

end
