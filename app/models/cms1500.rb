require 'OCR_Data'
include OCR_Data
#RAILS_PATH = "#{Rails.root}/"
class Cms1500 < ActiveRecord::Base
  include EdiHelper
  attr_accessor :style,:coordinates, :page
  belongs_to :job
  has_many :service_lines, :dependent => :destroy, :class_name => "Cms1500serviceline"
  has_one :payer, :dependent => :destroy
  
  has_details :insurance_type,
               :patient_last_name,
               :patient_suffix,
               :patient_first_name,
               :patient_middle_initial,
               :patient_address,
               :patient_city,
               :patient_state,
               :patient_zipcode,
               :patient_telephone,
               :patient_dob,
               :patient_sex,
               :patient_relationship_to_insured,
               :patient_marital_status,
               :patient_employment_status,
               :patient_condition_to_employment,
               :patient_condition_to_auto_accident,
               :patient_condition_to_auto_accident_place,
               :patient_condition_to_other_accident,
               :patient_condition_reserved_for_local_use,
               :patient_signature_on_file,
               :patient_signed_date,
               :insured_signature_on_file,
               :date_of_current_illness,
               :first_date_similar_illness,
               :referring_provider_last_name,
               :referring_provider_suffix,
               :referring_provider_first_name,
               :referring_provider_middle_initial,
               :referring_provider_other_qualifier,
               :referring_provider_other_id,
               :referring_provider_npi_id,
               :patient_unable_to_work_from_date,
               :patient_unable_to_work_to_date,
               :hospitalization_from_date,
               :hospitalization_to_date,
               :outside_lab,
               :outside_lab_charge,
               :medicaid_resubmission_code,
               :medicaid_resubmission_ref_number,
               :prior_authorization_number,
               :reserved_local_use,
               :nature_of_illness_or_injury_1,
               :nature_of_illness_or_injury_2,
               :nature_of_illness_or_injury_3,
               :nature_of_illness_or_injury_4,
               :accept_assignment,
               :patient_account_number,
               :federal_tax_id,
               :federal_tax_id_type,
               :physician_last_name,
               :physician_suffix,
               :physician_first_name,
               :physician_middle_initial,
               :physician_signature_on_file,
               :physician_sign_date,
               :service_facility_name,
               :service_facility_address,
               :service_facility_city,
               :service_facility_state,
               :service_facility_zipcode,
               :service_facility_npi_id,
               :service_facility_non_npi_id,
               :billing_provider_name,
               :billing_provider_last_name,
               :billing_provider_suffix,
               :billing_provider_first_name,
               :billing_provider_middle_initial,
               :billing_provider_address,
               :billing_provider_city,
               :billing_provider_state,
               :billing_provider_phone,
               :billing_provider_zipcode,
               :billing_provider_npi_id,
               :billing_provider_non_npi_id,
               :total_charge,
               :amount_paid,
               :balance_due,
               :insured_id,
               :insured_last_name,
               :insured_suffix,
               :insured_first_name,
               :insured_middle_initial,
               :insured_address,
               :insured_state,
               :insured_city,
               :insured_zipcode,
               :insured_telephone,
               :insured_policy_group_or_feca_number,
               :insured_dob,
               :insured_sex,
               :insured_employers_or_school_name,
               :insured_plan_name,
               :other_health_benefit_plan,
               :other_insured_last_name,
               :other_insured_suffix,
               :other_insured_first_name,
               :other_insured_middle_initial,
               :other_insured_policy_or_group_number,
               :other_insured_dob,
               :other_insured_sex,
               :other_insured_employers_or_school_name,
               :other_insured_insurance_plan_name,
               :physician_organisation_name,
               :payer_id,
  	           :reffering_provider_organisation_name

  def count_processor_input_claim_fields()
