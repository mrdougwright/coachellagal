class WelcomeController < ApplicationController

  layout 'welcome'

  def index
    @best_selling_products = Product.limit(5)
    @product_types = ProductType.all
    if current_user && current_user.admin?
      redirect_to admin_merchandise_products_url
    end
  end
end
