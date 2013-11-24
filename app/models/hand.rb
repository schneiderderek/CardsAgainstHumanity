class Hand < ActiveRecord::Base
  attr_accessible :user, :game, :white_cards, :game_id, :user_id

  belongs_to :user # if user is nil then the hand belongs to the game
  belongs_to :game
  has_many :white_cards

  validates :game, presence: true

  after_save :populate_hand!, :end_game

  def populate_hand!
    self.game.deck.white_cards.to_a.sample(10 - self.white_cards.count).each do |card|
      card.deck = nil
      card.hand = self
      card.user = self.user
      card.save
    end if self.user_id
  end

  def end_game
    if self.score >= 7
      self.game.finished = true
      self.game.save
    end
  end
end
