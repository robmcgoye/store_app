class UpdateColumnToActionText < ActiveRecord::Migration[6.1]
  def change
    change_column :pages, :body, :rich_text
  end
end
