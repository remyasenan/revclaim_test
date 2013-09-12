require 'OCR_Data'
include OCR_Data

class Ub04ClaimInformation < ActiveRecord::Base
  belongs_to :job
  has_many :ub04_serviceline_informations, :dependent => :destroy
  has_many :occurences, :dependent => :destroy
  has_many :occurence_spans, :dependent => :destroy
  has_many :value_codes, :dependent => :destroy
  has_many :qualifier_code_values, :dependent => :destroy
  has_many :ub04payers, :dependent => :destroy
  attr_accessor :federal_tax_number1 ,:federal_tax_number2
 
  has_details :billing_provider_first_name,
              :billing_provider_last_name,
              :billing_provider_address1,
              :billing_provider_address2,
              :billing_provider_city,
              :billing_provider_state,
              :billing_provider_zipcode,
              :billing_provider_telephone,
              :billing_provider_tin_or_ein,
              :billing_provider_npi,
              :billing_providerid1,
              :billing_providerid2,
              :billing_providerid3,
              :rendering_provider_first_name,
              :rendering_provider_last_name,
              :rendering_provider_address1,
              :rendering_provider_city,
              :rendering_provider_state,
              :rendering_provider_zipcode,
              :rendering_providerid,
              :patient_account_number,
              :patient_med_rec_number,
              :patient_bill_type,
              :federal_tax_number,
              :statement_cover_from,
              :statement_cover_to,
              :patient_first_name,
              :patient_last_name,
              :patientid,
              :patient_address1,
              :patient_address2,
              :patient_city,
              :patient_state,
              :patient_zipcode,
              :patient_country_code,
              :patient_dob,
              :patient_gender,
              :admission_date,
              :admission_hour,
              :admission_type,
              :admission_source,
              :discharge_hour,
              :patient_status_code,
              :subscriber_first_name,
              :subscriber_last_name,
              :subscriber_address1,
              :subscriber_address2,
              :subscriber_city,
              :subscriber_state,
              :subscriber_zipcode,
              :page_number,
              :page_total,
              :dx_version_qualifier,
              :patient_reason_visit_code1,
              :patient_reason_visit_code2,
              :patient_reason_visit_code3,
              :principal_proc_code,
              :principal_proc_date,
              :billing_provider_telephone2,
              :patient_middle_initial,
              :subscriber_middle_initial,
              :condition_code1,
              :condition_code2,
              :condition_code3,
              :condition_code4,
              :condition_code5,
              :condition_code6,
              :condition_code7,
              :condition_code8,
              :condition_code9,
              :condition_code10,
              :condition_code11,
              :acdt_state,
              :unlabel_7_1,
              :unlabel_7_2,
              :unlabel_30_1,
              :unlabel_30_2,
              :unlabel_37_1,
              :unlabel_37_2,
              :unlabel_42_23,
              :unlabel_68_1,
              :unlabel_68_2,
              :unlabel_73,
              :unlabel_75_1,
              :unlabel_75_2,
              :unlabel_75_3,
              :unlabel_75_4,
              :create_date,
              :total_charges_data,
              :admit_diag
#
#

