# == Schema Information
# Schema version: 69
#
# Table name: jobs
#
#  id                    :integer(11)   not null, primary key
#  batch_id              :integer(11)
#  check_number          :string(255)
#  tiff_number           :string(255)
#  count                 :integer(11)
#  processor_status      :string(255)
#  processor_id          :integer(11)
#  processor_flag_time   :datetime
#  processor_target_time :datetime
#  qa_flag_time          :datetime
#  qa_target_time        :datetime
#  qa_id                 :integer(11)
#  payer_id              :integer(11)
#  estimated_eob         :integer(11)
#  adjusted_eob          :integer(11)
#  image_count           :integer(11)
#  comment               :string(255)
#  job_status            :string(255)   default(New)
#  qa_status             :string(255)   default(New)
#  updated_by            :integer(11)
#  updated_at            :datetime
#  created_by            :integer(11)
#  created_at            :datetime
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Job < ActiveRecord::Base
   belongs_to :updated_by, :class_name => "Remittor", :foreign_key => "updated_by"
   belongs_to :created_by, :class_name => "Remittor", :foreign_key => "created_by"
  validates_presence_of :check_number
  belongs_to :batch
  belongs_to :payer
  has_many :eob_qas
  has_many :cms1500s
  has_many :dental_claim_informations
  belongs_to :images_for_jobs 
  validates_inclusion_of :estimated_eob, :in => 0..2000, :message => "Estimated EOB is not in the Range"
  validates_inclusion_of :count, :in => 0..99999,  :message => "Count is not in the Range"
  belongs_to :processor, :class_name => "Remittor", :foreign_key => :processor_id
  belongs_to :qa, :class_name => "Remittor", :foreign_key => :qa_id
  belongs_to :sqa, :class_name => "Remittor", :foreign_key => :sqa_id
  belongs_to :hlsc, :class_name => "Remittor", :foreign_key => :hlsc_id
  has_many :cms1500s
  has_many :ub04_claim_informations

  def processor_complete_shift
    if (self.processor_status != 'Processor Complete' || self.processor_status != 'Processor Incomplete' || self.processor_flag_time.nil?) then
      return 'Undefined'
    end
    
    hours_minutes = self.processor_flag_time.strftime("%H:%M")
    
    case hours_minutes
    when "05:30" .. "13:29"
      return "Afternoon"
    when "13:30" .. "21:29"
      return "Evening"
    when "21:30" .. "23:59"
      return "Morning"
    when "00:00" .. "05:29"
      return "Morning"
    else
      return "Unknown"
    end
  end
  
  def self.payer_job_count
    find(:all, :conditions => "batch_id = batches.id and batches.status != 'Complete' and batches.status != 'HLSC Verified'",
      #:include => :batch,
      :joins => "LEFT JOIN batches on batch_id = batches.id",
      :group => "jobs.payer_id",
      :select => "sum(jobs.estimated_eob) eobs, count(*) count, jobs.payer_id payer_id")
  end

  def self.aa
    incomplete_batches = Batch.find(:all, :conditions => "status = 'Processing'")
    incomplete_batches = incomplete_batches.sort_by do |ib|
      ib.tat.expected_time
    end
    
    Batch.update_etc
    
    incomplete_batches.each do |ib|
      batch_jobs = ib.jobs
      processors_on_jobs = batch_jobs.map do |bj|
        bj.processor unless bj.processor.nil?
      end
      processors_on_jobs.uniq!
      
      online_qa = User.find(:all, :conditions => "role = 'QA' and status = 'Online'")
      online_qa = online_qa.sort_by do |oqa|
        oqa.remark
      end

      processors_on_jobs.each do |pr|
        actual_jobs = batch_jobs.select do |bj|
          bj.processor == pr
        end

        actual_jobs.each do |aj|
          unless pr.nil?
            if pr.eob_qa_checked == pr.sampling_rate or pr.eob_qa_checked >= pr.sampling_rate 
              break
            else
              if aj.qa.nil?
              	aj.qa = online_qa[0]
              	aj.qa_status = QaStatus['QA Allocated'].to_s
              	aj.update
              end
            end
          end
        end
      end
      
    end
  end
  
  def self.processor_job(userid)
    job=Job.find(:all,:conditions => "(processor_id = #{userid}) and (processor_status = 'Processor Allocated') and (qa_status = 'QA Rejected' or ( job_status != 'QA Rejected'))")
    return job
  end
  # TODO: Move this into a more appropriate place
  def self.export_processor_productivity(start_date = Time.now.yesterday.to_date, end_date = Time.now.yesterday.to_date)
    time_from = start_date.to_time.midnight
    time_to = end_date.to_time.tomorrow - 1.second

    filter = Filter.new
    filter.less time_to.to_s(:db), 'jobs.processor_flag_time'
    filter.great time_from.to_s(:db), 'jobs.processor_flag_time'

    e = Excel::Workbook.new
    jobs_array = Array.new
    jobs = Job.find(:all, :include => [{:batch => :facility}, :payer, :processor], :conditions => filter.conditions)
    unless jobs.empty?
      jobs.each do |j|
        h = Hash.new
        h["Processor"] = j.processor.nil? ? "Unknown" : j.processor.userid
        h["Batch ID"] = j.batch.batchid
        h["Batch Date"] = j.batch.date
        h["Site Number"] = j.batch.facility.sitecode
        h["Facility Name"] = j.batch.facility.name
        h["Check Number"] = j.check_number
        h["EOBs"] = j.count
        h["Payer"] = "#{j.payer.payer}(#{j.payer.payid})"
        h["Shift"] = j.processor_complete_shift
        h["Job Completion Time"] = j.processor_flag_time.strftime("%m/%d/%y %H:%M")
        jobs_array << h
      end
      e.addWorksheetFromArrayOfHashes("Productivity", jobs_array)
    
      timestamp =  "#{time_from.strftime("%Y%m%d")}_#{time_to.strftime("%Y%m%d")}"
      report_filename = "public/reports/processor_productivity_#{timestamp}.xls"

      File.open(report_filename, 'w') {|f| f.puts(e.build)}
    end
  end

  def self.processor_name_id(id)

    @user = Remittor.find(:first,:conditions => "id = #{id}")

    if not(@user.blank?)
      @user = @user.login
    else
      @user = '-'
    end
    return @user

  end

  def self.auto_allocate_job(userid)
    job = Job.find(:first,:conditions => "(jobs.processor_status = 'New' or jobs.processor_status is null) and batches.status in ('New','Processing') and batches.auto_allocation_status = 'ACTIVATE'",
      :include => :batch,
      :order => "batches.target_time,batches.status")
    allocation_status = Remittor.find(userid).allocation_status
    job_count = Job.count(:all,:conditions => "processor_id = #{userid} and processor_status = 'Processor Allocated'")
    if(job)
      if(job_count == 0 and allocation_status == true)
        job.processor_id = userid
        job.processor_status = 'Processor Allocated'
        job.job_status = 'Processing'
        job.save

        batch = Batch.find(job.batch_id)
        batch.update_status
        batch.get_etc

      end
    end
  end 

def getqaid(jobid)


   qaid=Job.find(:first,:conditions=>"id='#{jobid}'").qa_id
  return qaid
end

  def self.qa_name(id)

    puts id
    @user = Remittor.find(:first,:conditions => "id = #{id}")

    if not(@user.blank?)
    @user = @user.login
    else
     @user = '-'
    end
return @user

  end

end
