class RemoveCardCountsFromDeck < ActiveRecord::Migration
  def change
    remove_column :decks, :num_white_cards, :integer
    remove_column :decks, :num_black_cards, :integer
  end
end
