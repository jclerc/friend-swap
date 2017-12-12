class ExchangesController < ApplicationController
  include ExchangesHelper

  before_action :set_exchange, only: %i[finish]
  before_action :authenticate_user!
  before_action :require_owner, only: %i[finish]

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

  def finish
    return redirect_to root_path unless @exchange.is_active
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exchange
    @exchange = Exchange.find(params[:id])
  end

  def check_exchange_author
    return redirect_to root_path unless @friend.user == current_user &&
                                        @friend.available? &&
                                        @other.user != current_user &&
                                        @other.available?
  end

  def require_owner
    # should not happen, so an alert is not necessary
    redirect_to root_path if @exchange.friends.none? { |f| f.user == current_user }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def exchange_params_create
    params.require(:exchange)
          .permit(:friend1_id, :friend2_id)
          .merge(is_active: true)
  end
end
