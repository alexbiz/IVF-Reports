class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.integer :user_id
      t.string :username
      t.string :gender
      t.string :zip_code
      t.string :ethnicity
      t.date :birthday
      t.integer :previous_cycles
      t.string :infertility_diagnosis
      t.string :phone
      t.text :about
      t.string :permalink
      t.integer :zip_distance
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
