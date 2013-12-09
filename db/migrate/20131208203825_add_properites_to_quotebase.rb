class AddProperitesToQuotebase < ActiveRecord::Migration
  def change
    add_column :quotebases, :properties, :hstore, default: '', null: false
  end
end
