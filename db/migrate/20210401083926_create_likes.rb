class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, index: false, foreign_key: true
      t.references :arrangement, null: false, index: false,  foreign_key: true

      t.timestamps
    end
    add_index :likes, [:user_id, :arrangement_id], unique: true
  end
end
