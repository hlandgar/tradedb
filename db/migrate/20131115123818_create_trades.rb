class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :user_id
      t.decimal :fill
      t.decimal :stop
      t.decimal :targ1
      t.decimal :targ2
      t.float :prob1
      t.float :prob2
      t.decimal :pl
      t.string :desc
      t.string :comments
      t.float :kelly
      t.boolean :open
      t.integer :position
      t.integer :symbol_id

      t.timestamps
    end
    add_index :trades, [:user_id, :created_at]
    add_index :trades, :symbol_id
  end
end
