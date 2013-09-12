# == Schema Information
# Schema version: 22
#
# Table name: runners
#
#  id            :integer(11)   not null, primary key
#  imported_at   :datetime      
#  imported_by   :string(255)   
#  imported_from :string(255)   
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

#require 'dbf'
#require 'rubygems'
require 'zip/zipfilesystem'
require 'tzinfo'
#require 'RMagick'
#require 'FileUtils'

RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(Rails.root)

 UNZIPPED_PATH="#{Rails.root}/public/unzipped_files/"
 RAILS_PATH = "#{Rails.root}/"
 


# Runner is a utility class used primarily for running various import processes. It also is an ActiveRecord subclass used 
# to store information about what files were imported when and by whom.

class Runner < ActiveRecord::Base  
  # input_zipfile method accepts a batch (.zip) file.
  # Unzip images in zipfile and convert to jpg.If the batch is not in batch table then create a new entry 
  # and save in batch table.Same case for job table and images_for_jobs table. (Images_for_jobs table is 
  # used to store image details)
  def self.input_zipfile(source_zip,facility,arrivaltime)
    #   begin
    file_to_write = Time.now.strftime("%Y%m%d-%H%M").to_s + ".log"
    log_file = File.open("#{RAILS_PATH}runner_log/#{file_to_write}" , "w")
    log = Logger.new(log_file)
    @batch_id = nil
    @image_id = nil
    @existing_batch = nil
    source_zip_name = source_zip.split("/").last
    target_zip_name = source_zip_name.chomp(".zip")
    @target = "#{UNZIPPED_PATH}#{target_zip_name}"
    begin
      Dir.mkdir(@target) unless File.exists? @target
    end
    file_to_split = source_zip_name
    batch_file_name = file_to_split.chomp(".zip")     
    @batch = Batch.find(:first,:conditions => "batchid = '#{batch_file_name}'") 
    if !@batch.nil?
      log.info "Existing batch"
      @batch.status = "New"
      if @batch.save
        log.info "Batch updated"
        @existing_batch = @batch
      end 
    else
      batch_date = file_to_split.split("_").last
      date =  batch_date.slice(0,4) + "-" + batch_date.slice(4,2) + "-" + batch_date.slice(6,2)
#      arrival_time_file_content = []
#      log.info "Reading arrival time text file"
#      File.open("#{RAILS_PATH}zip_new/#{source_zip_name}.txt", "r").each { |line| arrival_time_file_content = line }
#      arrival_time_file_content = arrival_time_file_content.strip
#      arrival_time_file_content_array =  arrival_time_file_content.split(' ')
#      arrival_time = arrival_time_file_content_array[arrival_time_file_content_array.length-2]
#      arrival_date = Time.now.strftime("%Y-%m-%d").to_s
#      arrival_time_new = arrival_date +  " " + arrival_time+ ":00"
#      arrival_time_final = arrival_time_new.to_time + Runner.ist_offset

      # arrival time should be in the format YYYY-MM-DD HH:MM
      arrival_time_final = arrivaltime
      @new_batch = Batch.new
      log.info "New batch"
      @new_batch.batchid = file_to_split.chomp(".zip")
      @facility = Facility.find_by_name("#{facility}")
#      if batch_file_name.include?("PCN")
#        @facility = Facility.find_by_name("PCN")
#      elsif batch_file_name.include?("2790")
#        @facility = Facility.find_by_name("UFPAS")
#      else
#        @facility = Facility.find_by_name("AMLI")
#      end
      if file_to_split.upcase.include?("UB04")
        @new_batch.type_of_claim = "UB04"
      else
        @new_batch.type_of_claim = "CMS1500"
      end
      @new_batch.facility_id = @facility.id
      @new_batch.arrival_time = arrival_time_final
      @new_batch.date =  date
      @client = Client.find_by_name("PCN")
      @new_batch.contracted_time = @new_batch.arrival_time + @client.tat.hours
      @new_batch.target_time =  @new_batch.arrival_time + @facility.internal_tat.to_i.hours
      @new_batch.save
      if @new_batch.save
        log.info "batch created"
        @batch_id = @new_batch.id
      end 
    end
    Zip::ZipFile.open(source_zip) do |zipfile|
      zip_dir = zipfile.dir
      zip_dir.entries('.').each do |entry|
        @job_tiff_number = entry.split('.')[0].to_s
        #jpg_entry = @job_tiff_number + ".jpg"
        zipfile.extract(entry , "#{@target}/#{entry}")

        if !@existing_batch.nil?
    
          @job_already_exist = Job.find(:first,:conditions=>["batch_id=? and tiff_number=?",@existing_batch.id,@job_tiff_number])
          if @job_already_exist
            @image = ImagesForJob.find(@job_already_exist.images_for_job_id)
            if @image
              @image.destroy
            end
          end
          @images = ImagesForJob.new :image => File.open("#{@target}/#{entry}","rb") , :filename => "#{entry}"
