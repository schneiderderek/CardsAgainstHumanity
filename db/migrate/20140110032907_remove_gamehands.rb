class RemoveGamehands < ActiveRecord::Migration
  def up
    remove_column :white_cards, :user_id

    # Remove all of the game hands to make way for submissions.
    Hand.where(user_id: nil).each do |h|
      h.destroy
    end
  end

  def down
    add_column :white_cards, :user_id

    # Re-create a game hand for each game
    Game.all.keep_if { |x| !x.finished }.each do |g|
      Hand.create(user_id: nil, game_id: g.id)
    end
  end
end
