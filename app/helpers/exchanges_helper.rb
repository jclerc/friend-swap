module ExchangesHelper
  def distinct_friends(e, user = current_user)
    # Set user's friend in first, other in second
    [e.friend1, e.friend2].tap { |o| o.reverse! unless e.friend1.user == user }
  end
end
