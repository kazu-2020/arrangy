class AddArrangeLevelToArrangements < ActiveRecord::Migration[6.0]
  def change
    add_column :arrangements, :arrange_level, :integer, null: false, default: 0
  end
end
