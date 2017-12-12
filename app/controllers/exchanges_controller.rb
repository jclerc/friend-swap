class ExchangesController < ApplicationController
  include ExchangesHelper

  before_action :check_and_set_exchange, only: %i[get_finish post_finish get_rate post_rate]
  before_action :check_exchange_active, only: %i[get_finish post_finish]
  before_action :check_exchange_unactive_unrated, only: %i[get_rate post_rate]
  before_action :authenticate_user!

  def index
    friends = current_user.friends
    @exchanges = Exchange.where(friend1_id: friends)
                         .or(Exchange.where(friend2_id: friends))
                         .order(updated_at: :desc)
    @exchanges_active = []
    @exchanges_past = []
    @exchanges.each do |exchange|
      (exchange.is_active ? @exchanges_active : @exchanges_past) << exchange
    end
  end

  def new
    # From get params
    @friend = Friend.find(params[:friend_id])
    @other = Friend.find(params[:other_id])
    check_exchange_author
    @exchange = Exchange.new
  end

  def create
    # From post params
    @friend = Friend.find_by_id(params[:exchange][:friend1_id])
    @other = Friend.find_by_id(params[:exchange][:friend2_id])
    check_exchange_author
    @exchange = Exchange.new(exchange_params_create)
    if @exchange.save
      redirect_to exchanges_url, notice: 'Ajout avec succès !'
    else
      render :new
    end
  end

  def get_finish
    render :finish
  end

  def post_finish
    if @exchange.update(is_active: false)
      redirect_to exchanges_get_rate_path(id: @exchange.id), notice: 'Échange terminé !'
    else
      render :finish
    end
  end

  def get_rate
    @friend = distinct_friends(@exchange).second
    render :rate
  end

  def post_rate
    @friend = distinct_friends(@exchange).second

    if @exchange.update(exchange_params_rate)
      redirect_to exchanges_path, notice: 'Informations sauvegardés !'
    else
      render :rate
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def check_and_set_exchange
    @exchange = Exchange.find(params[:id])
    # should not happen, so an alert is not necessary
    return redirect_to root_path unless @exchange.friends.count { |f| f.user == current_user } == 1
  end

  def check_exchange_active
    return redirect_to root_path unless @exchange.is_active
  end

  def check_exchange_unactive_unrated
    return redirect_to root_path if @exchange.is_active || @exchange.user_rated?(@current_user)
  end

  def check_exchange_author
    return redirect_to root_path unless @friend.user == current_user &&
                                        @friend.available? &&
                                        @other.user != current_user &&
                                        @other.available?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def exchange_params_create
    params.require(:exchange)
          .permit(:friend1_id, :friend2_id)
          .merge(is_active: true)
  end

  def exchange_params_rate
    result = params.require(:exchange)
                   .permit(tag_relations_attributes: [:tag_id])
    result[:tag_relations_attributes].map { |t| t[:friend_id] = @friend.id }
    result
  end
end
