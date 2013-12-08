class AddMarketCondtionToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :market_condition, :text, array:true
    add_index :trades, :market_condition, using: 'gin'
  end
end
