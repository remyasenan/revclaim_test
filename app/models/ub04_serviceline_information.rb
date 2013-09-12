require 'OCR_Data'
include OCR_Data

class Ub04ServicelineInformation < ActiveRecord::Base
      belongs_to :ub04_claim_information

       has_details :rev_code,
                   :description,
                   :hcpcs,
                   :rates,
                   :hipps_codes,
                   :service_date ,
                   :service_units,
                   :charges,
                   :non_covered_charges,
                   :unlabel_49

  def count_processor_input_claim_serviceline_fields_ub04()
    total_claim_serviceline_fields_with_data = 0
    serviceline_fields = [rev_code, hcpcs, rates, hipps_codes, service_date, service_units, charges, non_covered_charges, unlabel_49,
      modifier, modifier2, modifier3, modifier4]

    serviceline_fields_with_data = serviceline_fields.select{|field| !field.blank? and field != '--'}

    total_claim_serviceline_fields_with_data = serviceline_fields_with_data.length

    return total_claim_serviceline_fields_with_data
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
