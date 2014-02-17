class CreateCardContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :text
      t.timestamps
    end
  end
end
