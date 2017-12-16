module ExchangesHelper
  def distinct_friends(e, user = current_user)
    # Set user's friend in first, other in second
    [e.friend_initier, e.friend_receiver].tap { |o| o.reverse! unless e.friend_initier.user == user }
  end
end
