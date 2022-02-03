class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: false
      t.string :status
      t.string :tracking_info
      t.text :notes

      t.timestamps
    end

    create_table :line_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :sold_price
      t.integer :quantity

      t.timestamps
    end
  
  end
end
