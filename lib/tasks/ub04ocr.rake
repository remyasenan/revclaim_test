namespace :parse do
  desc 'ub04 parser'

  task :ub04 => :environment do
    require "nokogiri"
    
   #Reading the file containing the total count of the xmls to be generated.    
    file = File.open("#{Rails.root}/XMLs_New_UB04/xmlcount.txt" , "r+")
    xml_count = file.readlines[0]
    file.close
    xml_count_increment = 0
    while true

      #exit he parser if the text file count is equal to the total count.
      exit if(xml_count_increment.to_i == xml_count.to_i)
      Dir.glob("#{Rails.root}/XMLs_New_UB04/*.xml").each do |xml_file|
        doc = Nokogiri::XML.parse(File.open("#{xml_file}"))
        # Creating the payer and matching the job with the tiff number.

        unless doc.xpath("//Revclaim_2/sources/image").blank?         
          image_name = doc.xpath("//Revclaim_2/sources/image").attr("name").gsub('.tif','')
          job = Job.find_by_tiff_number(image_name)
          unless job.nil?
            puts "got match at #{Time.now}"
            puts (xml_count_increment+1).to_s + "/" + xml_count.to_s
          else
            puts "No Match"
            puts image_name
          end
         
        unless job.nil?
        
          ub04_claim = job.ub04_claim_informations.create(:details =>{:patient_first_name_ocr_output => ""})
          ub04payers = Array.new
          
          doc.xpath("//Revclaim_2").each do |element|
            element.children.each do |row_node|              
            
         #For Parsing the informations  
          case row_node.name
           
            when /federal/,/billing/,/subscriber/,/patient/,/rendering/,/admission/,/statement/,/dx/,/admit/,/discharge/    
                # Parsing Claim Informations
                xml_data  = get_values(row_node)
                insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],ub04_claim,xml_data[5])
            
            when /ubo4_payer1/
               #parsing Payer Informations
                i=0                
                row_node.xpath("//ubo4_payer1/row").each do |child1|  
                     ub04payers[i] = ub04_claim.ub04payers.create(:details => {:payer_ocr_output => ""})
                     child1.children.each do |subchild|
                       if (subchild.name.include?'name') or (subchild.name.include?'health') or (subchild.name.include?'release') or (subchild.name.include?'assign') or (subchild.name.include?'est')
                          xml_data  = get_values(subchild)
                          insert_meta_data(xml_data[1],xml_data[4],xml_data[3],subchild.name,xml_data[0].strip,xml_data[2],ub04payers[i],xml_data[5])
                        end
                     end
                    i +=1
              end
           
            when /ubo4_payer2/
              i=0
              row_node.xpath("//ubo4_payer2/row").each do |child1|  
                  child1.children.each do |subchild|
                       if (subchild.name.include?'insur') or (subchild.name.include?'patient') or (subchild.name.include?'group')
                          xml_data  = get_values(subchild)
                          insert_meta_data(xml_data[1],xml_data[4],xml_data[3],subchild.name,xml_data[0].strip,xml_data[2],ub04payers[i],xml_data[5])
                        end
                     end
                     i +=1
              end
           
         when 'occurences'
                #parsing
                row_node.xpath("//occurences/row").each do |child1|     
                  if !child1.xpath("./code1/value").inner_text.blank? 
                     occurences = ub04_claim.occurences.create(:details=>{:occurences_from_ocr_output=>""})
                     child1.children.each do |subchild|
                       if (subchild.name.include?'code') or (subchild.name.include?'date')
                          xml_data  = get_values(subchild)
                          insert_meta_data(xml_data[1],xml_data[4],xml_data[3],subchild.name,xml_data[0].strip,xml_data[2],occurences,xml_data[5])
                        end
                     end
                  end
              end
             
             when 'occurence_spans'
               #parsing
                row_node.xpath("//occurence_spans/row").each do |child1|                      
                  if (child1.attribute("state").to_s == "Ok" and !child1.xpath("./code1/value").inner_text.blank? )
                     occurences_span = ub04_claim.occurences_spans.create(:details=>{:occurences_spans_from_ocr_output=>""})
                     child1.children.each do |subchild|
                       if (subchild.name.include?'code') or (subchild.name.include?'from') or (subchild.name.include?'through')
                          xml_data  = get_values(subchild)
                          insert_meta_data(xml_data[1],xml_data[4],xml_data[3],subchild.name,xml_data[0].strip,xml_data[2],occurences_span,xml_data[5])
                        end
                     end
                  end
              end
           
            when 'value_codes'
               #parsing
                row_node.xpath("//value_codes/row").each do |child1|                      
                  if (child1.attribute("state").to_s == "Ok" and !child1.xpath("./code1/value").inner_text.blank? )
                     value_codes = ub04_claim.value_codes.create(:details=>{:occurences_spans_from_ocr_output=>""})
                     child1.children.each do |subchild|
                       if (subchild.name.include?'code') or (subchild.name.include?'amount') 
                          xml_data  = get_values(subchild)
                          insert_meta_data(xml_data[1],xml_data[4],xml_data[3],subchild.name,xml_data[0].strip,xml_data[2],value_codes,xml_data[5])
                        end
                     end
                  end
                end
           
            when /service_line/
                row_node.xpath("//service_line/row").each do |child1|
                # This logic checks for the existence of the combinations of state,service_from_date and charges for a service line and inserts the record into the table
                   if (child1.attribute("state").to_s == "Ok" and !child1.xpath("./service_date/value").inner_text.blank? and !child1.xpath("./charges/value").inner_text.blank?)                 
                    ub04_claim_service = ub04_claim.ub04_serviceline_informations.create(:details=>{:service_from_date_ocr_output=>""})
                      child1.children.each do |subchild|
                         if (subchild.name.include?'service') or (subchild.name.include?'rev') or (subchild.name.include?'charges') or (subchild.name.include?'hcpcs') or (subchild.name.include?'non_covered') or (subchild.name.include?'description')
                          xml_data  = get_values(subchild)
                          insert_meta_data(xml_data[1],xml_data[4],xml_data[3],subchild.name,xml_data[0].strip,xml_data[2],ub04_claim_service,xml_data[5])
                        end
                      end
                  end                    
                end              
            end # End of Switch case
            
            end # end of revclaim2 child node
          end # end of Xpath
        end
      end 
        system "mv #{xml_file} #{Rails.root}/XML_archieve/"
        xml_count_increment +=1
      end
    end
  end
  
  def insert_meta_data(zone_value,page,dpi,field_name,field_value,account_state,record_pointer,confidence)
    record_pointer.update_attribute("#{field_name}","#{field_value.gsub('!','').gsub(',','').gsub('@','').gsub('#','').gsub('$','').gsub('%','').gsub('^','').gsub('&','').gsub('*','').gsub('(','').gsub(')','').gsub('-','').gsub('+','').gsub(';','').gsub(':','').gsub('"','').gsub("'","").gsub('_','').upcase}") # removes all the special characters like  "-!@#$%^*()_+"':;" and capitalizing the string.
    field_ocr_output = field_name + "_ocr_output"
    field_data_origin = field_name + "_data_origin"
    field_number_page = field_name + "_page"
    field_number_coordinates = field_name + "_coordinates"
    field_number_state = field_name + "_state"
    field_number_confidence = field_name + "_confidence"
    record_pointer.details[field_ocr_output.to_sym] = field_value if field_value
    record_pointer.details[field_data_origin.to_sym] = find_the_data_origin_of(account_state.to_s,field_value,confidence)
    record_pointer.details[field_number_page.to_sym] = page
    record_pointer.details[field_number_coordinates.to_sym] = find_the_cordinates_of(zone_value,dpi.to_i)
    record_pointer.details[field_number_state.to_sym] = account_state.to_s
    record_pointer.details[field_number_confidence.to_sym] = confidence.to_i
    record_pointer.save(false)
  end


  def get_values(patient_tag)     
    data_point = []
    data_point << patient_tag.xpath('./value').inner_text
    data_point << patient_tag.xpath('./zone').inner_text
    data_point << patient_tag.attributes["state"]
    data_point << patient_tag.xpath('./sources/image').attr('XResolution')
    data_point << 1
    data_point << patient_tag.attributes["confidence"].text
    return data_point
  end

  def find_the_data_origin_of(value,text,confidence)
    flag = text.to_s.include?("?") unless text.nil? #chances of ? with 100% confidence
    if (value == "Ok" and flag == false and confidence.to_i > 80)
      return 1
    elsif (value == "Reject" or (value == "Ok" and flag == true) or (confidence.to_i < 80))
      return 2
    elsif (value == "Empty" and flag == true)
      return 2
    elsif value == "Empty"
      return 3
    end
  end

  def find_the_cordinates_of(zone_values,dpi)
    split_zone_values = zone_values.split(" ")
    zone_array = []
    for zone in split_zone_values
      zone = zone.to_i
      a = (zone / 10) * 0.039370079 * dpi
      zone_array << a
    end
    return zone_array
  end
end
