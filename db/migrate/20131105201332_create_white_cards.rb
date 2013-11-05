class CreateWhiteCards < ActiveRecord::Migration
  def change
    create_table :white_cards do |t|

      t.timestamps
    end
  end
end
