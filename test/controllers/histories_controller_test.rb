require 'test_helper'

class HistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @history = histories(:one)
  end

  test "should get index" do
    get histories_url, as: :json
    assert_response :success
  end

  test "should create history" do
    assert_difference('History.count') do
      post histories_url, params: { history: { description: @history.description, giver_id: @history.giver_id, karma: @history.karma, receiver_id: @history.receiver_id } }, as: :json
    end

    assert_response 201
  end

  test "should show history" do
    get history_url(@history), as: :json
    assert_response :success
  end

  test "should update history" do
    patch history_url(@history), params: { history: { description: @history.description, giver_id: @history.giver_id, karma: @history.karma, receiver_id: @history.receiver_id } }, as: :json
    assert_response 200
  end

  test "should destroy history" do
    assert_difference('History.count', -1) do
      delete history_url(@history), as: :json
    end

    assert_response 204
  end
end
