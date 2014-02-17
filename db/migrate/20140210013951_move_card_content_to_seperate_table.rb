class MoveCardContentToSeperateTable < ActiveRecord::Migration
  def change
    change_table :white_cards do |t|
      t.remove :content
      t.integer :content_id
    end

    change_table :black_cards do |t|
      t.remove :content
      t.integer :content_id
    end
  end
end
