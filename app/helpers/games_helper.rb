module GamesHelper
  def user_in_game(user, game)
    current_user.hands.each { |h| return true if h.game_id == game.id}
    return false
  end

  def join_or_resume_button(current_user, game)
    if user_in_game(current_user, game)
      link_to 'Resume', game_path(game), class: 'btn btn-success'
    else
      link_to 'Join', game_hand_path(game), method: :post, data: { confirm: 'Are you sure?' }, class: 'btn btn-primary'
    end
  end
end