def count_processor_input_claim_fields_ub04()
  total_claim_fields_with_data = 0
  payer_field_count = 0
  claim_fields = [billing_provider_last_name, billing_provider_address1, billing_provider_city, billing_provider_state, billing_provider_zipcode, billing_provider_telephone, billing_provider_tin_or_ein, billing_provider_npi, billing_providerid1, billing_providerid2, billing_providerid3,
rendering_provider_last_name, rendering_provider_address1, rendering_provider_city, rendering_provider_state, rendering_provider_zipcode, rendering_providerid, patient_account_number, patient_med_rec_number, patient_bill_type, statement_cover_from, statement_cover_to,
patient_first_name, patient_last_name, patientid, patient_address1, patient_city, patient_state, patient_zipcode, patient_country_code, patient_dob, patient_gender, admission_date, admission_hour, admission_type, admission_source, discharge_hour, patient_status_code,
condition_code1, condition_code2, condition_code3, condition_code4, condition_code5, condition_code6, condition_code7, condition_code8, condition_code9, condition_code10, condition_code11, acdt_state, subscriber_first_name, subscriber_last_name, subscriber_address1, subscriber_address2,
subscriber_city, subscriber_state, subscriber_zipcode, page_number, page_total, creation_date, total_charges, total_non_covered_charges, dx_version_qualifier, principal_diag, other_diag1, other_diag2, other_diag3, other_diag4,  other_diag5, other_diag6, other_diag7, other_diag8,  other_diag9,
other_diag10, other_diag11, other_diag12,  other_diag13, other_diag14, other_diag15, other_diag16, other_diag17, admit_diag, patient_reason_visit_code1, patient_reason_visit_code2, patient_reason_visit_code3, pps_code, eci_code1, eci_code2, eci_code3, principal_proc_code, principal_proc_date,
other_proc_code1, other_proc_code2, other_proc_code3, other_proc_code4, other_proc_code5, other_proc_date1, other_proc_date2, other_proc_date3, other_proc_date4, other_proc_date5, attending_npi, attending_qual, attendingid, attending_provider_first_name, attending_provider_last_name, operating_npi,
operating_qual, operatingid, operating_provider_first_name, operating_provider_last_name, other_npi1, other_npi2, other_qual1, other_qual2, otherid1, otherid2, other_provider_first_name1, other_provider_first_name2, other_provider_last_name1, other_provider_last_name2, patient_middle_initial,
subscriber_middle_initial, unlabel_7_1, unlabel_7_2, unlabel_30_1, unlabel_30_2, unlabel_37_1, unlabel_37_2, unlabel_42_23, unlabel_68_1, unlabel_68_2, unlabel_73, unlabel_75_1, unlabel_75_2, unlabel_75_3, unlabel_75_4, rendering_provider_address2]

  payer_details = remarks
  
  payer_information = payer_details.split("\n")
  
  payer_field_count = payer_information.select{|payer_info| !payer_info.blank? and payer_info != '--'}

  claim_fields_with_data = claim_fields.select{|field| !field.blank? and field != '--'}

  total_claim_fields_with_data = claim_fields_with_data.length + payer_field_count.length

  return total_claim_fields_with_data
end

  def self.payer_details(payer)
    payer_details = {}
    remark = payer.strip
    remark=remark.split("+")
    payer_details["payer_name"] = remark[0]
    payer_details["payer_address_one"] = remark[1]
    payer_details["payer_address_two"] = remark[2]
    payer_details["payer_city"] = remark[3]
    payer_details["payer_state"] = remark[4]
    payer_details["payer_zip"] = remark[5]
    return payer_details.to_json
  end

  def self.provider_details(provider_id)
    provider_details = {}
    provider = Ub04ClaimInformation.find_by_id(provider_id)
    provider_details["rendering_provider_last_name"] = provider.rendering_provider_last_name
    provider_details["rendering_provider_address1"] = provider.rendering_provider_address1
    provider_details["rendering_provider_city"] = provider.rendering_provider_city
    provider_details["rendering_provider_state"] = provider.rendering_provider_state
    provider_details["rendering_provider_zipcode"] = provider.rendering_provider_zipcode
    return provider_details.to_json
  end

   def self.billing_provider_details(provider_id)

    provider_details = {}
    provider = Ub04ClaimInformation.find_by_id(provider_id)
    provider_details["billing_provider_last_name"] = provider.billing_provider_last_name
    provider_details["billing_provider_address1"] = provider.billing_provider_address1
    provider_details["billing_provider_city"] = provider.billing_provider_city
    provider_details["billing_provider_state"] = provider.billing_provider_state
    provider_details["billing_provider_zipcode"] = provider.billing_provider_zipcode
    provider_details["billing_provider_telephone"] = provider.billing_provider_telephone
    provider_details["billing_provider_tin_or_ein"] = provider.billing_provider_tin_or_ein
    provider_details["billing_provider_npi"] = provider.billing_provider_npi
    return provider_details.to_json
  end

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
