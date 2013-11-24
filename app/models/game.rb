class Game < ActiveRecord::Base
  attr_accessible :players, :name, :max_players, :finished, 
    :deck, :users, :hands

  attr_protected :original_deck_id
  
  has_one :black_card, dependent: :destroy
  has_one :deck, dependent: :destroy
  has_many :hands, dependent: :destroy
  has_many :users, through: :hands

  validates :name, :max_players, :deck, presence: true

  after_create :initialize_game_components!

  def initialize_game_components!
    # Duplicate deck
    self.deck.duplicate_for_game(self.original_deck_id)

    # Create hand (for submitted cards)
    self.hands.new(game: self).save

    self.new_round!
  end

  def new_round!
    if !self.finished
      self.hands.where(user_id: nil).first.white_cards.each { |x| x.destroy }
      self.black_card.destroy if self.black_card
      
      # Assign a black card
      black_card = self.deck.black_cards.to_a.sample(1)[0]
      black_card.deck = nil
      black_card.game = self
      black_card.save

      # Pick a new card czar
      if self.users.where("user_id > #{self.czar_id}").count > 0
        self.czar_id = self.users.where("user_id > #{self.czar_id}").first.id
      elsif self.users.first
        self.czar_id = self.users.order('id ASC').first.id
      end

      # Populate all user hands, and set # submissions value
      self.hands.each do |h|
        h.populate_hand!
        h.submissions_left = black_card.num_blanks
        h.save
      end

      self.save
    end
  end
end
