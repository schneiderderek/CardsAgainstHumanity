class AddWinningCardIdToGame < ActiveRecord::Migration
  def change
   change_table :games do |t|
      t.integer :winning_card_id
   end
  end
end
