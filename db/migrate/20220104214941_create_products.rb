class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :picture
      t.string :thumbnail
      t.integer :price

      t.timestamps
    end
  end
end