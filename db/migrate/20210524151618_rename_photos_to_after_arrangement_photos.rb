class RenamePhotosToAfterArrangementPhotos < ActiveRecord::Migration[6.0]
  def change
    rename_table :photos, :after_arrangement_photos
  end
end
