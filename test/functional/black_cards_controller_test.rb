require 'test_helper'

class BlackCardsControllerTest < ActionController::TestCase
  setup do
    @black_card = black_cards(:one)
    @deck = decks(:default)
  end

  test "should get index" do
    get :index, deck_id: @deck
    assert_response :success
    assert_not_nil assigns(:black_cards)
  end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create black_card" do
  #   assert_difference('BlackCard.count') do
  #     post :create, black_card: {  }
  #   end

  #   assert_redirected_to black_card_path(assigns(:black_card))
  # end

  test "should show black_card" do
    get :show, id: @black_card
    assert_response :success
  end

  # test "should get edit" do
  #   get :edit, id: @black_card
  #   assert_response :success
  # end

  # test "should update black_card" do
  #   put :update, id: @black_card, black_card: {  }
  #   assert_redirected_to black_card_path(assigns(:black_card))
  # end

  test "should destroy black_card" do
    assert_difference('BlackCard.count', -1) do
      delete :destroy, id: @black_card
    end

    # assert_redirected_to black_cards_path
  end
end
