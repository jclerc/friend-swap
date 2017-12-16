class City < ApplicationRecord
  has_many :friends

  # VALIDATION

  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
