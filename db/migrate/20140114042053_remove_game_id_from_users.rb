class RemoveGameIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :game_id
  end
end
