class CreateParameters < ActiveRecord::Migration[6.0]
  def change
    create_table :parameters do |t|
      t.integer :taste, null: false, default: 3
      t.integer :spiciness, null: false, default: 3
      t.integer :sweetness, null: false, default: 3
      t.integer :satisfaction, null: false, default: 3
      t.references :arrangement, foreign_key: true

      t.timestamps
    end
  end
end
