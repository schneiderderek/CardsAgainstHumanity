module GamesHelper
  def user_in_game(user, game)
    current_user.hands.each { |h| return true if h.game_id == game.id}
    return false
  end
end
