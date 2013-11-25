class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :wins, :points, :games, :decks, :hands, :game_id

  has_many :hands, dependent: :destroy
  has_many :games, through: :hands
  has_many :decks
end
