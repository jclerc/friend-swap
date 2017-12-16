class Tag < ApplicationRecord
  MIN_ASSOC = 2
  MAX_ASSOC = 5

  has_many :tag_relations
  has_many :friends, through: :tag_relations

  def label(test)
    return test.is_male ? label_male : label_female if test.is_a? Friend
    test ? label_male : label_female
  end

  def friends_grouped
    groups = Hash.new(0)
    friends.each do |friend|
      groups[friend] += 1
    end
    groups
  end

  def friends_sorted(asc = false)
    friends_grouped.sort_by { |_, v| v }.tap { |o| o.reverse! unless asc }
  end

  def self.best_tags_by_city
    # NOTE 1: can't scope this method as it has some logic code associated, and is highly specific
    # NOTE 2: here we are quering, then filtering results by ourselves...
    tags_by_city = Tag.select('tags.*, '\
                              'cities.id as city_id, '\
                              'cities.name as city_name, '\
                              'COUNT(DISTINCT friends.id) as count')
                      .joins(:tag_relations)
                      .joins(:friends)
                      .joins('INNER JOIN cities ON cities.id = friends.city_id')
                      .where('friends.disabled' => false)
                      .group('cities.id, tags.id')
    hash = Hash.new(0)
    tags_by_city.each do |tag|
      hash[tag.city_id] = [tag.count, tag] if tag.count > hash[tag.city_id][0]
    end
    hash.values.sort_by { |entry| entry[0] }.reverse.map { |entry| entry[1] }

    # ... as the following query works in SQLite, but not in PostgreSQL
    # Tag.select('id, label_male, city_name, city_id, MAX(friends_count) as count')
    #                    .from(
    #                      Tag.select(
    #                        'tags.*, '\
    #                        'cities.id as city_id, '\
    #                        'cities.name as city_name, '\
    #                        'COUNT(DISTINCT friends.id) as friends_count'
    #                      )
    #                      .joins(:tag_relations)
    #                      .joins(:friends)
    #                      .joins('INNER JOIN cities ON cities.id = friends.city_id')
    #                      .where('friends.disabled' => false)
    #                      .group('cities.id, tags.id')
    #                   )
    #                   .group('city_id')
    #                   .order('count DESC')
  end

  # VALIDATION

  validates :label_male, presence: true
  validates :label_female, presence: true
end
