require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    @game = games(:default)
    @game.update_attributes(czar_id: users(:default).id)
    @deck = decks(:default_in_game)
    sign_in users(:default)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post :create, game: { name: 'New Game', max_players: 20, deck: @deck }
    end

    assert_redirected_to game_path(assigns(:game))
  end

  test "should show game" do
    get :show, id: @game.id
    assert_response :success
  end
end
