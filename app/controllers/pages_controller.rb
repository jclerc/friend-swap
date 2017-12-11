class PagesController < ApplicationController
  def index
    @city = City.first
    @tags_by_city = Tag.select('tags.*, cities.name as city_name, cities.id as city_id, COUNT(DISTINCT friends.id) as count')
                       .joins(:tag_relations)
                       .joins(:friends)
                       .joins('INNER JOIN cities ON cities.id = friends.city_id')
                       .group('friends.city_id')
                       .order('count DESC')
    @most_traded = Friend.select('friends.*, COUNT(DISTINCT tag_relations.exchange_id) as exchanges_count')
                         .joins(:tag_relations)
                         .group(:id)
                         .order('exchanges_count DESC')
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
