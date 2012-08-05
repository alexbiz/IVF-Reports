class AddFieldsToProfessionals < ActiveRecord::Migration
  def change
    add_column :professionals, :education, :string
    add_column :professionals, :about, :text
    add_column :professionals, :first_name, :text
    add_column :professionals, :last_name, :text
    add_column :professionals, :title, :text
    add_column :professionals, :phone, :text                
  end
end
