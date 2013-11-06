class Hand < ActiveRecord::Base
  attr_accessible :user, :game, :white_cards, :game_id

  belongs_to :user # if user is nil then the hand belongs to the game
  belongs_to :game
  has_many :white_cards

  validates :game, presence: true
end
