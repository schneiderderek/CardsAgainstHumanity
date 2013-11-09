class AddOriginalDeckIdToGame < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :original_deck_id
    end
  end
end
