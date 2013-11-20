class Hand < ActiveRecord::Base
  attr_accessible :user, :game, :white_cards, :game_id, :user_id

  belongs_to :user # if user is nil then the hand belongs to the game
  belongs_to :game
  has_many :white_cards

  validates :game, presence: true

  after_save :populate_hand!

  private

  def populate_hand!
    self.game.deck.white_cards.to_a.sample(10 - self.white_cards.count).each do |card|
      card.deck = nil
      card.hand = self
      card.user = self.user
      card.save
    end if self.user
  end
end
