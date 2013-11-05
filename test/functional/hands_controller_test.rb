require 'test_helper'

class HandsControllerTest < ActionController::TestCase
  setup do
    @hand = hands(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hands)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hand" do
    assert_difference('Hand.count') do
      post :create, hand: {  }
    end

    assert_redirected_to hand_path(assigns(:hand))
  end

  test "should show hand" do
    get :show, id: @hand
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hand
    assert_response :success
  end

  test "should update hand" do
    put :update, id: @hand, hand: {  }
    assert_redirected_to hand_path(assigns(:hand))
  end

  test "should destroy hand" do
    assert_difference('Hand.count', -1) do
      delete :destroy, id: @hand
    end

    assert_redirected_to hands_path
  end
end
