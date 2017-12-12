class Exchange < ApplicationRecord
  belongs_to :friend1, class_name: 'Friend', foreign_key: 'friend1_id'
  belongs_to :friend2, class_name: 'Friend', foreign_key: 'friend2_id'
  has_many :tag_relations

  def friends
    [friend1, friend2]
  end
end
