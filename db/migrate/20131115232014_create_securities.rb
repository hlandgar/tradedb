class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
    	t.string	"symbol"
    	t.string	"security_type"
    	t.text		"description"
    	t.string	"currency"
    	t.decimal	"tick_size"
    	t.decimal	"tickval"
    	t.integer	"sort_order"
    	t.integer	"default_spread"
    	t.integer	"decimal_places"

       t.timestamps
    end
    add_index :securities, :symbol
  end
end
