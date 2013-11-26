class ChangeKellyFractionToIntegerInUsers < ActiveRecord::Migration
  def change
  	reversible do |dir|
  		change_table :users do |t|
  			dir.up 	{ t.change :kelly_fraction, :integer }
  			dir.down { t.change :kelly_fraction, :float }
  		end
  	end

  end
end
