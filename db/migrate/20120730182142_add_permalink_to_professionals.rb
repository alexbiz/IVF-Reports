class AddPermalinkToProfessionals < ActiveRecord::Migration
  def change
    add_column :professionals, :permalink, :string
  end
end
