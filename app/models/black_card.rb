class BlackCard < ActiveRecord::Base
  attr_accessible :num_blanks, :content, :deck

  belongs_to :deck

  validates :content, :deck, presence: true
end
