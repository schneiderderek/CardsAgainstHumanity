class Game < ActiveRecord::Base
  attr_accessible :name, :max_players, :finished, 
                  :deck, :users, :hands, :game_id,
                  :game

  attr_protected :original_deck_id
  
  has_one :black_card, dependent: :destroy
  has_one :deck, dependent: :destroy
  has_many :hands, dependent: :destroy
  has_many :users, through: :hands
  has_many :submissions, dependent: :destroy

  validates :name, :max_players, :deck, presence: true

  after_create :initialize_game_components!

  def initialize_game_components!
    self.deck.duplicate_for_game(self.original_deck_id)
    self.new_round!
    self.round = 0
  end

  def new_round!
    if !self.finished
      self.submissions.each { |s| s.destroy }
      self.black_card.destroy if self.black_card
      
      # Assign a black card
      new_black_card = self.deck.black_cards.to_a.sample(1).first
      new_black_card.update_attributes(deck: nil, game: self)

      # Pick a new card czar
      if self.users.where("user_id > #{self.czar_id}").count > 0
        self.czar_id = self.users.where("user_id > #{self.czar_id}").order('id ASC').first.id
      elsif self.users.first
        self.czar_id = self.users.order('id ASC').first.id
      end

      # Populate all user hands, and set # submissions value
      self.hands.each do |h|
        h.populate_hand!
        h.submissions_left = (h.user.nil? || h.user.id == self.czar_id) ? 0 : new_black_card.num_blanks
        h.save
      end

      self.round += 1

      self.save
    end
  end

  def czar
    User.find(czar_id)
  end
end
