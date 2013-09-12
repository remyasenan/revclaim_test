require 'OCR_Data'
include OCR_Data

class Ub04payer < ActiveRecord::Base
   belongs_to :ub04_claim_information
   has_details  :name,
                :health_planid,
                :release_info,
                :assign_benefits,
                :prior_payments,
                :est_amounts,
                :insured_first_name,
                :insured_last_name,
                :patient_relationship,
                :insured_id,
                :group_name,
                :group_no,
                :treatment_authorisation,
                :document_control_no,
                :employer_name,
                :insured_middle_initial


  def count_processor_input_ub04_payer_fields()
    total_ub04_payer_fields_with_data = 0
    ub04_payer_fields = [name, health_planid, release_info, assign_benefits, prior_payments, est_amounts, insured_first_name, insured_last_name, patient_relationship, insured_id,
                          group_name, group_no, treatment_authorisation, document_control_no, employer_name, insured_middle_initial]

    ub04_payer_fields_with_data = ub04_payer_fields.select{|field| !field.blank? and field != '--'}

    total_ub04_payer_fields_with_data = ub04_payer_fields_with_data.length

    return total_ub04_payer_fields_with_data
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
