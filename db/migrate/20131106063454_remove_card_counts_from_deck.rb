class RemoveCardCountsFromDeck < ActiveRecord::Migration
  def change
    change_table :decks do |t|
      t.remove :num_white_cards
      t.remove :num_black_cards
    end
  end
end
