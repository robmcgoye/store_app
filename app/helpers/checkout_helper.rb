module CheckoutHelper

  def address_form_url(address)
    if address.id?
      checkout_address_edit_path(address)
    else
      checkout_address_path
    end
  end

end
