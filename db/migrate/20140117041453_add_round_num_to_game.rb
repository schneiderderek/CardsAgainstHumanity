class AddRoundNumToGame < ActiveRecord::Migration
  def change
    add_column :games, :round, :integer, default: 0
  end
end
