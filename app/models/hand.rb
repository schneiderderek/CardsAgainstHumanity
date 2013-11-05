class Hand < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user # if user is nil then the hand belongs to the game
  belongs_to :game

  validates :game, presence: true
end
