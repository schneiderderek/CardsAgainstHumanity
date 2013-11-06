class WhiteCard < ActiveRecord::Base
  attr_accessible :content, :deck, :hand

  belongs_to :deck
  belongs_to :hand

  validates :content, :deck, presence: true

  def duplicate_for(new_deck)
    white_card = self.dup
    white_card.deck = new_deck
    white_card.hand = nil
    white_card.save
  end
end
