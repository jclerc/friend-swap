class Friend < ApplicationRecord
  belongs_to :city
  belongs_to :user
  has_many :exchanges1, class_name: 'Exchange', foreign_key: 'friend1_id'
  has_many :exchanges2, class_name: 'Exchange', foreign_key: 'friend2_id'
  has_many :tag_relations
  has_many :tags, through: :tag_relations

  def exchanges
    exchanges1 << exchanges2
  end
end
