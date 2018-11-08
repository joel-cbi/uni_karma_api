class ChangeIdsToStrings < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :slack_id, :string
  end
end
