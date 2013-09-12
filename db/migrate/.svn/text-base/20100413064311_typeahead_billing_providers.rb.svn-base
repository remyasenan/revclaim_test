class TypeaheadBillingProviders < ActiveRecord::Migration
  def self.up
    create_table "typeahead_billing_providers", :force => true do |t|
      t.column :billing_provider_name, :string
      t.column :billing_provider_last_name, :string
      t.column :billing_provider_suffix, :string
      t.column :billing_provider_first_name, :string
      t.column :billing_provider_middle_initial, :string
      t.column :billing_provider_address, :string
      t.column :billing_provider_city, :string
      t.column :billing_provider_state, :string
      t.column :billing_provider_zipcode, :string
      t.column :billing_provider_npi_id, :integer
      t.column :billing_provider_non_npi_id, :string
      


    end
  end

  def self.down
    drop_table "typeahead_billing_providers"
  end
end
