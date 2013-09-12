class TypeaheadServiceFacilities < ActiveRecord::Migration
  def self.up
     create_table "typeahead_service_facilities", :force => true do |t|
      t.column :service_facility_name, :string
      t.column :service_facility_address, :string
      t.column :service_facility_city, :string
      t.column :service_facility_state, :string
      t.column :service_facility_zipcode, :string
      t.column :service_facility_npi_id, :integer
      t.column :service_facility_non_npi_id, :string
   end
  end

  def self.down
    drop_table "typeahead_service_facilities"
  end
end
