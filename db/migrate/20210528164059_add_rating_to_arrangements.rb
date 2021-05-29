class AddRatingToArrangements < ActiveRecord::Migration[6.0]
  def change
    add_column :arrangements, :rating, :integer, null: false
  end
end
