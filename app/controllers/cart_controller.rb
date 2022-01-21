class CartController < ApplicationController

  def add_to_cart
    product_id = params[:id].to_i
    product_to_add = {"id" => product_id, "quantity" => params[:quantity].to_i}
    session[:cart] << product_to_add unless session[:cart].any?{|prod| prod["id"] == product_id}
    redirect_to cart_index_path
  end

  def remove_from_cart
    id = params[:id].to_i
    cart_index = session[:cart].index{|s| s["id"] == id}
    if cart_index.is_a? Integer
      session[:cart].delete_at(cart_index)
    end
    redirect_to cart_index_path
  end

  def remove_all_from_cart
    session[:cart] = []
    redirect_to cart_index_path
  end

  def index
  end

  def update_quantity
    product_id = params[:id].to_i
    quantity = params[:quantity].to_i
    cart_index = session[:cart].index{|s| s["id"] == product_id}
    if cart_index.is_a? Integer
      session[:cart][cart_index]["quantity"] = quantity
    end
    redirect_to cart_index_path
  end

end
