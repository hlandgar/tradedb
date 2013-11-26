class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.datetime :entrytime
      t.integer :quantity
      t.integer :trade_id

      t.timestamps
    end
    add_index :entries, :trade_id
  end
end
