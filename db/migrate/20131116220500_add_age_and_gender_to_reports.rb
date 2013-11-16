class AddAgeAndGenderToReports < ActiveRecord::Migration
  def change
    add_column :reports, :age, :string
    add_column :reports, :gender, :string
    add_column :reports, :race, :string
    add_column :reports, :address, :string
  end
end
