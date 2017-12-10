class TagRelation < ApplicationRecord
  belongs_to :exchange, optional: true
  belongs_to :tag
  belongs_to :friend
end
