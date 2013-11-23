class AddSecondTargetAndSellpctToTrade < ActiveRecord::Migration
  def change
    add_column :trades, :second_target, :boolean
    add_column :trades, :sellpct, :float
  end
end
