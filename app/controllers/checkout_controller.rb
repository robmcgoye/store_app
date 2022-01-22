class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    line_items = build_cart_items
    #byebug
    @session = Stripe::Checkout::Session.create({
      customer: current_user.stripe_customer_id,
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cancel_url,
    })
    redirect_to @session.url
          #allow_promotion_codes: true,
      #billing_address_collection: 'required',  
  end

  def success
    if params[:session_id].present? 
      session[:cart] = [] # empty cart = empty array
      #@session_with_expand = Stripe::Checkout::Session.retrieve({ id: params[:session_id], expand: ["line_items"]})
      #@session_with_expand.line_items.data.each do |line_item|
      #  product = Product.find_by(stripe_product_id: line_item.price.product)
      #end
    else
      redirect_to cancel_url, alert: "No info to display"
    end
  end

  def cancel
  end
  
  private

  def build_cart_items
    line_items = []
    @cart.each do |item|
      line_item = {price: item.stripe_price_id, quantity: get_quantity(item.id)}
      line_items << line_item
    end
    line_items
 end

end
