namespace :parse do
  desc 'cms1500 parser'

  task :cms1500 => :environment do
    require "nokogiri"

    #Reading the file containing the total count of the xmls to be generated.
    
    file = File.open("#{Rails.root}/XMLs_New/xmlcount.txt" , "r+")
    xml_count = file.readlines[0]
    file.close
    xml_count_increment = 0
    while true

      #exit he parser if the text file count is equal to the total count.
      exit if(xml_count_increment.to_i == xml_count.to_i)
      Dir.glob("#{Rails.root}/XMLs_New/*.xml").each do |xml_file|
        doc = Nokogiri::XML.parse(File.open("#{xml_file}"))

        # Creating the payer and matching the job with the tiff number.

        unless doc.xpath("//Revclaim_2/sources/image").blank?
          payer_name = doc.xpath("//Revclaim_2/payer/value")
          @payer = Payer.create(:details => {:payer_ocr_output => ""})
          image_name = doc.xpath("//Revclaim_2/sources/image").attr("name").gsub('.tif','')
          @job = Job.find_by_tiff_number(image_name)
          unless @job.nil?
            puts "got match at #{Time.now}"
            puts (xml_count_increment+1).to_s + "/" + xml_count.to_s
          else
            puts "No Match"
            puts image_name
          end
        

        unless @job.nil?
          @cms = @job.cms1500s.create(:details => {:patient_first_name_ocr_output => ""})
          @payer.cms1500_id = @cms.id
          @payer.save(false)
          doc.xpath("//Revclaim_2").each do |element|
            element.children.each do |row_node|

              #For Parsing the claim level informations.

              if (row_node.node_name == 'payer') or (row_node.node_name == 'pay_address_one') or (row_node.node_name == 'pay_address_two') or (row_node.node_name == 'zipcode') or (row_node.node_name == 'state') or (row_node.node_name == 'city')
                xml_data  = get_values(row_node)
                insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@payer,xml_data[5])
              end
              if (row_node.name.include?'balance') or (row_node.name.include?'total') or (row_node.name.include?'amount') or (row_node.name.include?'federal') or (row_node.name.include?'nature_of') or (row_node.name.include?'hospitalization') or (row_node.name.include?'billing') or (row_node.name.include?'date') or (row_node.name.include?'other')
                xml_data  = get_values(row_node)
                insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
              end

              db_field = row_node.name.include?'patient'
              non_db_field = row_node.name.include?'patient_name'
              if (db_field == true) and (non_db_field == false)
                xml_data  = get_values(row_node)
                insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
              end


              db_field = row_node.name.include?'referring'
              non_db_field = row_node.name.include?'referring_provider_name'
              if (db_field == true) and (non_db_field == false)
                xml_data  = get_values(row_node)
                insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
              end

              db_field = row_node.name.include?'physician'
              non_db_field = row_node.name.include?'physician_name'
              if (db_field == true) and (non_db_field == false)
                xml_data  = get_values(row_node)
                insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
              end

              db_field = row_node.name.include?'insur'
              non_db_field = row_node.name.include?'insured_name'
              if (db_field == true) and (non_db_field == false)
                xml_data  = get_values(row_node)
                insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
              end

              db_field = row_node.name.include?'service'
              non_db_field = row_node.name.include?'service_line'
              if (db_field == true) and (non_db_field == false)
                xml_data  = get_values(row_node)
                insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
              end
                  
              #For Parsing the Service Lines

              if (row_node.name.include?'service_line')
                row_node.xpath("//service_line/row").each do |child1|

                  # This logic checks for the existence of the combinations of state,service_from_date and charges for a service line and inserts the record into the table

                  if (child1.attribute("state").to_s == "Ok" and !child1.xpath("./service_from_date/value").inner_text.blank? and !child1.xpath("./charges/value").inner_text.blank?)
                    @service_line = @cms.service_lines.create(:details=>{:service_from_date_ocr_output=>""})
                    child1.children.each do |subchild|
                      if (subchild.name.include?'service') or (subchild.name.include?'emg') or (subchild.name.include?'charges') or (subchild.name.include?'diagnosis') or (subchild.name.include?'cpt') or (subchild.name.include?'days') or (subchild.name.include?'rendering') or (subchild.name.include?'modifier')
                        xml_data  = get_values(subchild)
                        insert_meta_data(xml_data[1],xml_data[4],xml_data[3],subchild.name,xml_data[0].strip,xml_data[2],@service_line,xml_data[5])
                      end
                    end
                  end
                    
                end

              end

            end
          end
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
    #data_point << ImagesForJob.find_by_filename(patient_tag.xpath('./sources/image').attr('name')).image_number if ImagesForJob.find_by_filename(patient_tag.xpath('./sources/image').attr('name'))
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
