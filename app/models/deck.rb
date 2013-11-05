class Deck < ActiveRecord::Base
  attr_accessible :name, :num_black_cards, :num_white_cards

  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: true
end
