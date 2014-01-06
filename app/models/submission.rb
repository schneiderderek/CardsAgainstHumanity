class Submission < ActiveRecord::Base
  attr_accessible :user_id, :game_id, :content 
end
