class AddKellyFractionAndAccountSizeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kelly_fraction, :float
    add_column :users, :account_size, :decimal
  end
end
