class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :players, default: 0
      
      t.timestamps
    end

    change_table :users do |t|
      t.integer :game_id
    end
  end
end
