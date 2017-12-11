class AddDisabledToFriends < ActiveRecord::Migration[5.1]
  def change
    add_column :friends, :disabled, :boolean, :default => false
  end
end
