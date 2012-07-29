class CreateProfessionals < ActiveRecord::Migration
  def change
    create_table :professionals do |t|
      t.integer :user_id
      t.string :username
      t.string :profession

      t.timestamps
    end
  end
end
