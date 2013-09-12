require 'OCR_Data'
include OCR_Data
class Cms1500serviceline < ActiveRecord::Base
  include EdiHelper
  attr_accessor :style,:coordinates, :page
  belongs_to :cms1500
  has_details :service_from_date,
               :service_to_date,
               :service_place,
               :emg,
               :cpt_hcpcts,
               :modifier1,
               :modifier2,
               :modifier3,
               :modifier4,
               :diagnosis_pointer,
               :charges,
               :days_units,
               :epsdt,
               :family_plan,
               :qual_id,
               :rendering_provider_id,
               :rendering_provider_qualifier_npi_id

  def count_processor_input_serviceline_fields()
    total_serviceline_fields_with_data = 0
    serviceline_fields = [service_from_date, service_to_date, service_place, emg, cpt_hcpcts, modifier1, modifier2, modifier3, modifier4, diagnosis_pointer,
                          charges, days_units, epsdt, family_plan, qual_id, rendering_provider_id, rendering_provider_qualifier_npi_id, minutes]

    serviceline_fields_with_data = serviceline_fields.select{|field| !field.blank? and field != '--'}

    total_serviceline_fields_with_data = serviceline_fields_with_data.length

    return total_serviceline_fields_with_data
  end
  
  # Return the SV101 composite for the ANSI 837 format
  def sv101
    return composite_element(["HC", cpt_hcpcts, modifier1, modifier2, modifier3, modifier4])
  end
  
  # Return the SV107 composite for the ANSI 837 format
  def sv107
    return composite_element(diagnosis_pointer.to_s.unpack('aaaa'))
  end
  
  # Return the qual_id value or G2 if the value is out of range.
  def qual_id_for_837
    if qual_id == "0B" or qual_id == "1A" or 
        qual_id == "1B" or qual_id == "1C" or 
        qual_id == "1D" or qual_id == "1G" or  
        qual_id == "1H" or qual_id == "TJ" or
        qual_id == "X4" or qual_id == "X5" or
        qual_id == "EI"
      return qual_id
    else
      return "G2"
    end
  end
  
  #Returns the qual_id for loop 2310b
  def qual_id_for_837_in_loop_2310b
    rendering_provider = ["0B","1A","1B","1C","1D","1G","1H","SY","X5"] 
    flag = rendering_provider.include?(qual_id) 
    if flag  
      return qual_id
    else
      return "G2"
    end
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
