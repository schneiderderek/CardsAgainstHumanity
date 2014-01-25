class AddHandIdToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :hand_id, :integer
  end
end
