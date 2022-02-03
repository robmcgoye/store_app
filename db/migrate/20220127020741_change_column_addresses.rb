class ChangeColumnAddresses < ActiveRecord::Migration[6.1]
  def change
    change_column :addresses, :user_id, :integer, null: true
  end
end
