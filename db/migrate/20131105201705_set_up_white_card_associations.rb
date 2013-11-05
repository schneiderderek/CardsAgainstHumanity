class SetUpWhiteCardAssociations < ActiveRecord::Migration
  def change
    change_table :white_cards do |t|
      t.string :content
      t.belongs_to :deck
      t.belongs_to :hand
    end
  end
end
