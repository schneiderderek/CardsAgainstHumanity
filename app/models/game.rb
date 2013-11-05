class Game < ActiveRecord::Base
  attr_accessible :players, :name
  
  has_many :users
end
