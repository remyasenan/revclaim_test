class ChangeLimitOfBillingProviderCityInCms1500s < ActiveRecord::Migration
  def self.up
    change_column :cms1500s, :billing_provider_city, :string, :limit => 30
  end

  def self.down
    change_column :cms1500s, :billing_provider_city, :string, :limit => 10
  end
end
