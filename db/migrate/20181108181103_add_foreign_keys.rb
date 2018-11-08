class AddForeignKeys < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :histories, :users, column: :giver_id, primary_key: :id
    add_foreign_key :histories, :users, column: :receiver_id, primary_key: :id
  end
end
