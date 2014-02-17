class MigrateSubmissionContent < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.remove :content
      t.belongs_to :content
    end
  end
end
