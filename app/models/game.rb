class Game < ActiveRecord::Base
  attr_accessible :players, :name, :max_players, :finished
  
  has_many :users

  validates :name, :max_players, presence: true
end
