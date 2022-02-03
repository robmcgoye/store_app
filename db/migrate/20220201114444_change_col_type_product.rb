class ChangeColTypeProduct < ActiveRecord::Migration[6.1]
  def change
    change_column :products, :length, :decimal, null: true
    change_column :products, :width, :decimal, null: true
    change_column :products, :height, :decimal, null: true
  end
end
