class AddEdgeToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :edge, :float
  end
end
