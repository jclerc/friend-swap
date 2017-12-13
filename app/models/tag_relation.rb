class TagRelation < ApplicationRecord
  belongs_to :exchange, optional: true, inverse_of: :tag_relations
  belongs_to :tag
  belongs_to :friend, inverse_of: :tag_relations

  # VALIDATION

  validates :tag_id, presence: true
end
