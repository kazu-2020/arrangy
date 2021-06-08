class AddForeignKeyToAuthentications < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :authentications, :users
    add_index :authentications, :user_id
  end
end
