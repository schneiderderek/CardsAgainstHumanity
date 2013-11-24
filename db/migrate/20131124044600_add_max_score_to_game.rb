class AddMaxScoreToGame < ActiveRecord::Migration
  def change
   change_table :games do |t|
      t.integer :max_score, default: 10
   end
  end
end
