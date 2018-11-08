class AddDefaultKarma < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :karma, :float, default: 0
  end
end
