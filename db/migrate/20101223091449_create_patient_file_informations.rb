class CreatePatientFileInformations < ActiveRecord::Migration
  def self.up
    create_table :patient_file_informations do |t|
      t.column :name, :string 
      t.column :filetype, :string
      t.column :zipname, :string
      t.column :facility_id, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :patient_file_informations
  end
end
