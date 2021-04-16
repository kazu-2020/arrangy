class AddLikesAndArrangementsCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :likes_count, :bigint, default: 0
    add_column :users, :arrangements_count, :bigint, default: 0
  end
end
