class AddCommentsCountToArrangement < ActiveRecord::Migration[6.0]
  def change
    add_column :arrangements, :comments_count, :bigint, default: 0
  end
end
