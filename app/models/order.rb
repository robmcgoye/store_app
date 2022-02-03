class Order < ApplicationRecord
  has_many :line_items
  belongs_to :user
  
  def shipping_address
    Address.find_by_id(self.address_id)
  end

end
