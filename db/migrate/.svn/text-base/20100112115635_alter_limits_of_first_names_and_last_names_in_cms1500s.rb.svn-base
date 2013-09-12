class AlterLimitsOfFirstNamesAndLastNamesInCms1500s < ActiveRecord::Migration
  def self.up
    change_column :cms1500s, :patient_last_name,:string,:limit => 40
    change_column :cms1500s, :patient_first_name,:string,:limit => 40
    change_column :cms1500s, :referring_provider_last_name,:string,:limit => 40
    change_column :cms1500s, :referring_provider_first_name,:string,:limit => 40
    change_column :cms1500s, :physician_last_name,:string,:limit => 40
    change_column :cms1500s, :physician_first_name,:string,:limit => 40
    change_column :cms1500s, :billing_provider_last_name,:string,:limit => 40
    change_column :cms1500s, :billing_provider_first_name,:string,:limit => 40
    change_column :cms1500s, :insured_last_name,:string,:limit => 40
    change_column :cms1500s, :insured_first_name,:string,:limit => 40
    change_column :cms1500s, :other_insured_last_name,:string,:limit => 40
    change_column :cms1500s, :other_insured_first_name,:string,:limit => 40
  end

  def self.down
    change_column :cms1500s, :patient_last_name,:string,:limit => 28
    change_column :cms1500s, :patient_first_name,:string,:limit => 28
    change_column :cms1500s, :referring_provider_last_name,:string,:limit => 26
    change_column :cms1500s, :referring_provider_first_name,:string,:limit => 26
    change_column :cms1500s, :physician_last_name,:string,:limit => 28
    change_column :cms1500s, :physician_first_name,:string,:limit => 28
    change_column :cms1500s, :billing_provider_last_name,:string,:limit => 30
    change_column :cms1500s, :billing_provider_first_name,:string,:limit => 10
    change_column :cms1500s, :insured_last_name,:string,:limit => 29
    change_column :cms1500s, :insured_first_name,:string,:limit => 29
    change_column :cms1500s, :other_insured_last_name,:string,:limit => 28
    change_column :cms1500s, :other_insured_first_name,:string,:limit => 28
  end
end
