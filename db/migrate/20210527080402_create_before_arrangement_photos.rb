class CreateBeforeArrangementPhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :before_arrangement_photos do |t|
      t.string :url, null: false
      t.references :arrangement, null: false, foreign_key: true

      t.timestamps
    end
  end
end
