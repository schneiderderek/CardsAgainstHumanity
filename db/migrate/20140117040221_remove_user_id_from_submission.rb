class RemoveUserIdFromSubmission < ActiveRecord::Migration
  def up
    remove_column :submissions, :user_id
  end

  def down
    add_column :submissions, :user_id, :integer
  end
end
