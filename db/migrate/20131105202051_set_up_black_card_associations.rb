class SetUpBlackCardAssociations < ActiveRecord::Migration
  def change
    change_table :black_cards do |t|
      t.integer :num_blanks
      t.string :content

      t.belongs_to :deck
    end
  end
end
