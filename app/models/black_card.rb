class BlackCard < ActiveRecord::Base
  attr_accessible :content, :deck, :game
  attr_readonly :num_blanks

  belongs_to :deck
  belongs_to :game
  belongs_to :content

  before_validation :set_num_blanks!

  validates :content, presence: true
  validate :validate_content

  def duplicate_for(new_deck)
    black_card = self.dup
    black_card.update_attributes deck: new_deck
  end

  private
  def validate_content
    self.content.text.split(/ /).each do |s|
      if s.count('_') > 1
        errors.add(:content, 'content does not match black card format')
        return false
      end
    end
  end

  def set_num_blanks!
    self.num_blanks = 0
    self.content.text.split(/ /).each { |s| self.num_blanks += 1 if s.count('_') > 0 }
    self.num_blanks = 1 if self.num_blanks == 0
  end
end
