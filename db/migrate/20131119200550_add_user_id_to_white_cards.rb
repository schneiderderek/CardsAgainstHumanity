class AddUserIdToWhiteCards < ActiveRecord::Migration
  def change
    change_table :white_cards do |t|
      t.belongs_to :user
    end
  end
end
