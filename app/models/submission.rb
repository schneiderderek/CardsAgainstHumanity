class Submission < ActiveRecord::Base
  attr_accessible :user_id, :game_id, :content 

  belongs_to :game
  belongs_to :user

  validate :user_and_game_valid

  def user_and_game_valid
    errors.add(:user_id, "User does not exist") unless User.where(id: params[:user_id]).count > 0
    errors.add(:game_id, "Game does not exist") unless Game.where(id: params[:game_id]).count > 0
  end
end
