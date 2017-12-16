class PagesController < ApplicationController
  def index
    @city = City.first
    @most_traded = Friend.active.with_exchanges_count :desc
    @tags_by_city = Tag.best_tags_by_city
  end

  def search
    # Validate tags
    @tags = Tag.where(id: (params[:tag] || params[:tags].try(:reject, &:empty?)))
    tag_ids = @tags.map(&:id)
    # Validate city
    @city = City.find_by_id(params[:city])
    if @city.blank?
      redirect_to root_path
    elsif tag_ids.blank?
      @results = Friend.active.city(@city).latest
    else
      @results = Friend.active.city(@city).with_tags(tag_ids, :desc)
    end
  end
end
