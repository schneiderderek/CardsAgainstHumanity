class Submission < ActiveRecord::Base
  attr_accessible :hand_id, :game_id, :content 

  belongs_to :game
  belongs_to :hand

  validate :user_and_game_valid

  def user_and_game_valid
    # [:hand, :user].each do |c|
    #   model = c.to_s.
    #   model_id = c.to_s << '_id'
    #   errors.add(s.to_s + "#{model} does not exist") unless "#{model}".where(id: ).count > 0
    # end
    errors.add(:hand_id, "Hand does not exist") unless Hand.where(id: hand_id).count > 0
    errors.add(:game_id, "Game does not exist") unless Game.where(id: game_id).count > 0
  end
end
