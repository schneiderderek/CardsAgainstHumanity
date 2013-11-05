class AddMaxplayersToGame < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :max_players, default: 20
    end
  end
end
