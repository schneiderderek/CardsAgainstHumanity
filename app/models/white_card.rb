class WhiteCard < ActiveRecord::Base
  attr_accessible :content, :deck, :hand

  belongs_to :deck
  belongs_to :hand

  validates :content, presence: true
  validate :deck_or_hand

  def duplicate_for(new_deck)
    white_card = self.dup
    white_card.deck = new_deck
    white_card.hand = nil
    white_card.save
  end

  private
  def deck_or_hand
    errors.add :white_card, "White card cannot be assigned to a hand and deck" if self.hand && self.deck
    errors.add :white_card, "White card needs to be assigned to a hand or deck" unless self.hand || self.deck
  end
end
