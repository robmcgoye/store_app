class ApplicationController < ActionController::Base
  before_action :initialize_session
  before_action :load_cart
  helper_method :admin_user?
  helper_method :get_quantity
  
  def admin_user?
    user_signed_in? && current_user.admin?
  end

  def require_admin_user
    if !user_signed_in?
      flash[:alert] = "You must be logged in to perform that action"
      redirect_to user_session_path
    elsif !current_user.admin?
      flash[:alert] = "You must be an admin to perform that action"
      redirect_to root_path      
    end
  end

  def get_quantity(product_id)
    cart_index = session[:cart].index{|s| s["id"] == product_id}
    if cart_index.is_a? Integer
      session[:cart][cart_index]["quantity"]
    else
      0
    end
  end

  private

  def initialize_session
    session[:cart] ||= [] # empty cart = empty array
  end

  def load_cart
    # @cart = Product.find(session[:cart])
    # Product.all.pluck(:id) => 1, 2
    # Product.find(1, 2, 3) => error
    # Product.where(id: [1, 2, 3]) => 1, 2
    ids=[]
    session[:cart].each{ |s| ids << s["id"] }
    @cart = Product.where(id: ids)
  end

end
