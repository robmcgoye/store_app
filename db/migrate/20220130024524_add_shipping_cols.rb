class AddShippingCols < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :shipping_rate, :string
    add_column :orders, :shipping_courier, :string
    add_column :products, :length, :integer
    add_column :products, :width, :integer
    add_column :products, :height, :integer
    add_column :products, :weight, :integer

  end
end
