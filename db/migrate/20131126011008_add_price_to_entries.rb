class AddPriceToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :price, :decimal
  end
end
