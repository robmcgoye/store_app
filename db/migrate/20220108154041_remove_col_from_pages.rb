class RemoveColFromPages < ActiveRecord::Migration[6.1]
  def change
      remove_column :pages, :body
  end
end
