class Deck < ActiveRecord::Base
  attr_accessible :name, :num_black_cards, 
    :num_white_cards, :user, :game

  belongs_to :user
  belongs_to :game # if game_id is nil then the deck is not being played
  has_many :white_cards

  validates :name, presence: true
end
