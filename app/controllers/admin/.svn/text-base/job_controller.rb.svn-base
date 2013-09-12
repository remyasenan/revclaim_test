  # Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Admin::JobController < ApplicationController


  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  require_role ["admin","Processor","QA","Supervisor"]
 # in_place_edit_for :job, :processor_comment

  #  before_filter :validate_supervisor, :except => :user_jobs

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#    :redirect_to => { :controller => 'batch', :action => :list }

  def list
    @job_pages, @jobs = paginate :jobs, :per_page => 30, :order_by => 'batch_id desc, job_status'
  end

  def show
    @job = Job.find(params[:id])
  end
    
  def new
    @batch = Batch.find(params[:id])
    @job = Job.new
    @statuses = Status.find(:all).map do |status|
      status.value
    end
    session[:batch] = @batch.id
  end

  def create
    @job = Job.new(params[:job])
    @job.batch = Batch.find(session[:batch])
    @job.job_status = JobStatus['New'].to_s
    if @job.save
      flash[:notice] = 'Job was successfully created.'
      redirect_to :controller => 'batch',:action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def split
    @job = Job.find(params[:id])
    @from = params[:from]
  end

  def split_update
    job = Job.find(params[:id])
    new_job = Job.new
    new_job.check_number = job.check_number
    new_job.batch = job.batch
    new_job.payer = job.payer
    new_job.update
    if new_job.update_attributes(params[:new_job])
      flash[:notice] = 'Claim was successfully updated.'
    else
      flash[:notice] = 'Job update failed.'
    end
    redirect_to :controller => "/admin/batch", :action => "add_job", :id => new_job.batch, :from => params[:from], :payer => params[:payer]
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:notice] = 'Job was successfully updated.'
      redirect_to :controller => 'batch', :action => 'add_job', :id => @job.batch
    else
      render :action => 'edit'
    end
  end

  def edit_payer
    @job = Job.find(params[:id])
  end

  def destroy
    Job.find(params[:id]).destroy
    redirect_to :controller => 'batch', :action => 'add_job'
  end

  def allocate
    @flag=0
    search_field = params[:job][:to_find] rescue nil
    compare = params[:job][:compare] rescue nil
    criteria = params[:job][:criteria] rescue nil

    search_field.strip! unless search_field.nil?

    if not search_field.blank?
      filter(criteria, compare, search_field)
    else
      @jobs = Job.where("batch_id =#{params[:id]}").order('page_count').reverse_order
    end
  end

  # Function for adding and removing auto allocation in a batch level
  def add_auto_allocation
    @auto_allocation_activate = Batch.where("id = #{params[:id]}").first.update_attribute(:auto_allocation_status,"ACTIVATE");
    redirect_to :controller => "admin/batch", :action => "allocate", :page => params[:page]
  end

  def remove_auto_allocation
    @auto_allocation_deactivate = Batch.where("id = #{params[:id]}").first.update_attribute(:auto_allocation_status,"DEACTIVATE")
    redirect_to :controller => "admin/batch", :action => "allocate", :page => params[:page]
  end

  def filter_jobs(field, comp, search, condition)
    order = "payers.payer"
    @job_batchid = params[:jobs]
    condition == "" ? condition = condition << " and batch_id = '#{@job_batchid}'" : condition = condition
    case field
    when 'Check Number'
      @jobs = Job.find(:all, :conditions => "check_number #{comp} '#{search}' " + condition,
        :include => :payer,
        :order => order)
    when 'Tiff Number'
      @jobs = Job.find(:all, :conditions => "tiff_number #{comp} '#{search}' " + condition,
        :include => :payer,
        :order => order)
    when 'Count'
      temp_search = search
      search = search.to_i
      @jobs = Job.find(:all, :conditions => "count #{comp} #{search} " + condition,
        :include => :payer,
        :order => order)
      search = temp_search
    when 'Processor'
      @jobs = Job.find(:all, :conditions => "users.name like '%#{search}%' " + condition,
        :joins => "left join users on processor_id = users.id",
        :include => :payer,
        :order => order)
    when 'QA'
      @jobs = Job.find(:all, :conditions => "users.name like '%#{search}%' " + condition,
        :joins => "left join users on qa_id = users.id",
        :include => :payer,
        :order => order)
    when 'Status'
      @jobs = Job.find(:all, :conditions => "job_status like '%#{search}%' " + condition,
        :include => :payer,
        :order => order)
    end
    if @jobs.size == 0
      flash[:notice] = "Search for #{search} did not return any results. Try another keyword!"
      redirect_to :action => 'allocate'
    end
  end

  def allocate_users
    @batch_pages, @batches = paginate :batches, :per_page => 30
    @job_pages, @jobs = paginate :jobs, :per_page => 30, :order_by => 'batch_id desc, status'
  end

  def allocate_deallocate

    count1 =0
    count =0
    all_jobs = params[:jobs_to_allocate]
    user = params[:user]
    all_jobs.delete_if do |key,value|
      value == "0"
    end
    @jobs = []
    all_jobs.keys.each do |id|
      @jobs << Job.find_by_id(id)
    end
    if @jobs.empty?
      flash[:notice] = 'Select atleast one Job to Allocate/Deallocate.'
      if params[:from] == 'payer'
        redirect_to :action => 'allocate_payer_jobs', :payer => params[:payer]
      elsif params[:from] == 'user'
				redirect_to :action => 'user_jobs', :payer => params[:payer], :user => params[:jobs_of_user]
			else
        redirect_to :action => 'allocate', :id => params[:batchid], :page=>params[:page], :back_page => params[:back_page]
      end
    elsif params[:option1] == 'Allocate QA'
      all_jobs.keys.each do |id|
        @jobs1 = Job.find(id)
        if (@jobs1.job_status=="Complete")
          count1 = count1 + 1
        end
      end
      
      redirect_to :action => 'add_qa', :jobs => @jobs, :payer => params[:payer], :from => params[:from], :jobs_of_user => params[:jobs_of_user]
     
    elsif params[:option1] == 'Allocate Processor'
      all_jobs.keys.each do |id|
        @jobs1 = Job.find(id)
        if (@jobs1.job_status=="Complete")
          count = count + 1
        end
      end
      if count>0
        flash[:notice] = 'Processor Completed Job cannot allocate again'
        redirect_to :action => 'allocate', :id => @jobs1.batch_id
      else
        redirect_to :action => 'add_processor', :jobs => @jobs, :payer => params[:payer], :from => params[:from]
      end
         
    elsif params[:option1] == 'Deallocate Processor'

      redirect_to :action => 'deallocate_processor', :jobs => @jobs, :payer => params[:payer], :from => params[:from]
    else
      redirect_to :action => 'deallocate_qa', :jobs => @jobs, :payer => params[:payer], :from => params[:from], :jobs_of_user => params[:jobs_of_user]
    end
  end


  def add_processor
    relation_include = [ {:remittors_roles => :role}]
    user = Remittor.find(:all,:conditions => "roles.name = 'Processor' and status = 'Online'",
      :include => relation_include)
