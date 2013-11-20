class AddCzarIdToGame < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :czar_id
    end
  end
end
