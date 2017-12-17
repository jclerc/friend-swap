class ChangeFriendsColumnsOfExchange < ActiveRecord::Migration[5.1]
  def change
    rename_column :exchanges, :friend1_id, :friend_initier_id
    rename_column :exchanges, :friend2_id, :friend_receiver_id
  end
end