#          @images = ImagesForJob.new :filename => "#{entry}" , :content_type => 'image/tif',
#            :temp_path => "#{@target}/#{entry}"
          @images.save
          @image_id = @images.id
          @job_already_exist = Job.find(:first,:conditions=>["batch_id=? and tiff_number=?" , @existing_batch.id,@job_tiff_number])
          if @job_already_exist
            @job_already_exist.destroy
          end
          save_new_job(@existing_batch.id , @batch_id , @job_tiff_number , @image_id)
          count_pages(@image_id)
        else
          @images = ImagesForJob.new :image => File.open("#{@target}/#{entry}","rb") , :filename => "#{entry}"
#          @images = ImagesForJob.new :filename => "#{entry}", :content_type => 'image/tif',
#            :temp_path => "#{@target}/#{entry}"
          @images.save
          @image_id = @images.id
          save_new_job(@existing_batch , @batch_id , @job_tiff_number , @image_id)
          count_pages(@image_id)
        end
      end
    end
    @batch = Batch.find(:first,:conditions => "batchid = '#{batch_file_name}'") 
    if @batch
      @job_count = Job.count(:all,:conditions=>["batch_id = ?" , @batch.id])
      @batch.eob = @job_count
      @batch.save
    end
   
    image_files  = Dir.entries(@target)
    image_files= image_files - ["."]
    image_files= image_files - [".."]
    for i in 0 ..image_files.length - 1
      File.delete(@target + "/"+image_files[i])
    end
    Dir.rmdir(@target)

  end

