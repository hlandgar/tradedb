class AddUserIdToSecurities < ActiveRecord::Migration
  def change
    add_column :securities, :user_id, :integer
  end
end
