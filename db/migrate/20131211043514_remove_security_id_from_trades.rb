class RemoveSecurityIdFromTrades < ActiveRecord::Migration
  def change
  	remove_column :trades, :security_id
  end
end
