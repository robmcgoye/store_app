module CartHelper

  def get_quantity(product_id)
    cart_index = session[:cart].index{|s| s["id"] == product_id}
    if cart_index.is_a? Integer
      session[:cart][cart_index]["quantity"]
    else
      0
    end
  end

end
