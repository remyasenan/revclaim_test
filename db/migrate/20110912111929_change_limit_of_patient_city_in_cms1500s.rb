class ChangeLimitOfPatientCityInCms1500s < ActiveRecord::Migration
  def self.up
	  change_column :cms1500s, :patient_city, :string, :limit => 30
  end

  def self.down
	  change_column :cms1500s, :patient_city, :string, :limit => 24
  end
end
