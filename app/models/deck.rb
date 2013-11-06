class Deck < ActiveRecord::Base
  attr_accessible :name, :user, :game, :white_cards, 
    :black_cards

  belongs_to :user
  belongs_to :game # if game_id is nil then the deck is not being played
  has_many :white_cards
  has_many :black_cards

  validates :name, presence: true
end
