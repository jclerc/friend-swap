class AddAvatarToFriends < ActiveRecord::Migration[5.1]
  def self.up
    add_attachment :friends, :avatar
  end

  def self.down
    remove_attachment :friends, :avatar
  end
end
