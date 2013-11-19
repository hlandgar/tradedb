class AddStop2ToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :stop2, :decimal
  end
end
