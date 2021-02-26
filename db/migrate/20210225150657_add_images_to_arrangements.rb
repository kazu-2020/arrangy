class AddImagesToArrangements < ActiveRecord::Migration[6.0]
  def change
    add_column :arrangements, :images, :json, null: false, after: :context
  end
end
