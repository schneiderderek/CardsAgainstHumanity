class SetUpUserHandGameRelation < ActiveRecord::Migration
  def change
    change_table :hands do |t|
      t.belongs_to :user
      t.belongs_to :game
    end
  end
end
