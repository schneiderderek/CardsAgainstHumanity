class AssociationBetweenDecksAndGames < ActiveRecord::Migration
  def change
    change_table :decks do |t|
      t.belongs_to :game
    end
  end
end
