class CreateArrangements < ActiveRecord::Migration[6.0]
  def change
    create_table :arrangements do |t|
      t.string :title, null: false
      t.text :context, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
