class RemoveWinningCardFromGame < ActiveRecord::Migration
  def up
    remove_column :games, :winning_card_id
  end

  def down
    add_column :games, :winning_card_id, :integer
  end
end
