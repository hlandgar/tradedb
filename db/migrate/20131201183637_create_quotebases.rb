class CreateQuotebases < ActiveRecord::Migration
  def change
    create_table :quotebases do |t|
      t.string :symbol
      t.string :yahoo_symbol

      t.timestamps
    end
  end
end
