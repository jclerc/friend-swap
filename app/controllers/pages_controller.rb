class PagesController < ApplicationController
  def index; end

  def search
    # Validate tags
    tags = Tag.where(id: params[:tag_ids].reject!(&:empty?))
    tag_ids = tags.map(&:id)
    # Validate city
    city = City.find_by_id(params[:city_id])
    if !city
      redirect_to root_path
    else
      @results = Friend.joins(:tag_relations)
                       .where('tag_relations.tag_id' => tag_ids)
                       .group('friends.id')
                       .having('COUNT(DISTINCT tag_relations.tag_id) = ?', tag_ids.size)
                       .order('COUNT(*) DESC')
                       .limit(50)
    end
  end
end
