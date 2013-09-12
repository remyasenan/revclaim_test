class CreateBillingProviderDetail < ActiveRecord::Migration
  def self.up
     create_table :billing_provider_details do |t|
      t.column :billing_provider_first_name,  :string, :limit   => 50
      t.column :billing_provider_last_name, :string, :limit   => 50
      t.column :billing_provider_address1,  :string, :limit   => 50
      t.column :billing_provider_address2,  :string, :limit   => 50
      t.column :billing_provider_city,  :string, :limit   => 50
      t.column :billing_provider_state, :string, :limit   => 50
      t.column :billing_provider_zipcode, :integer
      t.column :billing_provider_telephone, :string, :limit  => 50
      t.column :billing_provider_tin_or_ein,  :integer
      t.column :billing_provider_npi, :string, :limit   => 50
    end
  end

  def self.down
    drop_table :billing_provider_details
  end
end
