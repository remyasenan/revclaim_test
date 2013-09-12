class TypeaheadServiceFacilities < ActiveRecord::Base

  def popup_service_facility
    "#{service_facility_name} + #{service_facility_address} + #{service_facility_city} + #{id} + #{service_facility_state} + #{service_facility_zipcode.to_s}"
  end
  
end
