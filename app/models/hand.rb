class Hand < ActiveRecord::Base
  attr_accessible :user, :game, :white_cards, :game_id, :user_id,
                  :submissions_left

  belongs_to :user # if user is nil then the hand belongs to the game
  belongs_to :game
  has_many :white_cards, dependent: :destroy

  validates :game, presence: true

  after_save :end_game

  def populate_hand!
    self.game.deck.white_cards.to_a.sample(10 - self.white_cards.count).each do |card| 
      card.update_attributes(deck: nil, hand: self)
    end if self.user_id
  end

  def end_game
    if self.score >= self.game.max_score
      self.game.update_attributes(finished: true)
      self.user.update_attributes(wins: self.user.wins + 1)
    end
  end
end
