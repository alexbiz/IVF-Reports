class RenameUserIdInRequests < ActiveRecord::Migration
  def up
    rename_column :requests, :user_id, :patient_id
    rename_column :reviews, :user_id, :patient_id
  end

  def down
    rename_column :requests, :patient_id, :user_id
    rename_column :reviews, :patient_id, :user_id    
  end
end
