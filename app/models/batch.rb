
class Batch < ActiveRecord::Base
  belongs_to :updated_by, :class_name => "Remittor", :foreign_key => "updated_by"
  belongs_to :created_by, :class_name => "Remittor", :foreign_key => "created_by"
  has_many :jobs, :dependent => :destroy
  has_many :cms1500s, :through => :jobs
  has_many :ub04_claim_informations, :through => :jobs
  has_many :dental_claim_informations, :through => :jobs
  has_one :tat, :dependent => :destroy
  has_many :client_status_histories, :dependent => :destroy
  belongs_to :facility
  delegate :client, :to => :facility
  belongs_to :payer
 # validates_presence_of :batchid, :facility
 # validates_uniqueness_of :batchid

  has_many :cms1500s, :through => :jobs
  
  NOMINAL_PROCESSOR_RATE = 12.5
  NOMINAL_QA_RATE = 10

  def get_completed_eobs
    completed_eobs = 0
    self.jobs.each do |job|
      completed_eobs = job.estimated_eob + completed_eobs
    end
    return completed_eobs
  end

  def get_completed_claims(batch)
    #jobs = Job.where(batch_id = batchid)
    completed_claims = 0
    batch.jobs.each do |job|

       if job.batch.batchid.upcase.include?("CMS1500")
        completed_claims += Cms1500.where("job_id = #{job.id}").count
       else
        completed_claims += Ub04ClaimInformation.where("job_id = #{job.id}").count
       end

    end
    return completed_claims
  end

  def get_etc
    if self.manual_override == true
      time_to_add = self.tat.expected_time
    else
      time_to_add = self.expected_time
    end
    if self.tat.nil?
      tat = Tat.new
      tat.expected_time = time_to_add
      tat.batch_id = self.id
      tat.save!
    else
      tat = self.tat
      tat.expected_time = time_to_add
      tat.save
    end
    tat.reload
    self.tat = tat
    self.save
  end

  def expected_time
    #Processor completion time calculation
    proc_id, max_assigned_eobs = Job.sum(:estimated_eob, :joins => "left join batches on batches.id = jobs.batch_id", :conditions => ["batches.id = ? and jobs.processor_id is not NULL", self.id], :group => "processor_id").max do |a,b|
      begin
        user_a = User.find(a[0])
        user_a_rate = user_a.processing_rate_for_client(self.client)
      rescue
        # If the user is deleted after assignment
        user_a_rate = User.default_processing_rate_for_client(self.client)
      end
      begin
        user_b = User.find(b[0])
        user_b_rate = user_b.processing_rate_for_client(self.client)
      rescue
        # If the user is deleted after assignment
        user_b_rate = User.default_processing_rate_for_client(self.client)
      end
      a[1].to_f / user_a_rate <=> b[1].to_f / user_b_rate
    end
    processor_time_to_complete = nil
    if proc_id != nil and max_assigned_eobs != nil
      begin
        processor = User.find(proc_id)
        processing_rate = processor.processing_rate_for_client(self.client)
      rescue
        processing_rate = User.default_processing_rate_for_client(self.client)
      end
      processor_time_to_complete = (max_assigned_eobs.to_f / processing_rate).hours
    end

    #QA completion time calculation
    # We assumed that QA is already assigned to jobs
    qa_id, qa_max_assigned_eobs = Job.sum(:estimated_eob,
      :joins => "left join batches on batches.id = jobs.batch_id",
      :conditions => ["batches.id = ? and jobs.qa_id is not NULL", self.id],
      :group => "qa_id").max do |a,b|
      a[1] <=> b[1]
    end
    if qa_id != nil and qa_max_assigned_eobs != nil
      qa_time_to_complete = (qa_max_assigned_eobs.to_f / NOMINAL_QA_RATE.to_f).hours
    end

    if processor_time_to_complete.nil? and qa_time_to_complete.nil?
      computed_expected_time = nil
    elsif qa_time_to_complete.nil?
      computed_expected_time = Time.now + processor_time_to_complete
    elsif processor_time_to_complete.nil?
      computed_expected_time = Time.now + qa_time_to_complete
    else
      computed_expected_time = Time.now + processor_time_to_complete + qa_time_to_complete
    end

    return computed_expected_time
  end

  def update_status
    self.reload
    jobs = self.jobs

    complete_jobs = jobs.select do |job|
      # QA allocation is not done for all the jobs. Hence it is difficult to compute the status of the batch. Currently the logic employed is, if all the subjobs are either in 'QA Complete' or 'Processor complete', the batch is tagged 'Complete'
      job.job_status == 'Complete'
    end

    new_jobs = jobs.select do |job|
      job.job_status == 'New'
    end

    allocated_jobs = jobs.select do |job|
      job.job_status == 'Processing'
    end

    hlsc_verified_jobs = jobs.select do |job|
      job.job_status == 'HLSC Verified'
    end

    hlsc_rejected_jobs = jobs.select do |job|
      job.job_status == 'HLSC Rejected'
    end

    hlsc_processing_jobs = jobs.select do |job|
      job.job_status == 'HLSC Processing'
    end

    # Batch Status to be 'New'
    # - There are no jobs created
    # - All the sub jobs are in new status

    # Batch Status to be 'Complete'
    # - All the sub jobs are either in 'Processor Complete' or 'QA Complete status'

    # Batch Status to be 'Processing'
    # - If the above condition is not satisfied
    # - And the batch status is not 'HLSC Verified' or 'HLSC Rejected'

    if jobs.size == new_jobs.size or jobs.size == 0
      self.status = BatchStatus.find_by_name('New').name.to_s
      self.completion_time = nil
    elsif jobs.size ==  complete_jobs.size
      self.completion_time = Time.now unless self.status == 'Complete'
      self.status = BatchStatus.find_by_name('Complete').name.to_s
    elsif jobs.size == hlsc_verified_jobs.size
      self.status = BatchStatus.find_by_name('HLSC Verified').to_s
    elsif jobs.size == hlsc_processing_jobs.size
      self.status = BatchStatus.find_by_name('HLSC Processing').name.to_s
    else
      if hlsc_rejected_jobs.size > 0
        if allocated_jobs.size > 0
          self.status = BatchStatus.find_by_name('Processing').name.to_s
          self.completion_time = nil
        else
          self.status = BatchStatus.find_by_name('HLSC Rejected').name.to_s
          self.completion_time = nil
        end
      else
        if jobs.size == complete_jobs.size + hlsc_verified_jobs.size
          self.completion_time = Time.now unless self.status == 'Complete'
          self.status = BatchStatus.find_by_name('Complete').name.to_s
        else
          self.status = BatchStatus.find_by_name('Processing').name.to_s
          self.completion_time = nil
        end
      end
    end

    self.save # Update the changes
  end

  # Class level method to update all the batch's status within 4 days
  def Batch.update_status
    Batch.find(:all, :conditions => "(To_days(now()) - To_days(completion_time)) <= 4").each do |batch|
      batch.update_status
    end
  end


  # Class level method to update all the batch's etc within 4 days
  def Batch.update_etc
    Batch.find(:all, :conditions => "status = 'Processing' and (To_days(now()) - To_days(completion_time)) <= 4").each do |batch|
      batch.get_etc
    end
  end

  def contracted_time(role=nil)
    if role == "HLSC"
      self.arrival_time + self.facility.client.contracted_tat.hours
    else
      self.arrival_time + self.facility.client.tat.hours
    end
  end

  def estimated_eobs
    Job.find(:all, :conditions => "batch_id = #{self.id}").inject(0) do |sum, job|
      sum + job.estimated_eob
    end
  end

  # Returns the number of check in complete status
  def complete_check_count
    check_number = []
    self.jobs.each do |job|
      if job.job_status =~ /Complete/
        check_number <<  job.check_number
      end
    end
    check_number.uniq!
    if check_number.nil?
      return 0
    else
      return check_number.size
    end
  end

  # Returns the total number of checks in the batch
  def total_check_count
    check_number = []
    self.jobs.each do |job|
      check_number << job.check_number
    end
    check_number.uniq!
    if check_number.nil?
      return 0
    else
      return check_number.size
    end
  end

  #Completed Batches list
  def self.completed_batches
    Batch.find(:all,
      :order => "status, comment desc, completion_time desc",
      :conditions => "(status = 'Complete' or status = 'HLSC Verified')
                                and (To_days(now()) - To_days(completion_time)) <= 4")
  end

  #Completed Payment Batches list
  def self.completed_batches_payment
    Batch.find(:all,
      :order => "status, comment desc, completion_time desc",
      :conditions => "(status = 'Complete' or status = 'HLSC Verified')
                                and (To_days(now()) - To_days(completion_time)) <= 4
                                and (correspondence = 0 or correspondence is null)")
  end

  #Uncompleted Batches list
  def self.uncompleted_batches
    Batch.find(:all,
      :include => :tat,
      :order => "arrival_time desc",
      :conditions => "status != 'Complete' and status != 'HLSC Verified'")
  end

  #Uncompleted Payment Batches list
  def self.uncompleted_batches_payment
    Batch.find(:all,
      :include => :tat,
      :order => "arrival_time desc",
      :conditions => "status != 'Complete' and status != 'HLSC Verified'
                              and (correspondence = 0 or correspondence is null)")
  end

  def least_eobs
    count_to_compare = self.jobs[0].count unless self.jobs[0].count.nil?
    self.jobs.each do |j|
      unless j.count.nil?
        if j.count < count_to_compare
          count_to_compare = j.count
        end
      else
        count_to_compare = 0
      end
    end
    return count_to_compare
  end

  # Filter wrappers
  def facility_for_filter
    self.facility.name
  end

  def client_for_filter
    self.facility.client.name
  end
  
  # protected
  # def validate
  #errors.add(:arrival_time, "must be within 6 hours window period from current time") if arrival_time.nil? || (arrival_time >= Time.now + 6.hours) || (arrival_time<=  Time.now - 6.hours)
  #end

end
