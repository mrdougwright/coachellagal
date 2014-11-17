class Admin::Rma::ReturnAuthorizationsController < Admin::Rma::BaseController
  helper_method :sort_column, :sort_direction
  # GET /return_authorizations
  def index
    load_info
    @return_authorizations = @order.return_authorizations.admin_grid(params).order(sort_column + " " + sort_direction).
                                              paginate(:page => pagination_page, :per_page => pagination_rows)
  end

  # GET /return_authorizations/1
  def show
    load_info
    @return_authorization = ReturnAuthorization.includes(:user,:comments).find(params[:id])
    add_to_recent_user(@return_authorization.user)
  end

  # GET /return_authorizations/new
  def new
    load_info

    @stripe_charge = Stripe::Charge.retrieve(@order.completed_invoices.last.charge_token) if @order.completed_invoices.last.try(:charge_token)

    @return_authorization = ReturnAuthorization.new
    @return_authorization.comments << (Comment.new(:user_id => @order.user_id, :created_by => current_user.id))
    form_info
  end

  # GET /return_authorizations/1/edit
  def edit
    load_info
    @return_authorization = ReturnAuthorization.includes(:user,:comments).find(params[:id])
    add_to_recent_user(@return_authorization.user)
    form_info
    redirect_to(admin_rma_order_return_authorization_url(@order, @return_authorization), :notice => 'Return authorization can not be changed.') if !@return_authorization.authorized?
  end

  # POST /return_authorizations
  def create
    load_info
    @return_authorization = @order.return_authorizations.new(allowed_params)
    @return_authorization.created_by = current_user.id
    @return_authorization.user_id    = @order.user_id
    if params[:return_authorization] && params[:return_authorization][:amount].present?
      if @return_authorization.save
        redirect_to(admin_rma_order_return_authorization_url(@order, @return_authorization), :notice => 'Return authorization was successfully created.')
      else
        @stripe_charge = Stripe::Charge.retrieve(@order.completed_invoices.last.charge_token) if @order.completed_invoices.last.try(:charge_token)
        form_info
        render :action => "new"
      end
    else
      flash[:alert] = 'Please enter an ammount.'
      form_info
      render :action => "new"
    end
  end

  # PUT /return_authorizations/1
  def update
    load_info
    @return_authorization = ReturnAuthorization.find(params[:id])
    if params[:return_authorization] && params[:return_authorization][:amount].present?
      if @return_authorization.update_attributes(allowed_params)
        redirect_to(admin_rma_order_return_authorization_url(@order, @return_authorization), :notice => 'Return authorization was successfully updated.')
      else
        form_info
        render :action => "edit"
      end
    else
      flash[:alert] = 'Please enter an ammount.'
      form_info
      render :action => "edit"
    end
  end

  def complete
    load_info
    @return_authorization = ReturnAuthorization.find(params[:id])
    if @return_authorization.complete!
      flash[:notice] = 'This RMA is complete.'
    else
      flash[:error] = 'Something when wrong!'
    end

    render :action => 'show'
  end
  # DELETE /return_authorizations/1
  def destroy
    load_info
    @return_authorization = ReturnAuthorization.find(params[:id])

      if @return_authorization.cancel!
        redirect_to(admin_rma_order_return_authorization_url(@order, @return_authorization), :notice => 'Return authorization was successfully updated.')
      else
        flash[:notice] = 'Return authorization had an error.'
        form_info
        render :action => "edit"
      end
  end
private

  def allowed_params
    params.require(:return_authorization).permit( :amount, :restocking_fee, :order_id, :active)
  end
  def form_info
    @return_conditions  = ReturnCondition.select_form
    @return_reasons     = ReturnReason.select_form
  end

  def load_info
    @order = Order.includes([:ship_address, :invoices,
                             {:shipments => :shipping_method},
                             {:order_items => [
                                                {:variant => [:product, :variant_properties]}]
                              }]).find(params[:order_id])
  end

  def sort_column
    return 'users.last_name' if params[:sort] == 'user_name'
    ReturnAuthorization.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
