class CreateHands < ActiveRecord::Migration
  def change
    create_table :hands do |t|

      t.timestamps
    end
  end
end
