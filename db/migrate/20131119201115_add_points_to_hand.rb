class AddPointsToHand < ActiveRecord::Migration
  def change
    change_table :hands do |t|
      t.integer :score, default: 0
    end
  end
end
