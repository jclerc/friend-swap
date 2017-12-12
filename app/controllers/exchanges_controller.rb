class ExchangesController < ApplicationController
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
    @friend = Friend.find(params[:friend_id])
    @other = Friend.find(params[:other_id])
    return redirect_to root_path unless @friend.user == current_user &&
                                        @friend.available? &&
                                        @other.user != current_user &&
                                        @other.available?
  end

  def finish
    return redirect_to root_path unless @exchange.is_active
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exchange
    @exchange = Exchange.find(params[:id])
  end

  def require_owner
    # should not happen, so an alert is not necessary
    redirect_to root_path if @exchange.friends.none? { |f| f.user == current_user }
  end
end
