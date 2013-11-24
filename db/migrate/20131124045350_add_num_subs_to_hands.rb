class AddNumSubsToHands < ActiveRecord::Migration
  def change
   change_table :hands do |t|
      t.integer :submissions_left, default: 0
   end
  end
end
