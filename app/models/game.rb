class Game < ActiveRecord::Base
  attr_accessible :players, :name, :max_players, :finished, :deck
  
  has_many :users
  has_one :deck
  has_many :hands, through: :users

  validates :name, :max_players, :deck, presence: true
end
