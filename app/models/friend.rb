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

  def is_available?
    !exchanges.any?(&:is_active)
  end
end
