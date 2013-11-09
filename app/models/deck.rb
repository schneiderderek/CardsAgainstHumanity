class Deck < ActiveRecord::Base
  attr_accessible :name, :game, :white_cards, 
    :black_cards

  belongs_to :game # if game_id is nil then the deck is not being played
  has_many :white_cards
  has_many :black_cards

  validates :name, presence: true

  def duplicate_for_game(original_deck_id)
    original_deck = Deck.find(original_deck_id)
    original_deck.white_cards.each { |c| c.duplicate_for self } 
    original_deck.black_cards.each { |c| c.duplicate_for self }
  end
end
