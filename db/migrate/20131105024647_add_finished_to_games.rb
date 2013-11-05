class AddFinishedToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.boolean :finished, default: false
    end
  end
end
