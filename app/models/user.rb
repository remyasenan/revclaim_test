# == Schema Information
# Schema version: 69
#
# Table name: users
#
#  id                     :integer(11)   not null, primary key
#  name                   :string(255)
#  userid                 :string(255)
#  password               :string(255)
#  shift                  :string(255)
#  remark                 :string(255)
#  role                   :string(255)
#  status                 :string(255)   default(Offline)
#  session                :string(255)
#  rating                 :string(255)
#  processing_rate_triad  :integer(11)   default(5)
#  processing_rate_others :integer(11)   default(8)
#  is_deleted             :boolean(1)
#  total_fields           :integer(11)   default(0)
#  total_incorrect_fields :integer(11)   default(0)
#  accuracy               :integer(11)   default(100)
#  eob_qa_checked         :integer(11)   default(0)
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

require 'digest/sha1'
require 'tzinfo'
include TZInfo

class User < ActiveRecord::Base
  cattr_accessor :current_user
  validates_presence_of :userid, :password
  validates_uniqueness_of :userid
  validates_inclusion_of :processing_rate_triad, :in => (1..35), :message => "  is out of range (1..35)"
  validates_inclusion_of :processing_rate_others, :in => (1..35), :message => "  is out of range (1..35)"
  
  belongs_to :shift

  has_many :processor_jobs, :class_name => "Job", :foreign_key => "processor_id"
  has_many :qa_jobs, :class_name => "Job", :foreign_key => "qa_id"
  has_many :sqa_jobs, :class_name => "Job", :foreign_key => "sqa_id"

  has_many :processor_eob_qas, :class_name => "EobQa", :foreign_key => "processor_id"
  has_many :qa_eob_qas, :class_name => "EobQa", :foreign_key => "qa_id"
  
  has_many :processor_eob_sqas, :class_name => "EobSqa", :foreign_key => "processor_id"
  has_many :qa_eob_sqas, :class_name => "EobSqa", :foreign_key => "qa_id"
  has_many :sqa_eob_sqas, :class_name => "EobSqa", :foreign_key => "sqa_id"
  
  has_many :hlsc_jobs, :class_name => "Batch", :foreign_key => "hlsc_id"
  has_many :certifications
  has_many :user_payer_job_histories
  has_many :clients, :through => :certifications
  has_many :user_client_job_histories
  has_many :clients, :through => :user_client_job_histories  
  
  has_many :members, :class_name => "User", :foreign_key => "teamleader_id"
  belongs_to :teamleader, :class_name => "User", :foreign_key => "teamleader_id"

  def jobs
    if self.role == 'Processor'
      self.processor_jobs
    else
      self.qa_jobs
    end
  end

  def has_pending_jobs?
    case self.role
    when 'Processor'
      return jobs.count("processor_status = 'Processor Allocated'") > 0
    when 'QA'
      return jobs.count("qa_status = 'QA Allocated'") > 0
    when 'TL'
      return self.processor_jobs.count("processor_status = 'Processor Allocated'") > 0
    end
  end

  # returns true if the user is online
  def is_online?
    if self.status == "Online"
        return true
    else
        return false
    end
  end


  #Calculating the eob's completed by processor in the last 12 hrs
  def completed_eob
    count = 0
		#ist = convert_to_ist_time(Time.now)
		time_minus_12_hrs = Time.now - 12.hours
		#ist = ist.at_beginning_of_day
		#est_from_ist_at_zero_hrs = convert_to_est_time(ist)
		
    self.jobs.find(:all, :conditions => ["processor_flag_time >= ?", time_minus_12_hrs]).each do |j|
      if j.count? and j.processor_flag_time >= time_minus_12_hrs
        count = count + j.count 
      end
    end
    return count
  end

  def convert_to_ist_time(time)
    tz_est = Timezone.get('US/Eastern')
    utc_time = tz_est.local_to_utc(time, false)
    tz_ist = Timezone.get('Asia/Calcutta')
    ist_time = tz_ist.utc_to_local(utc_time)
    return ist_time
  end

	def convert_to_est_time(time)
		tz_ist = Timezone.get('Asia/Calcutta')
		utc_time = tz_ist.local_to_utc(time, false)
		tz_est = Timezone.get('US/Eastern')
		est_time = tz_est.utc_to_local(utc_time)
		return est_time
	end

  #Calculating the eob's completed by QA in the last 12 hours
  #Commented code calculates for the current day
  def completed_eob_by_qa
    count = 0
    time_minus_12_hrs = Time.now - 12.hours
    report = EobReport.find_all_by_qa(self.userid)
    report.each do |e|
      if e.verify_time >= time_minus_12_hrs
        count = count + 1
      end
      #if (convert_to_ist_time(e.verify_time)).strftime('%Y-%m-%d').to_s == (convert_to_ist_time(Time.now)).strftime('%Y-%m-%d').to_s
      #  count = count + 1
      #end
    end
    return count
  end

  #returns client specific per hour eob rate for processor
  def processing_rate_for_client(client)
    if client.name == 'Triad' || client.name == 'Partners' || client.name == 'Childrens'
      return self.processing_rate_triad
    else
      return self.processing_rate_others
    end
  end

  def User.default_processing_rate_for_client(client)
    if client.name == 'Triad' || client.name == 'Partners' || client.name == 'Childrens'
      return 5
    else
      return 8
    end
  end

  #assign H/M/L rating to processors
  def assign_rating_to_processor
    processor = self
    unless processor.processing_rate_triad.nil? and processor.processing_rate_others.nil?
      if processor.processing_rate_triad >= 12 and processor.processing_rate_others >= 20
        processor.rating = 'H'
      elsif processor.processing_rate_triad >= 9 and processor.processing_rate_triad >= 14
        processor.rating = 'M'
      elsif processor.processing_rate_triad >= 5 and processor.processing_rate_triad >= 8
        processor.rating = 'L'
      end
      processor.update
    end
  end

  def assign_default_rating_to_processor
    processor = self
    if processor.processing_rate_triad.nil? or processor.processing_rate_triad == 0
      processor.processing_rate_triad = 5
    end
    if processor.processing_rate_others.nil? or processor.processing_rate_others == 0
      processor.processing_rate_others = 8
    end
    processor.update
  end

  def self.login(userid, password)
    hashed_password = hash_password(password || "")
    find(:first,
         :conditions => ["userid = ? and password = ?",
                        userid, hashed_password])
  end

  def try_to_login
    User.login(self.userid, self.password)
  end

  def before_create
    self.password = User.hash_password(self.password)
  end

  def pass_hash(password)
    Digest::SHA1.hexdigest(password)
  end

  def to_s
    self.name
  end

  def update_online_status
    # Try to find the session id stored in the user model. If the session is found then the User is still online, otherwise the user is offline.
    current_session =  Session.find_by_session_id(self.session)
    if current_session.nil?
      self.status = 'Offline'
      self.session = nil
    end
    self.update
  end

  def self.update_online_status
    users = User.find_all
    users.each do |user|
      user.update_online_status
    end
  end

  def sampling_rate
    if self.total_fields.to_i != 0
      accuracy_for_fields = ((self.total_fields.to_f - self.total_incorrect_fields.to_f)*100)/self.total_fields.to_f
    else
      accuracy_for_fields = 100
    end
    #accuracy based on correct and incorrect fields
    self.field_accuracy = accuracy_for_fields

    #Reset the field_accuracy to 100
    if accuracy_for_fields < 0
      accuracy_for_fields = 100
      self.field_accuracy = 100
      self.total_fields = 0
      self.total_incorrect_fields = 0
    end

    sampling_rate = 5
    case accuracy_for_fields.to_i
    when 95..100
      sampling_rate = SamplingRate.find(1).value
    when 90..94
      sampling_rate = SamplingRate.find(2).value
    when 85..89
      sampling_rate = SamplingRate.find(3).value
    when 80..84
      sampling_rate = SamplingRate.find(4).value
    when 75..79
      sampling_rate = SamplingRate.find(5).value
    else
      sampling_rate = SamplingRate.find(6).value
    end
    self.update
    return sampling_rate
  end
  
  #Recalculates eob_accuracy based on correct and incorrect eobs
  def compute_eob_accuracy
    if self.total_eobs > 0 
      accuracy_for_eobs = ((total_eobs.to_f - rejected_eobs.to_f)/total_eobs.to_f) * 100.to_f
    else
      accuracy_for_eobs = 100
    end
    self.eob_accuracy = accuracy_for_eobs
    
    if accuracy_for_eobs < 0
      self.eob_accuracy = 100
      self.total_eobs = 0
      self.rejected_eobs = 0
    end
    self.update
  end

  def eobs_qaed(processor)
    eob_count = EobReport.count("qa = '#{self.userid}' and processor = '#{processor.userid}'")
    return eob_count
  end

  def rejected_eobs_qaed(processor)
    eob_count = EobReport.count("qa = '#{self.userid}' and processor = '#{processor.userid}' and status = 'Rejected'")
    return eob_count
  end

  #Reset eob qa checked field for new day
  def reset_eob_qa_checked()
    reset_value = EobReport.find(:first, :conditions => ["processor = ? and verify_time > ?",self.userid, (Time.now.yesterday).at_beginning_of_day], :order => "id DESC")
    if(reset_value.nil? or (convert_to_ist_time(reset_value.verify_time)).strftime('%Y-%m-%d').to_s != (convert_to_ist_time(Time.now)).strftime('%Y-%m-%d').to_s)
      self.eob_qa_checked = 0
    end
    self.update
  end

  # Class level method to update all the processor EOB QAd for new day
  def User.reset_eob_qad
    users = User.find(:all, :conditions => "role = 'Processor'")
    users.each do |user|
      user.eob_qa_checked = 0
      user.update
    end
  end
  
  def jobs_for_processor
    jobs = self.processor_jobs.find(:all, :from => "jobs ignore index(jobs_processor_id_index)", :conditions => "processor_status = 'Processor Allocated' or qa_status = 'QA Rejected' or (job_status = 'HLSC Rejected' and job_status != 'QA Rejected')",:order=>"batch_id")
  end
  
  def allowed_shift?
    return true

    current_time = convert_to_ist_time(Time.now)
    current_time_at_2000 = Time.local(2000, "Jan", 1, current_time.hour, current_time.min, 0)
    shift_start_time = self.shift.start_time
    shift_end_time = shift_start_time + self.shift.duration.hours
    if current_time_at_2000 >= shift_start_time and current_time_at_2000 <= shift_end_time
      return true
    else
      return false
    end
  end
  
  def facility_jobs(from, to)
    self.jobs.find(:all, :conditions => ["processor_flag_time >= ? and processor_flag_time <= ?", from, to],
                         :joins => "left join batches on batch_id = batches.id " +
                                   "left join facilities on facility_id = facilities.id",
                         :group => "facilities.id",
                         :select => "sum(count) eob_count, count(check_number) job_count, facilities.name facility_name, facilities.id")
  end

  private
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end

end
