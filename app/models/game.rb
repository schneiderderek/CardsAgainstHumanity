class Game < ActiveRecord::Base
  attr_accessible :players, :name, :max_players, :finished, 
    :deck, :users, :hands

  attr_protected :original_deck_id
  
  has_one :black_card
  has_one :deck
  has_many :hands
  has_many :users, through: :hands

  validates :name, :max_players, :deck, presence: true

  after_create :initialize_game_components!

  def initialize_game_components!
    # Duplicate deck
    self.deck.duplicate_for_game(self.original_deck_id)

    # Create hand (for submitted cards)
    self.hands.new(game: self).save

    # Assign a black card
    black_card = self.deck.black_cards.to_a.sample(1)[0]
    black_card.deck = nil
    black_card.game = self
    black_card.save
  end
end
