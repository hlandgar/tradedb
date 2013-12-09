class AddSymbolToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :symbol, :string
  end
end
