require 'test_helper'

class WhiteCardsControllerTest < ActionController::TestCase
  setup do
    @white_card = white_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:white_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create white_card" do
    assert_difference('WhiteCard.count') do
      post :create, white_card: {  }
    end

    assert_redirected_to white_card_path(assigns(:white_card))
  end

  test "should show white_card" do
    get :show, id: @white_card
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @white_card
    assert_response :success
  end

  test "should update white_card" do
    put :update, id: @white_card, white_card: {  }
    assert_redirected_to white_card_path(assigns(:white_card))
  end

  test "should destroy white_card" do
    assert_difference('WhiteCard.count', -1) do
      delete :destroy, id: @white_card
    end

    assert_redirected_to white_cards_path
  end
end
