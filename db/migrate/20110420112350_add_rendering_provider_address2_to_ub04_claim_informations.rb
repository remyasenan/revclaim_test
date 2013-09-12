class AddRenderingProviderAddress2ToUb04ClaimInformations < ActiveRecord::Migration
  def self.up
    add_column :ub04_claim_informations, :rendering_provider_address2, :string, :limit => 50
  end

  def self.down
    remove_column :ub04_claim_informations, :rendering_provider_address2
  end
end