#     file_to_write = Time.now.strftime("%Y%m%d-%H%M").to_s + ".log"
#        log_file = File.open("#{RAILS_PATH}inputfields_log/#{file_to_write}" , "w")
#    log = Logger.new(log_file)
    total_claim_fields_with_data = 0
    claim_fields = [insurance_type, other_insured_sex, patient_signature_on_file, patient_last_name, patient_suffix, patient_first_name, patient_middle_initial, patient_address, patient_city, patient_state, patient_zipcode, patient_telephone, patient_dob, patient_sex, patient_relationship_to_insured, patient_condition_to_employment, patient_condition_to_auto_accident, patient_condition_to_auto_accident_place,
                    patient_condition_to_other_accident,patient_condition_reserved_for_local_use, insured_signature_on_file, date_of_current_illness, first_date_similar_illness, referring_provider_last_name, referring_provider_suffix, referring_provider_first_name, referring_provider_middle_initial, referring_provider_other_qualifier, referring_provider_other_id,
                    referring_provider_npi_id, patient_unable_to_work_from_date, patient_unable_to_work_to_date, hospitalization_from_date, hospitalization_to_date, outside_lab_charge, medicaid_resubmission_code, medicaid_resubmission_ref_number, prior_authorization_number, nature_of_illness_or_injury_1, nature_of_illness_or_injury_2,nature_of_illness_or_injury_3,
                    nature_of_illness_or_injury_4, accept_assignment, patient_account_number, federal_tax_id, federal_tax_id_type, physician_last_name, physician_suffix, physician_first_name, physician_middle_initial, physician_signature_on_file, service_facility_name, service_facility_address, service_facility_city, service_facility_state, service_facility_zipcode,
                    service_facility_npi_id, service_facility_non_npi_id, billing_provider_name, billing_provider_last_name, billing_provider_suffix, billing_provider_first_name, billing_provider_middle_initial, billing_provider_address, billing_provider_city, billing_provider_state, billing_provider_phone, billing_provider_zipcode, billing_provider_npi_id, billing_provider_non_npi_id,
                    total_charge, amount_paid, balance_due, insured_id, insured_last_name, insured_suffix, insured_first_name, insured_middle_initial, insured_address, insured_state, insured_city, insured_zipcode, insured_telephone, insured_policy_group_or_feca_number, insured_dob, insured_sex, insured_employers_or_school_name, insured_plan_name, other_insured_last_name, other_insured_suffix,
                    other_insured_first_name, other_insured_middle_initial, other_insured_policy_or_group_number, other_insured_insurance_plan_name, physician_organisation_name, reffering_provider_organisation_name, nature_of_illness_or_injury_5, nature_of_illness_or_injury_6, nature_of_illness_or_injury_7, nature_of_illness_or_injury_8,patient_address2, insured_address2, service_facility_address2, billing_provider_address2]

    claim_fields_with_data = claim_fields.select{|field| !field.blank? and field != '--' and field != 'NULL'}

#    log.info "***************************************************************&*"
#    for i in 0..claim_fields.length
#      log.info "index #{i} - #{claim_fields[i].present?} - #{claim_fields_with_data[i]}"
#    end
#   log.info claim_fields_with_data
    total_claim_fields_with_data = claim_fields_with_data.length
#    log.info total_claim_fields_with_data
#    log.info "***************************************************************&*"
    return total_claim_fields_with_data
  end
   
  def referring_provider_other_qualifier_for_837
    referring_qualifier = ["0B","1A","1B","1C","1D","1G","1H","SY","X5"]
    flag = referring_qualifier.include?(referring_provider_other_qualifier) 
    if flag 
      return referring_provider_other_qualifier
    else
      return "G2"
    end

  end


    
  
  def self.provider_organization_details(provider)
      provider_details = {}
      provider_info = provider.split('+')
#      provider_name = provider_info[0].strip rescue nil
#      provider_add = provider_info[1].strip rescue nil
#      provider_city = provider_info[3].strip rescue nil
#      provider_state = provider_info[4].strip rescue nil
#      provider_zipcode = provider_info[5].strip rescue nil
#      provider = TypeaheadBillingProviders.find_by_billing_provider_name_and_billing_provider_address_and_billing_provider_city_and_billing_provider_state_and_billing_provider_zipcode(provider_name,provider_add,provider_city,provider_state,provider_zipcode)
      provider = TypeaheadBillingProviders.find(provider_info[2])
      provider_details["billing_provider_address"] = provider.billing_provider_address rescue nil
      provider_details["billing_provider_city"] = provider.billing_provider_city rescue nil
      provider_details["billing_provider_state"] = provider.billing_provider_state rescue nil
      provider_details["billing_provider_zipcode"] = provider.billing_provider_zipcode rescue nil
      provider_details["billing_provider_npi_id"] = provider.billing_provider_npi_id rescue nil
      return provider_details.to_json
  end

  def self.provider_details(provider)
      provider_details = {}
      provider_info = provider.split('+')
