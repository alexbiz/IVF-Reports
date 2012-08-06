class AddFieldsToProfessionals < ActiveRecord::Migration
  def change
    add_column :professionals, :education, :string
    add_column :professionals, :about, :text
    add_column :professionals, :first_name, :string
    add_column :professionals, :last_name, :string
    add_column :professionals, :phone, :string          
  end
end