# Function to count the number of pages in a job.
# we have to install libtiff library in our linux machine to run the command tiffinfo

  def self.count_pages(image_id)

    image = ImagesForJob.where("id = #{image_id}")
    image_path = image.first.base_path + image.first.public_filename            # get the respective image for the current job
    image_info = %x(tiffinfo #{image_path})                                     # running the system command to get the image information
    image_array = image_info.split("\n")                                        # from image information we get the information of each pages including the page numbers
    page_number_key = image_array.rindex{|x| x.include?("Page Number:")}        # parsing the page number key from image information hash
    if !page_number_key.nil?                                                    # in some cases of single page images, 'Page Number' key is missing so checking that condition
      page_details = image_array.at(page_number_key)                            # parsing the 'Page Number' key of last page
      page_number = page_details.strip.split(' ')                               # the key value pair should be like 'Page Number 2-0' format if there are 3 pages in the image
      page_count = page_number.last.at(0).to_i + 1                              # retreving 2 from 2-0 in the example.
    else
      page_count = 1                                                            # for single page claims which do not contain 'Page Number' key in tiffinfo
    end
    
    @job.page_count = page_count
    @job.save

  end
  
  def self.save_new_job(existing_batch,batch,tiff_number,image)
    @job = Job.new()
    if !existing_batch.nil?
      @job.batch_id=existing_batch
    else
      @job.batch_id= batch.to_i    
    end      
    @job.tiff_number = tiff_number
    @job.check_number = 999
    @job.estimated_eob = 1
    @job.image_count = 1
    @job.images_for_job_id = image.to_i
    @payer = Payer.find_by_payer("Vestica")
    @job.payer_id = @payer.id
    @job.save     
  end

#  def self.dental_input
#   ans_dental_input_zipfile("D:/projects/revdental_09-09-08/20080211122330/20080918_5.zip")
#  end
#
#  def self.ans_dental_input_zipfile(source_zip)
#     file_to_write = Time.now.strftime("%Y%m%d-%H%M").to_s + ".log"
#    log_file = File.open("#{RAILS_PATH}runner_log/#{file_to_write}" , "w")
#    log = Logger.new(log_file)
#    @batch_id = nil
#    @image_id = nil
#    @existing_batch = nil
#    source_zip_name = source_zip.split("/").last
#    target_zip_name = source_zip_name.chomp(".zip")
#    @target = "#{UNZIPPED_PATH}#{target_zip_name}"
#    begin
#      Dir.mkdir(@target) unless File.exists? @target
#    end
#    file_to_split = source_zip_name
#    batch_file_name = file_to_split.chomp(".zip")
#
#    batch_date = file_to_split.split("_").first
#    date =  batch_date.slice(0,4) + "-" + batch_date.slice(4,2) + "-" + batch_date.slice(6,2)
#    arrival_time_file_content = []
#    log.info "Reading arrival time text file"
#    File.open("#{RAILS_PATH}zip_new_ans_dental/#{source_zip_name}.txt", "r").each { |line| arrival_time_file_content = line }
#    arrival_time_file_content = arrival_time_file_content.strip
#    arrival_time_file_content_array =  arrival_time_file_content.split(' ')
#    arrival_time = arrival_time_file_content_array[arrival_time_file_content_array.length-2]
#    arrival_time_new = date +  " " + arrival_time+ ":00"
#    arrival_time_final = arrival_time_new.to_time
#    @new_batch = Batch.new()
#    log.info "New batch"
#    @new_batch.batchid = file_to_split.chomp(".zip")
#    @facility = Facility.find_by_name("ANS Dental")
#    @new_batch.facility_id = @facility.id
#    @new_batch.arrival_time = arrival_time_final
#    @new_batch.date =  date
#    @client = Client.find_by_name("ANS Dental")
#    @new_batch.contracted_time = @new_batch.arrival_time + @client.tat.hours
#    @new_batch.target_time =  @new_batch.arrival_time + @client.tat.hours
#    @new_batch.save
#    if @new_batch.save
#      log.info "batch created"
#      @batch_id = @new_batch.id
#    end
#
#    Zip::ZipFile.open(source_zip) do |zipfile|
#      zip_dir = zipfile.dir
#      zip_dir.entries('.').each do |entry|
#        @tiff_number = entry.split('.')[0]
#        jpg_entry = @tiff_number + ".jpg"
#        zipfile.extract(entry , "#{@target}/#{entry}")
##        system "convert #{@target}/#{entry} #{@target}/#{jpg_entry} 2>/dev/null;"
#                        new_jpg_image = Magick::ImageList.new("#{@target}/#{entry}")
#                        new_jpg_image.write("#{@target}/#{jpg_entry}")
#        File.delete("#{@target}/#{entry}")
#        @images = ImagesForJob.new :filename => "#{jpg_entry}", :content_type => 'image/jpg',
#          :temp_path => "#{@target}/#{jpg_entry}"
#        @images.save
#        if @images.save
#          @job = Job.new()
#
#          @job.batch_id= @batch_id
#
#          @job.tiff_number = @tiff_number
#          @job.check_number = 999
#          @job.estimated_eob = 1
#          @job.image_count = 1
#          @job.images_for_job_id = @images.id
#          @payer = Payer.find_by_payer("ANS Dental")
#          @job.payer_id = @payer.id
#          if @job.batch_id
#          @job.save
#          end
#        end
#         end
#    end
#        @batch = Batch.find_by_batchid(batch_file_name)
#        if @batch
#          @job_count = Job.count(:all,:conditions=>["batch_id = ?" , @batch.id])
#          @batch.eob = @job_count
#          @batch.update
#        end
#        image_files  = Dir.entries(@target)
#        for i in 2 ..image_files.length - 1
#          File.delete(@target + "/"+image_files[i])
#        end
#        Dir.rmdir(@target)
#
#
#
#        #   rescue Exception => e
#        #     log.info e
#        #     log.info e.backtrace.join("\n")
#        #     log.info "\n"
#        #   end
#
#
#      end
#
 
  private
  def self.ist_offset
    est = TimeZone["Eastern Time (US & Canada)"]
    ist = TimeZone["Mumbai"]
    return  ((ist.now.to_i - est.now.to_i) / 60.0 / 60.0).hours
  end

end
