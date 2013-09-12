class AlterLimitPatientaccountnumber < ActiveRecord::Migration
  def self.up
	  change_column :cms1500s, :patient_account_number, :string, :limit => 50
  end

  def self.down
	  change_column :cms1500s, :patient_account_number, :string, :limit => 14
  end
end
