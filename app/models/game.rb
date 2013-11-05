class Game < ActiveRecord::Base
  attr_accessible :players, :name
  
  has_many :users

  validates :name, presence: true
end
