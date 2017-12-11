class PagesController < ApplicationController
  def index
    @tags = Tag.all.limit(4)
    @city = City.first
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
      @results = Friend.order(:updated_at).limit(50)
    else
      @results = Friend.joins(:tag_relations)
                       .where('tag_relations.tag_id' => tag_ids)
                       .where(city: city)
                       .group('friends.id')
                       .having('COUNT(DISTINCT tag_relations.tag_id) = ?', tag_ids.size)
                       .order('COUNT(*) DESC')
                       .limit(50)
    end
  end
end
