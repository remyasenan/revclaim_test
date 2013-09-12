class CreatePatientInformations < ActiveRecord::Migration
  def self.up
    create_table :patient_informations do |t|
      t.column :patient_file_information_id, :string
      t.column :insured_id, :string
      t.column :relationship, :string
      t.column :lastname, :string
      t.column :firstname, :string
      t.column :dob, :string
      t.column :address, :string
      t.column :state, :string
      t.column :zipcode, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :patient_informations
  end
end
