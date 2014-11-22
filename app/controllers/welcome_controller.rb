class WrongSettingsError < StandardError ; end
class WelcomeController < ApplicationController
  skip_before_filter :redirect_to_welcome
  layout 'welcome'
  # layout 'application' #stripe commerce

  def index
    @best_selling_products = Product.limit(5)
    @product_types = ProductType.all
    @user = User.new
  end

  def load
    if in_production?
      render :text => 'loaderio-79aeb8198cf6b8d1faffd0edad063326', :layout => false
    else#staging
      render :text => 'loaderio-93a086e0760b88038535f27e6b626d2b', :layout => false
    end
  end
end
