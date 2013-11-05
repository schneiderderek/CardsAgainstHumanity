class Game < ActiveRecord::Base
  attr_accessible :players
  
  has_many :users
end
