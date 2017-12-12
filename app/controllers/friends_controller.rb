class FriendsController < ApplicationController
  before_action :set_friend, only: %i[show edit update]
  before_action :authenticate_user!, except: [:show]
  before_action :require_owner, only: %i[edit update]

  # GET /friends
  # GET /friends.json
  def index
    @friends = Friend.where(user: current_user)
  end

  # GET /friends/1
  # GET /friends/1.json
  def show
    if @friend.available? && @friend.user != current_user && current_user
      @friends_to_exchange = current_user.friends.select { |f| f.available? }
    else
      @friends_to_exchange = Friend.none
    end
    @can_exchange = @friends_to_exchange.any?
  end

  # GET /friends/new
  def new
    @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit; end

  # POST /friends
  # POST /friends.json
  def create
    @friend = Friend.new(friend_params_create)

    respond_to do |format|
      if @friend.save
        format.html { redirect_to @friend, notice: 'Ajout avec succès !' }
        format.json { render :show, status: :created, location: @friend }
      else
        format.html { render :new }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params_update)
        format.html { redirect_to @friend, notice: 'Informations sauvegardés !' }
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_friend
    @friend = Friend.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def friend_params_create
    params.require(:friend)
          .permit(:first_name, :birthday, :is_male, :description, :city_id, tag_relations_attributes: [:tag_id])
          .merge(user_id: current_user.id)
  end

  def tags_params_create
    params.require(:tags)
  end

  def friend_params_update
    params.require(:friend).permit(:description, :disabled)
  end

  def require_owner
    # should not happen, so an alert is not necessary
    redirect_to root_path if current_user != @friend.user && !current_user.is_admin
  end
end
