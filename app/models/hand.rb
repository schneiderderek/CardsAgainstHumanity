class Hand < ActiveRecord::Base
  belongs_to :user # if user is nil then the hand belongs to the game
  belongs_to :game
  has_many :white_cards

  validates :game, presence: true
end
