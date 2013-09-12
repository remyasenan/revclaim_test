require 'digest/sha1'
class Remittor < ActiveRecord::Base
  
 # has_many :roles, :through => :remittors_roles
 # has_many :remittors_roles
  #cattr_accessor :current_remittor
  has_and_belongs_to_many :roles
  has_many :remittors_roles
  has_and_belongs_to_many :role_types, :class_name => "Role", :join_table => "remittors_roles"
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
  has_many :clients
  has_many :user_client_job_histories
  has_many :clients, :through => :user_client_job_histories
  
    
  attr_protected :roles
  attr_accessor :password

  validates  :login, :presence => true
  validates  :password,:presence => true,:if => :password_required?
  validates  :password_confirmation,:presence => true,:if => :password_required?
  validates  :password,:length =>{ :within => 4..40}, :if => :password_required?
  validates  :password,:confirmation => true,:if => :password_required?
  validates  :login,  :length => { :within => 3..40}
 # validates_length_of       :email,    :within => 3..100
  validates  :login,:uniqueness => true,:on => :create
  before_save :encrypt_password

  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end
  # ---------------------------------------
  def jobs

    if self.roles.collect(&:name)== 'Processor'
      j=[]
      j=Job.find(:all,:conditions=>{:processor_id=> self.id})
      return j
    else
      self.qa_jobs
    end
  end
  
  # This method finds out the total no: of allocated jobs of processor
  def allocated_jobs_proc
    total_no_of_jobs_proc = Job.find(:all, :conditions => {:processor_id => self.id,
                          :processor_status => "Processor Allocated"})
    return total_no_of_jobs_proc
  end
  
 # This method finds out the total no: of allocated jobs of processor
  def allocated_jobs_qa
    total_no_of_jobs_qa = Job.find(:all, :conditions => ["qa_id = ? and qa_status = ?", 
                         self.id, "QA Allocated"])
    return total_no_of_jobs_qa
  end 
  
#This method is used for setting user remark as "Free" or "Occupied".  
def set_remark
  role = self.remittors_roles.first.role.name 
  if role == "Processor"
    total_jobs_proc = Job.find(:all, :conditions => ["processor_id = ?", id]).size
    completed_jobs_by_proc = Job.find(:all, :conditions => ["processor_id = ? and (processor_status = ? or processor_status = ?)",
                            id, "Processor Complete", "Processor Incomplete"]).size                     # Need to check the status
                 
    if total_jobs_proc == completed_jobs_by_proc
       self.remark = "Free"
    else
       self.remark = "Occupied"
    end
  elsif role == "QA"
     total_jobs_qa = Job.find(:all, :conditions => ["qa_id = ?", id]).size
     completed_jobs_by_qa = Job.find(:all, :conditions => ["qa_id = ? and qa_status = ?", 
                     id, "QA Complete"]).size
     incompleted_jobs_by_qa = Job.find(:all, :conditions => ["qa_id = ? and qa_status = ?", 
                     id, "QA Incomplete"]).size
     rejected_jobs = Job.find(:all, :conditions => ["qa_id = ? and qa_status = ?", 
                     id, "QA Rejected"]).size            
     processed_jobs_by_qa = completed_jobs_by_qa + incompleted_jobs_by_qa + rejected_jobs 
    
    if  total_jobs_qa != 0            
      if total_jobs_qa == processed_jobs_by_qa
        self.remark = "Free"
      else
        self.remark = "Occupied"
      end
    end
  end 
  self.save
end

  
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  #attr_accessible :login, :email, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  def pass_hash(password)
    Digest::SHA1.hexdigest(password)
  end


  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end


   def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  #Calculating the eob's completed by processor in the last 12 hrs
  def completed_jobs
    count = 0
    time_minus_12_hrs = Time.now - 12.hours
    self.processor_jobs.find(:all, :conditions => ["processor_flag_time >= ? and job_status = ?", time_minus_12_hrs, "Complete"]).each do |job|
      if !job.count.blank? and job.processor_flag_time >= time_minus_12_hrs
        count = count + job.count
      end
    end
    return count
  end

  #Calculating the eob's completed by QA in the last 12 hours
  def completed_jobs_by_qa
    count = 0
    time_minus_12_hrs = Time.now - 12.hours
    report = EobReport.find_all_by_qa(self.login)
    report.each do |e|
      if e.verify_time >= time_minus_12_hrs
        count = count + 1
      end
    end
    return count
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end

  private
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end
  
end
    
    

