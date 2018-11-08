class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.references :giver, index: true
      t.references :receiver, index: true
      t.float :karma
      t.string :description

      t.timestamps
    end
  end
end
