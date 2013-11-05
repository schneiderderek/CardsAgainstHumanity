class AddNameToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.string :name, default: ""
    end
  end
end
