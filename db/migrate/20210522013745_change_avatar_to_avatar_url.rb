class ChangeAvatarToAvatarUrl < ActiveRecord::Migration[6.0]
  def up
    rename_column :users, :avatar, :avatar_url
    change_column_default :users, :avatar_url, from: nil, to: '/images/default_avatar.png'
  end

  def down
    rename_column :users, :avatar_url, :avatar
    change_column_default :users, :avatar_url, from: '/images/default_avatar.png', to: nil
  end
end
