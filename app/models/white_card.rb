class WhiteCard < ActiveRecord::Base
  attr_accessible :content

  belongs_to :deck
  belongs_to :hand

  validates :content, :deck, presence: true
end
