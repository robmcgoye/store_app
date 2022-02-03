class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_column :users, :current_address_id, :integer
    add_column :products, :stock, :integer
    add_column :products, :sales, :integer
    add_column :products, :available, :boolean
  end
end
