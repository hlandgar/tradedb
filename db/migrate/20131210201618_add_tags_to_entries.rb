class AddTagsToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :tags, :text, array:true
    add_index :entries, :tags, using: 'gin'
  end
end
