class ChangeLimitOfInsuredCityInCms1500s < ActiveRecord::Migration
  def self.up
	  change_column :cms1500s, :insured_city, :string, :limit => 30
  end

  def self.down
	  change_column :cms1500s, :insured_city, :string, :limit => 23
  end
end
