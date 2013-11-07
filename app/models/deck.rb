class Deck < ActiveRecord::Base
  attr_accessible :name, :game, :white_cards, 
    :black_cards

  belongs_to :game # if game_id is nil then the deck is not being played
  has_many :white_cards
  has_many :black_cards

  validates :name, presence: true

  before_create :duplicate_for_game

  def duplicate_for_game
    # asdasd
    deck = self.dup
    deck.game = new_game
    deck.white_cards.each { |c| c.duplicate_for(deck) } 
    deck.black_cards.each { |c| c.duplicate_for(deck) }
    deck.save
  end
end
