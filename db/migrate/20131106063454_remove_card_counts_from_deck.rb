class RemoveCardCountsFromDeck < ActiveRecord::Migration
  def change
    remove_column :decks, :num_white_cards
    remove_column :decks, :num_black_cards
  end
end
