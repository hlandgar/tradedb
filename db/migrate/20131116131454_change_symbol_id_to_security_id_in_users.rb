class ChangeSymbolIdToSecurityIdInUsers < ActiveRecord::Migration
	def change
		rename_column :trades, :symbol_id, :security_id
	end
end
