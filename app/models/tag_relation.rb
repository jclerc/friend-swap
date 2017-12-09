class TagRelation < ApplicationRecord
  belongs_to :exchange
  belongs_to :tag
  belongs_to :friend
end
