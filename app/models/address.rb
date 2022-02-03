class Address < ApplicationRecord
  validates :address_line_1, :city, :state, :zip, presence: true
  belongs_to :user
  has_one :order

end
