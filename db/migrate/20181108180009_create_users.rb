class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :slack_id
      t.string :slack_name
      t.float :karma

      t.timestamps
    end
  end
end