#      provider_last_name = provider_info[0].strip rescue nil
#      provider_first_name = provider_info[1].strip rescue nil
#      provider_add = provider_info[2].strip rescue nil
#      provider_city = provider_info[4].strip rescue nil
#      provider_state = provider_info[5].strip rescue nil
#      provider_zip = provider_info[6].strip rescue nil
#      provider = TypeaheadBillingProviders.find_by_billing_provider_last_name_and_billing_provider_first_name_and_billing_provider_address_and_billing_provider_city_and_billing_provider_state_and_billing_provider_zipcode(provider_last_name,provider_first_name,provider_add,provider_city,provider_state,provider_zip)
      provider = TypeaheadBillingProviders.find(provider_info[3])
      provider_details["billing_provider_suffix"] = provider.billing_provider_suffix rescue nil
      provider_details["billing_provider_first_name"] = provider.billing_provider_first_name rescue nil
      provider_details["billing_provider_middle_initial"] = provider.billing_provider_middle_initial rescue nil
      provider_details["billing_provider_address"] = provider.billing_provider_address rescue nil
      provider_details["billing_provider_city"] = provider.billing_provider_city rescue nil
      provider_details["billing_provider_state"] = provider.billing_provider_state rescue nil
      provider_details["billing_provider_zipcode"] = provider.billing_provider_zipcode rescue nil
      provider_details["billing_provider_npi_id"] = provider.billing_provider_npi_id rescue nil
      return provider_details.to_json
  end
  
  def self.service_facility_details(service_facility)
      service_facility_details = {}
      service_info = service_facility.split('+')
#      service_facility_name = service_info[0].strip rescue nil
#      service_facility_add = service_info[1].strip rescue nil
#      service_facility_city = service_info[2].strip rescue nil
#      service_facility_state = service_info[4].strip rescue nil
#      service_facility_zipcode = service_info[5].strip rescue nil
#      s_facility = TypeaheadServiceFacilities.find_by_service_facility_name_and_service_facility_address_and_service_facility_city_and_service_facility_state_and_service_facility_zipcode(service_facility_name,service_facility_add,service_facility_city,service_facility_state,service_facility_zipcode)
      s_facility = TypeaheadServiceFacilities.find(service_info[3])
      service_facility_details["service_facility_address"] = s_facility.service_facility_address rescue nil
      service_facility_details["service_facility_state"] = s_facility.service_facility_state rescue nil
      service_facility_details["service_facility_zipcode"] = s_facility.service_facility_zipcode rescue nil
      service_facility_details["service_facility_npi_id"] = s_facility.service_facility_npi_id rescue nil
      service_facility_details["service_facility_non_npi_id"] = s_facility.service_facility_non_npi_id rescue nil
      service_facility_details["service_facility_city"] = s_facility.service_facility_city rescue nil
      return service_facility_details.to_json
  end

  def popup
    "#{billing_provider_last_name.to_s} + #{billing_provider_first_name} + #{billing_provider_address} + #{id} + #{billing_provider_city} + #{billing_provider_state} + #{billing_provider_zipcode.to_s}"
#   self.billing_provider_last_name
  end

  def popup_service_facility
    "#{service_facility_name} + #{service_facility_address} + #{service_facility_city} + #{id} + #{service_facility_state} + #{service_facility_zipcode.to_s}"
    #"#{service_facility_name} + #{service_facility_address} + #{service_facility_city} + #{service_facility_state} + #{service_facility_zipcode.to_s} + #{id}"
#   self.service_facility_name
  end
  
  def popup_billing_provider_name
    "#{billing_provider_name.to_s} + #{billing_provider_address} + #{id} + #{billing_provider_city} + #{billing_provider_state} + #{billing_provider_zipcode.to_s}"
    #"#{billing_provider_name.to_s} + #{billing_provider_address} + #{billing_provider_city} + #{billing_provider_state} + #{billing_provider_zipcode.to_s} + #{id}"
#   self.billing_provider_last_name
  end

    #This will return the coordinates for an OCR'd field
  #OCR  engine returns the coordinates in terms of
  # top, bottom, left and right, in that order
  def coordinates(column)
    method_to_call = "#{column}_coordinates"
    begin
      coordinates = self.send(method_to_call)
      coordinates_appended = ""
      coordinates.each do |coordinate|
        coordinates_appended += "#{coordinate} ,"
      end
      coordinates_appended
    rescue NoMethodError
      # Nothing matched, send nil object so that the attribute in the view it will be dropped
      nil
    end
  end

  
   def style(column)
     method_to_call = "#{column}_data_origin"
   begin
          case self.send(method_to_call)
            when OCR_Data::Origins::IMPORTED
             "ocr_data imported"
            when OCR_Data::Origins::CERTAIN
              "ocr_data certain"
            when OCR_Data::Origins::UNCERTAIN
              "ocr_data uncertain"
            when OCR_Data::Origins::BLANK
              "ocr_data blank"
            else
              "ocr_data blank"
          end
      rescue NoMethodError
      # Nothing matched, assign default
      OCR_Data::Origins::BLANK
    end
 end
end
