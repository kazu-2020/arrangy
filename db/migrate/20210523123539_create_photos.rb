class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string :url, null: false
      t.references :arrangement, foreign_key: true

      t.timestamps
    end
  end
end
