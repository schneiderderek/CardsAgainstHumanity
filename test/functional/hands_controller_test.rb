require 'test_helper'

class HandsControllerTest < ActionController::TestCase
  setup do
    @hand = hands(:user_1_hand)
    @user = users(:default)
    @game = games(:default)
  end

  test "should show hand" do
    get :show, game_id: @game.id
    assert_response :success
  end

  test "should destroy hand" do
    assert_difference('Hand.count', -1) do
      delete :destroy, game_id: @game.id
    end
  end
end
