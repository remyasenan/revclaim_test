# == Schema Information
# Schema version: 69
#
# Table name: payers
#
#  id                :integer(11)   not null, primary key
#  date_added        :date          
#  initials          :string(255)   
#  from              :string(255)   
#  gateway           :string(255)   
#  payid             :string(255)   
#  payer             :string(255)   
#  gr_name           :string(255)   
#  pay_address_one   :text          
#  pay_address_two   :text          
#  pay_address_three :text          
#  pay_address_four  :text          
#  phone             :string(255)   
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.
require 'OCR_Data'
include OCR_Data
class Payer < ActiveRecord::Base
  attr_accessor :style,:coordinates, :page
  validates :payid, :payer, :gateway,:presence => true
  validates_uniqueness_of :payid
  has_many :jobs
  has_many :user_payer_job_histories
  belongs_to :cms_claim, :class_name => "Cms1500"
  has_details :payer,
               :pay_address_one,
               :pay_address_two,
               :zipcode,
               :state,
               :city


  def count_processor_input_payer_fields()
    total_payer_fields_with_data = 0
    payer_fields = [payer, pay_address_one, pay_address_two, zipcode, state, city]

    payer_fields_with_data = payer_fields.select{|field| !field.blank? and field != '--'}

    total_payer_fields_with_data = payer_fields_with_data.length

    return total_payer_fields_with_data
  end

  def to_s
    self.payer
  end

  def popup
    "#{payer.to_s} + #{pay_address_one} + #{pay_address_two} + #{id} + #{state} + #{city} + #{zipcode.to_s}"
#   self.payer
  end
 
  #finds job with minimum estimated_eobs for the payer and returns expected time for job's batch
  def least_time
    payer = self
    job = Job.find(:first,:conditions => "jobs.payer_id = #{payer.id} and batches.status != 'Complete' and batches.status != 'HLSC Verified'",
                          :include => :batch, 
                          :order => "batches.arrival_time, jobs.estimated_eob")
    unless job.nil?
      return job
    else
      return nil
    end
  end
  def least_times(pgid)
    payer = self
    job = Job.find(:first,:conditions => "jobs.payer_id= #{payer.id} and batches.status != 'Complete' and batches.status != 'HLSC Verified' where payer.payer_group_id=#{pgid}",
                          :include => :batch, 
                          :order => "batches.arrival_time, jobs.estimated_eob")
    unless job.nil?
      return job
    else
      return nil
    end
  end

   def self.payer_details(payer)
      payer_details = {}
      payer_info = payer.split('+')
#      payer_id = payer_info[3]
#      payer_name = payer_info[0].strip rescue nil
#      payer_city = payer_info[5].strip rescue nil
#      payer_state = payer_info[4].strip rescue nil
#      payer_zipcode = payer_info[6].strip rescue nil
#      payer_pay_address_one = payer_info[1].strip rescue nil
#      payer = TypeaheadPayers.find_by_payer_and_city_and_state_and_zipcode_and_pay_address_one(payer_name,payer_city,payer_state,payer_zipcode,payer_pay_address_one)
      payer = TypeaheadPayers.find(payer_info[3])
      payer_details["payer_id"] =  payer_info[3]
      payer_details["payer_address_one"] = payer.pay_address_one rescue nil
      payer_details["payer_address_two"] = payer.pay_address_two rescue nil
      payer_details["payer_city"] = payer.city rescue nil
      payer_details["payer_state"] = payer.state rescue nil
      payer_details["payer_zip"] = payer.zipcode rescue nil
      return payer_details.to_json
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
