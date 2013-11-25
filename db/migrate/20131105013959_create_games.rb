class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.timestamps
    end

    change_table :users do |t|
      t.integer :game_id
    end
  end
end
