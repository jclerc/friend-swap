class Friend < ApplicationRecord
  belongs_to :city
  belongs_to :user
  has_many :exchanges1, class_name: 'Exchange', foreign_key: 'friend1_id'
  has_many :exchanges2, class_name: 'Exchange', foreign_key: 'friend2_id'
  has_many :tag_relations, inverse_of: :friend
  has_many :tags, through: :tag_relations

  def exchanges
    exchanges1 << exchanges2
  end

  def tags_grouped
    groups = Hash.new(0)
    tags.each do |tag|
      groups[tag] += 1
    end
    groups
  end

  def tags_sorted(asc = false)
    tags_grouped.sort_by { |_, v| v }.tap { |o| o.reverse! unless asc }
  end

  def available?
    exchanges.none?(&:is_active)
  end

  # VALIDATION

  validates :first_name, length: { in: 3..50 }
  validates :birthday, presence: true
  validates :description, length: { in: 10..500 }
  validates :city_id, presence: true
  validates :user_id, presence: true

  validate :disable_while_exchanged
  validate :validate_age
  validate :check_tags_count, on: :create

  accepts_nested_attributes_for :tag_relations

  def disable_while_exchanged
    errors.add(:disabled, ': impossible de désactiver pendant un échange en cours') if disabled && !available?
  end

  def validate_age
    if birthday.present? && (birthday > 13.years.ago || birthday < 90.years.ago)
      errors.add(:birthday)
    end
  end

  def check_tags_count
    # Using length as they are not saved in database yet
    l = tag_relations.length
    errors.add(:tags, ': choisis entre 2 et 5 tags') if l < Tag::MIN_ASSOC || l > Tag::MAX_ASSOC
  end
end
