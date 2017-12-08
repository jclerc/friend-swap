require 'test_helper'

class FriendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @friend = friends(:one)
  end

  test "should get index" do
    get friends_url
    assert_response :success
  end

  test "should get new" do
    get new_friend_url
    assert_response :success
  end

  test "should create friend" do
    assert_difference('Friend.count') do
      post friends_url, params: { friend: { birthday: @friend.birthday, city_id: @friend.city_id, description: @friend.description, first_name: @friend.first_name, is_male: @friend.is_male, user_id: @friend.user_id } }
    end

    assert_redirected_to friend_url(Friend.last)
  end

  test "should show friend" do
    get friend_url(@friend)
    assert_response :success
  end

  test "should get edit" do
    get edit_friend_url(@friend)
    assert_response :success
  end

  test "should update friend" do
    patch friend_url(@friend), params: { friend: { birthday: @friend.birthday, city_id: @friend.city_id, description: @friend.description, first_name: @friend.first_name, is_male: @friend.is_male, user_id: @friend.user_id } }
    assert_redirected_to friend_url(@friend)
  end

  test "should destroy friend" do
    assert_difference('Friend.count', -1) do
      delete friend_url(@friend)
    end

    assert_redirected_to friends_url
  end
end
