class WelcomeController < ApplicationController

  layout 'welcome'

  def index
    @best_selling_products = Product.limit(5)
    @product_types = ProductType.all
  end
end
