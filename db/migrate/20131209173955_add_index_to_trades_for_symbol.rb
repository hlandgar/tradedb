class AddIndexToTradesForSymbol < ActiveRecord::Migration
  def change
  	add_index :trades, :symbol
  end
end
