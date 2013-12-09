class RemoveIndexOnTradesSecurityId < ActiveRecord::Migration
  def change
  	remove_index :trades, :security_id
  end
end
