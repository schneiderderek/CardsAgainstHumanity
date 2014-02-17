class Content < ActiveRecord::Base
  attr_accessible :text

  has_many :black_cards
  has_many :white_cards
end
