class ChangeColumnDatatypeToStringOfZipcodesInUb04claiminformations < ActiveRecord::Migration
  def self.up
    change_column :ub04_claim_informations, :patient_zipcode,:string
    change_column :ub04_claim_informations, :rendering_provider_zipcode,:string
    change_column :ub04_claim_informations, :billing_provider_zipcode,:string
  end

  def self.down
    change_column :ub04_claim_informations, :patient_zipcode,:integer
    change_column :ub04_claim_informations, :rendering_provider_zipcode,:integer
    change_column :ub04_claim_informations, :billing_provider_zipcode,:integer
  end
end
