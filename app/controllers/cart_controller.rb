class CartController < ApplicationController

  def add_to_cart
    product_id = params[:id].to_i
    product = Product.find_by_id(product_id)
    if product.stock > 0
      product_to_add = {"id" => product_id, "quantity" => params[:quantity].to_i}
      session[:cart] << product_to_add unless session[:cart].any?{|prod| prod["id"] == product_id}
    else
      flash[:alert] = "#{product.title} is out of stock" 
    end
    redirect_to cart_index_path
  end

  def remove_from_cart
    session[:cart].delete_if{ |p| p["id"] == params[:id].to_i}
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
    product = Product.find_by_id(product_id)
    if product.stock >= quantity
      cart_index = session[:cart].index{|s| s["id"] == product_id}
      if cart_index.is_a? Integer
        session[:cart][cart_index]["quantity"] = quantity
      end
    else
      flash[:alert] = "That quantity exceeds the stock of #{product.title}" 
    end
    redirect_to cart_index_path
  end

end
