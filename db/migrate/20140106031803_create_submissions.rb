class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :content

      t.timestamps
    end
  end
end
