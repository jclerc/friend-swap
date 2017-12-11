class PagesController < ApplicationController
  def index
    @city = City.first
    @most_traded = Friend.select('friends.*, COUNT(DISTINCT tag_relations.exchange_id) as exchanges_count')
                         .joins(:tag_relations)
                         .group(:id)
                         .order('exchanges_count DESC')

    # NOTE: here we are quering then filtering results by ourselves...
    tags_by_city = Tag.select('tags.*, '\
                              'cities.id as city_id, '\
                              'cities.name as city_name, '\
                              'COUNT(DISTINCT friends.id) as count')
                      .joins(:tag_relations)
                      .joins(:friends)
                      .joins('INNER JOIN cities ON cities.id = friends.city_id')
                      .group('cities.id, tags.id')
    hash = Hash.new(0)
    tags_by_city.each do |tag|
      hash[tag.city_id] = [tag.count, tag] if tag.count > hash[tag.city_id][0]
    end
    @tags_by_city = hash.values.map { |entry| entry[1] }

    # ... as the following query works in SQLite, but not in PostgreSQL
    # @tags_by_city = Tag.select('id, label_male, city_name, city_id, MAX(friends_count) as count')
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
    #                      .group('cities.id, tags.id')
    #                   )
    #                   .group('city_id')
    #                   .order('count DESC')
  end

  def search
    # Validate tags
    tags = Tag.where(id: (params[:tag] || params[:tags].try(:reject, &:empty?)))
    tag_ids = tags.map(&:id)
    # Validate city
    city = City.find_by_id(params[:city])
    if city.blank?
      redirect_to root_path
    elsif tag_ids.blank?
      @results = Friend.order(:updated_at).where(city: city)
    else
      @results = Friend.joins(:tag_relations)
                       .where('tag_relations.tag_id' => tag_ids)
                       .where(city: city)
                       .group('friends.id')
                       .having('COUNT(DISTINCT tag_relations.tag_id) = ?', tag_ids.size)
                       .order('COUNT(*) DESC')
    end
  end
end
