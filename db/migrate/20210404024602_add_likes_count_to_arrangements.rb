class AddLikesCountToArrangements < ActiveRecord::Migration[6.0]
  def change
    add_column :arrangements, :likes_count, :bigint, default: 0
  end
end
