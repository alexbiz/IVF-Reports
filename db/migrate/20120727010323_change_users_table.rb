class ChangeUsersTable < ActiveRecord::Migration
  def up
    remove_column :users, :name
    remove_column :users, :admin
    remove_column :users, :insurer
    remove_column :users, :permalink
    remove_column :users, :gender
    remove_column :users, :zip_code
    remove_column :users, :ethnicity
    remove_column :users, :birthday
    remove_column :users, :previous_cycles
    remove_column :users, :infertility_diagnosis
    remove_column :users, :abo_blood_type
    remove_column :users, :rh_factor
    remove_column :users, :height_ft
    remove_column :users, :height_inches
    remove_column :users, :weight
    remove_column :users, :day_3_fsh
    remove_column :users, :day_3_e2
    remove_column :users, :day_3_lh    
    remove_column :users, :day_10_fsh
    remove_column :users, :day_10_e2
    remove_column :users, :day_10_lh
    remove_column :users, :prolactin
    remove_column :users, :uterine_fibroids
    remove_column :users, :uterine_tumors
    remove_column :users, :phone
    remove_column :users, :clinician
    remove_column :users, :about
    remove_column :users, :about_me
    remove_column :users, :user_type
    remove_column :users, :zip_distance   
    remove_column :users, :address
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :first_name    
    remove_column :users, :last_name  
    add_column :users, :professional_account, :boolean, :default => :false
    add_column :users, :clinic_account, :boolean, :default => :false
    add_column :users, :patient_account, :boolean, :default => :false
    add_column :users, :admin_account, :boolean, :default => :false  
    add_column :users, :clinic_id, :integer
  end

  def down
    add_column :users, :name, :string
    add_column :users, :admin, :boolean
    add_column :users, :insurer, :boolean
    add_column :users, :permalink, :string
    add_column :users, :gender, :string
    add_column :users, :zip_code, :string
    add_column :users, :ethnicity, :string
    add_column :users, :birthday, :date
    add_column :users, :previous_cycles, :integer
    add_column :users, :infertility_diagnosis, :string
    add_column :users, :abo_blood_type, :string
    add_column :users, :rh_factor, :string
    add_column :users, :height_ft, :integer
    add_column :users, :height_inches, :integer
    add_column :users, :weight, :integer
    add_column :users, :day_3_fsh, :float
    add_column :users, :day_3_e2, :float
    add_column :users, :day_3_lh, :float    
    add_column :users, :day_10_fsh, :float
    add_column :users, :day_10_e2, :float
    add_column :users, :day_10_lh, :float
    add_column :users, :prolactin, :float    
    add_column :users, :uterine_fibroids, :string
    add_column :users, :uterine_tumors, :string
    add_column :users, :phone, :string
    add_column :users, :clinician, :boolean
    add_column :users, :about, :text
    add_column :users, :about_me, :text
    add_column :users, :user_type, :string
    add_column :users, :zip_distance, :integer
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string    
    remove_column :users, :professional_account
    remove_column :users, :clinic_account
    remove_column :users, :patient_account
    remove_column :users, :admin_account
    remove_column :users, :clinic_id    
  end
end
