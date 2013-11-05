class AddUserToDeck < ActiveRecord::Migration
  def change
    change_table :decks do |t|
      t.belongs_to :user
      t.integer :num_white_cards, default: 0
      t.integer :num_black_cards, default: 0
    end
  end
end
