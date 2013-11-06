class Game < ActiveRecord::Base
  attr_accessible :players, :name, :max_players, :finished, 
    :deck, :users, :hands
  
  has_one :deck
  has_many :users
  has_many :hands, through: :users

  validates :name, :max_players, :deck, presence: true

  before_create :initialize_game_components!

  def initialize_game_components!
    self.deck = self.deck.dup
    self.deck.save
    hand = Hand.new(game_id: self.id)
  end
end
