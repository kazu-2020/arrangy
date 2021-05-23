class RemoveImagesFromArrangements < ActiveRecord::Migration[6.0]
  def change
    remove_column :arrangements, :images, :json, null: false
  end
end