#      user.each do |user_remark|
#      user_remark.set_remark(user_remark.id)
#      end
    @flag=2
    @jobs = params[:jobs]
    session[:job] = params[:jobs]
    job = Job.find(@jobs[0])
    if not job.payer_id.nil?
      @payer = Payer.find(job.payer_id)
    end
    @users = Remittor.find(:all,:conditions => "roles.name = 'Processor' and status = 'Online'",
      :include => relation_include)
    unless !@users.blank? 
      @users.each do |user|
        user.set_remark
      end
      @users= @users.sort_by {|user| user.allocated_jobs_proc.size}
    end
  end
  
  def add_qa

    @user= current_remittor
    @rol=@user.roles
    @jobs = params[:jobs]
    job = Job.find(@jobs[0])
    if not job.payer_id.nil?
      @payer = Payer.find(job.payer_id)
    end
    relation_include = [ {:remittors_roles => :role}]

    if @rol[0].name =='admin' or  @rol[0].name =='Supervisor'

      @users = Remittor.find(:all,:conditions => "roles.name = 'QA' and status = 'Online'",
        :include => relation_include)
      
      unless !@users.blank?      
        @users.each do |user|
          user.set_remark
        end
        @users= @users.sort_by {|user| user.allocated_jobs_qa.size} 
      end
    end
  end

  def assign
    @flag = 1
    id_user = params[:user]
    @user = Remittor.find(:first, :conditions => {:id => id_user})
    @role = @user.remittors_roles.first.role.name
    @jobs = Job.find(params[:jobs])
    batch_id = @jobs[0].batch.id
    
    @jobs.each do |job|
      if @role == 'Processor'
        job.processor_status = ProcessorStatus.find_by_name('Processor Allocated').name.to_s
        job.job_status = JobStatus.find_by_name('Processing').name.to_s
        job.processor_id = id_user
        job.processor_flag_time = Time.now
        job.save

        # Updating the batch status
        batch = Batch.find(job.batch_id)
        batch.update_status
      elsif @role == 'QA'
        job.qa_status = QaStatus.find_by_name('QA Allocated').name.to_s
        job.job_status = JobStatus.find_by_name('Processing').name.to_s
        job.qa_id = id_user
        job.qa_flag_time = Time.now
        job.comment_for_qa = params[:qa][:comment]
        job.save
        
        # Updating the batch status
        batch = Batch.find(job.batch_id)
        batch.update_status
      end
    end
    
    # Updating user remark 
    @user.set_remark
    
    # TODO: EOB processing rate is hardcoded here
    # Give an option for the supervisor to edit it
    batch = @jobs[0].batch
    batch.get_etc
    redirect_to :action => 'allocate', :id =>  batch_id
  end

  def filter(criteria_to_search,compare,to_search_for)
    @job_batchid = params[:id]
    case criteria_to_search 
    when 'Count'
      if compare == '='
        @jobs = Job.find(:all, :conditions => "count = '#{to_search_for}' " +
            "and batch_id = '#{@job_batchid}'")
      elsif compare == '>='
        @jobs = Job.find(:all, :conditions => "count >= '#{to_search_for}' " +
            "and batch_id = '#{@job_batchid}'")
      else
        @jobs = Job.find(:all, :conditions => "count <= '#{to_search_for}' " +
            "and batch_id = '#{@job_batchid}'")
      end
    when 'Processor'
      @jobs = Job.find(:all, :conditions => "remittors.name like '%#{to_search_for}%' " +
          "and batch_id = '#{@job_batchid}'",
        :joins => "left join remittors on processor_id = remittors.id")
    when 'QA'
      @jobs = Job.find(:all, :conditions => "remittors.name like '%#{to_search_for}%' " +
          "and batch_id = '#{@job_batchid}'",
        :joins => "left join remittors on qa_id = remittors.id")
    when 'Status'
      @jobs = Job.find(:all, :conditions => "job_status like '%#{to_search_for}%' " +
          "and batch_id = '#{@job_batchid}'")
    end
    if @jobs.size == 0
      flash[:notice] = "Search for #{to_search_for} did not return any results. Try another keyword!"
      redirect_to :action => 'allocate'
    end
  end

  def deallocate_processor
    @jobs = Job.find(params[:jobs])
    processor = Remittor.find(:first, :conditions => ["id = ?", @jobs[0].processor_id])
    batch_id = @jobs[0].batch.id
    
    @jobs.each do |job|
      job.processor = nil
      job.processor_status = ProcessorStatus.find_by_name('New').name.to_s
      if job.qa_status == 'New'
        job.job_status = JobStatus.find_by_name('New').name.to_s
      end
      job.save
      job.batch.get_etc
    end
  
    # TODO: EOB processing rate is hardcoded here
    # Give an option for the supervisor to edit it
    batch = @jobs[0].batch
    batch.get_etc
    batch.update_status
    
    #redirect_to :action => 'allocate',:back_page=>params[:back_page]
    if params[:from] == 'payer'
      redirect_to :action => 'allocate_payer_jobs', :payer => params[:payer]
    else
      batch = @jobs[0].batch
   
      batch.get_etc
      redirect_to :action => 'allocate', :id => batch_id
    end
    
    #Setting processor remark as "Free" or "Occupied"
    processor.set_remark rescue nil
  end

  def deallocate_qa
    @jobs = Job.find(params[:jobs])
    qa = Remittor.find(:first, :conditions => ["id = ?", @jobs[0].qa_id])
    batch_id = @jobs[0].batch.id
    @jobs.each do |job|
      job.qa = nil
      job.qa_status = QaStatus.find_by_name('New').name.to_s
      job.job_status = JobStatus.find_by_name('Complete').name.to_s
      if job.processor_status == 'New'
        job.job_status = JobStatus.find_by_name('New').name.to_s
      elsif job.processor_status == 'Processor Allocated'
        job.job_status = JobStatus.find_by_name('Processing').name.to_s
        elsif job.processor_status == 'Processor Complete' 
        job.job_status = JobStatus.find_by_name('Complete').name.to_s
        elsif job.processor_status == 'Processor Incomplete'
        job.job_status = JobStatus.find_by_name('Incomplete').name.to_s
      end
      job.save
      job.batch.get_etc
    end
    
    #Set qa remark as free or occupied
    qa.set_remark rescue nil
    
    # TODO: EOB processing rate is hardcoded here
    # Give an option for the supervisor to edit it
    batch = @jobs[0].batch
    batch.get_etc
    batch.update_status
    #redirect_to :action => 'allocate' ,:back_page=>params[:back_page]
    if params[:from] == 'payer'
      redirect_to :action => 'allocate_payer_jobs', :payer => params[:payer]
    elsif params[:from] == 'user' 
			redirect_to :action => 'user_jobs', :payer => params[:payer], :user => params[:jobs_of_user]
		else
      redirect_to :action => 'allocate', :id => batch_id
    end
  end

  #Allocate jobs for a particular payer, same as job allocation but for a particular payer
  def allocate_payer_jobs
    @user= current_remittor
    @role=@user.roles
    @payer = Payer.find(params[:payer])
    @jobs = Job.paginate(:conditions => "payer_id = #{@payer.id}",:page => params[:page], :per_page =>20)
     #jobs = Job.find(:all, :conditions => "jobs.payer_id = #{@payer.id} and batches.status not in ('Complete', 'HLSC Verified')",
     # :include => :batch)
 
    #jobs = jobs.sort_by {|j| j.batch.contracted_time(@role[0].name)}
    
  end

	#Display jobs of particular user
	def user_jobs
    @selected_user = Remittor.find(params[:user])
		jobs = filter_user_jobs(params[:user], params[:hours])
    @jobs =Job.paginate(:page => params[:page], :per_page =>10)

	end
	
	def filter_user_jobs(user, hrs)
    @user_selected = Remittor.find(user)
		time_interval = Time.now - hrs.to_i.hours
 		jobs = Job.find(:all, :conditions => ["processor_id = ? and processor_status != 'New' and processor_flag_time >= ?", @user_selected.id, time_interval])
	end
	
  def qa_jobs
    @selected_user = User.find(params[:user])
    jobs = filter_qa_jobs(params[:user], params[:hours])
    #jobs = Job.find(:all, :conditions => ["qa_id = ? and qa_status != 'New'", @selected_user.id])
    @jobs =Job.paginate(:all, :page => params[:page], :per_page =>10)
  
  end
  
  def filter_qa_jobs(user, hrs)
    @user_selected = User.find(user)
    time_interval = Time.now - hrs.to_i.hours
    jobs = Job.find(:all, :conditions => ["qa_id = ? and qa_status != 'New' and qa_flag_time >= ?", @user_selected.id, time_interval])
  end
  
    
  def qa_completed
    time_interval = Time.now - 7.days
    jobs = Job.find(:all, :conditions => [ "work_queue = 0 and qa_status = 'QA Complete' and sqa_status = 'New' and qa_flag_time >=?", time_interval], :order => "qa_flag_time")
      
    @job_pages, @jobs = paginate_collection jobs, :per_page => 30, :page => params[:page]
    @count=Job.count(:conditions => "work_queue = 1 and sqa_status != 'Complete'")
       
  end
     
  def work_list
      
    if params[:option1] == 'Add to Work Queue'
      all_jobs = params[:jobs_to_allocate]
      all_jobs.delete_if do |key,value|
        value == "0"
      end
      #@jobs = []
      all_jobs.keys.each do |id|
        @jobs = Job.find_by_id(id)
            
        @jobs.work_queue = 1
        @jobs.work_queue_flagtime = Time.now
        @jobs.update
      end
          
      if all_jobs.keys.size > 0
        flash[:notice] = 'Job(s) successfully added to Work Queue'
      else
        flash[:notice] = 'Select atleast one'
      end
          
      redirect_to :action => 'qa_completed'
      
    elsif  params[:option1] == 'Remove from Work Queue'
      all_jobs = params[:jobs_to_allocate]
      all_jobs.delete_if do |key,value|
        value == "0"
      end
      @jobs = []
      all_jobs.keys.each do |id|
        @jobs = Job.find_by_id(id)
          
        if all_jobs.keys.size > 0
          flash[:notice] = 'Job(s) successfully removed from Work Queue'
        else
          flash[:notice] = 'Select atleast one'
        end
      end
      redirect_to :action => 'qa_completed'
    end
  end

  def work_queue
    jobs = Job.find(:all, :conditions => [ "work_queue = 1 and sqa_status != 'Complete'"], :order => "work_queue_flagtime")
       
    @job_pages, @jobs = paginate_collection jobs, :per_page => 30, :page => params[:page]
  end
     
  def remove   
    all_jobs = params[:jobs_to_allocate]
    all_jobs.delete_if do |key, value|
      value == "0"
    end
    all_jobs.keys.each do |id|
      @jobs = Job.find_by_id(id)
       
      unless @jobs.sqa_status == 'Processing'
        @jobs.work_queue = 0
        @jobs.update
        @flag = 1
      else
        @flag = 0
      end
     
    end
    if all_jobs.keys.size > 0
        
      if @flag == 1
        flash[:notice] = 'Job(s) successfully removed from Work Queue'
      else
        flash[:notice] = 'Cannot Remove Processing Job(s)'
      end
             
    else
      flash[:notice] = 'Select atleast one'
    end
    redirect_to :action => 'work_queue'
  end   
  
  def set_job_processor_comment

    @jobs = Job.find_by_id(params[:id])
    @jobs.update_attributes(:processor_comments=>params[:job][:processor_comments])
    @jobs.save  
    value = params[:value].blank? ? "no comments" : params[:value]
    respond_to do |format|
    if @jobs.update_attributes(:processor_comments=>params[:job][:processor_comments])
      format.html { redirect_to(@jobs, :notice => 'User was successfully updated.') }
      format.json { respond_with_bip(@jobs) }
    else
      format.html { render :action => "edit" }
      format.json { respond_with_bip(@jobs) }
    end
  end
  end
end