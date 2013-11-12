class BlackCard < ActiveRecord::Base
  attr_accessible :content, :deck
  attr_readonly :num_blanks

  belongs_to :deck
  belongs_to :game 

  before_validation :set_num_blanks!

  validates :content, :deck, presence: true
  validate :validate_content


  def duplicate_for(new_deck)
    black_card = self.dup
    black_card.deck = new_deck
    black_card.save
  end

  private
  def validate_content
    self.content.split(/ /).each do |s| 
      if s.count("_") > 1 
        errors.add(:content, "content does not match black card format")
        return false
      end
    end
  end

  def set_num_blanks!
    self.num_blanks = 0
    self.content.split(/ /).each { |s| self.num_blanks+= 1 if s.count("_") > 0 }
    self.num_blanks = 1 if self.num_blanks == 0
  end
end
