require 'test_helper'

class ExchangesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get exchanges_index_url
    assert_response :success
  end

  test "should get new" do
    get exchanges_new_url
    assert_response :success
  end

  test "should get finish" do
    get exchanges_finish_url
    assert_response :success
  end

end
