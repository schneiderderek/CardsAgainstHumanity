class AddWinsAndPointsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :wins, default: 0
    end
  end
end
