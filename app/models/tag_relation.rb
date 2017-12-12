class TagRelation < ApplicationRecord
  belongs_to :exchange, optional: true, inverse_of: :tag_relations
  belongs_to :tag
  belongs_to :friend, inverse_of: :tag_relations

  # VALIDATION

  validates :exchange_id, presence: true
  validates :tag_id, presence: true
  validates :friend_id, presence: true
end
