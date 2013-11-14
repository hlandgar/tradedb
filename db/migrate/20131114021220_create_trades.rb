class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.string :user_id
      t.string :integer
      t.boolean :open
      t.string :comments
      t.string :string

      t.timestamps
    end
    add_index :trades, [:user_id, :created_at]
  end
end
