class AddBlackCardToGame < ActiveRecord::Migration
  def change
    change_table :black_cards do |t|
      t.belongs_to :game
    end
  end
end
