class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def index
    # shipping_containers = {small: { dimensions: [8.5, 5.25, 1.5], weight_limit: 1120 }, 
    #              medium_1: { dimensions: [11, 8.25, 5.5], weight_limit: 1120 }, 
    #              medium_2: { dimensions: [13.5, 11.5, 3.25], weight_limit: 1120 }, 
    #              large: { dimensions: [12, 12.25, 6], weight_limit: 1120 }, 
    #              surfboard: { dimensions: [5, 120, 25], weight_limit: 1120 }}

    if @cart.length > 0
      if current_user.current_address_id.present? && current_user.addresses.find_by_id(current_user.current_address_id).present?
        @address = current_user.addresses.find(current_user.current_address_id)
      else
        @address = Address.new
      end
      #@container_items = get_cart_dimensions

      #@container = EasyBoxPacker.find_smallest_container(
      #  items: @container_items
      #)
      #byebug 
      # @container = EasyBoxPacker.find_smallest_container(
      #   items: @container_items
      # )
      # byebug
    else
      redirect_to cart_index_path
    end 
  end

  def update
    @address = new_address(address_params.except(:update_user_address))
    if @address.save
      if params[:update_user_address]
        user_address = Address.find_by_id(current_user.current_address_id)
        user_address.update(address_params)
      end
      @session = get_stripe_checkout_session
      new_order(@address.id, @session.id)
      redirect_to @session.url
    else
      render 'index'
    end
  end
  
  def create
    @address = new_address(address_params.except(:save_user_address))
    if @address.save
      if params[:save_user_address]
        current_user.update(current_address_id:  @address.id)
        ship_to_address = new_address(address_params)
        ship_to_address.save
      else
        ship_to_address = @address
      end
      @session = get_stripe_checkout_session
      new_order(ship_to_address.id, @session.id)
      redirect_to @session.url
    else
      render 'index'
    end
  end

  def success
    if params[:session_id].present? 
      session[:cart] = [] # empty cart = empty array
      @order = Order.find_by_stripe_session_id(params[:session_id])
      if !@order.present?
        @order.update(status: "Paid")

      end
      #@session_with_expand = Stripe::Checkout::Session.retrieve({ id: params[:session_id], expand: ["line_items"]})
      #@session_with_expand.line_items.data.each do |line_item|
      #  product = Product.find_by(stripe_product_id: line_item.price.product)
      #end
    else
      redirect_to root_path, alert: "No info to display"
    end
  end

  def cancel
    flash[:notice] = "Checkout was canceled."
    redirect_to root_path
  end
  
  private

  def new_address(address_hash)
    address = Address.new(address_hash)
    address.user = current_user
    return address
  end

  def build_cart_items
    line_items = []
    @cart.each do |item|
      line_item = {price: item.stripe_price_id, quantity: get_quantity(item.id)}
      line_items << line_item
    end
    line_items
  end
  
  def get_cart_dimensions
    line_items = []
    @cart.each do |item|
      line_item = { dimensions: [item.length.to_f, item.height.to_f, item.width.to_f].sort }
      get_quantity(item.id).times { line_items << line_item }
    end
    line_items    
  end

  def address_params
    params.require(:address).permit(:address_line_1, :address_line_2, :city, 
                              :state, :zip, :save_user_address, :update_user_address)
  end

  def get_stripe_checkout_session
    line_items = build_cart_items
    Stripe::Checkout::Session.create({
       customer: current_user.stripe_customer_id,
       payment_method_types: ['card'],
       line_items: line_items,
       mode: 'payment',
       success_url: success_url + "?session_id={CHECKOUT_SESSION_ID}",
       cancel_url: cancel_url,
     })
      #  shipping_options: [shipping_rate_data: 
      #     { display_name: "USPS Priority Mail", 
      #       type: "fixed_amount",
      #       tax_behavior: 'exclusive', 
      #       fixed_amount: { amount: 1000, currency: 'usd' }
      #     } ], 
     # automatic_tax: { enabled: true }, 
     # allow_promotion_codes: true,
     # billing_address_collection: 'required',  
  end

  def new_order(address_id, session_id)
    new_order = Order.create!(
        user: current_user, 
        address_id: address_id, 
        stripe_session_id: session_id, 
        status: "PENDING"
    )
    @cart.each do |item|
      LineItem.create!(
        product_id: item.id, 
        sold_price: item.price, 
        quantity: get_quantity(item.id), 
        order: new_order
      )
    end
  end

end
