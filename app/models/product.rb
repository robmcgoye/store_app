class Product < ApplicationRecord
  validates :title, :price, :stock, :length, :width, :height, :weight, presence: true
  validates :price, numericality: {greater_than: 0, less_than: 10000000}
  validates :stock, :length, :width, :height, :weight, numericality: true
  mount_uploader :picture, PictureUploader
  mount_uploader :thumbnail, ThumbnailUploader
  has_rich_text :description
  has_many :line_items
  
  after_create do
    product = Stripe::Product.create(name: title)
    price = Stripe::Price.create(product: product, unit_amount: self.price, currency: "usd")
    update(stripe_product_id: product.id, stripe_price_id: price.id)
  end

  after_update do
    if saved_change_to_price?
      Stripe::Price.update(self.stripe_price_id, active: false)
      price = Stripe::Price.create(product: self.stripe_product_id, unit_amount: self.price, currency: "usd")
      update(stripe_price_id: price.id)
    end
  end

  before_destroy do
    Stripe::Product.update(self.stripe_product_id, active: false)
  end

end
