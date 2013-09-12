# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Admin::UserController < ApplicationController
  before_filter :validate_supervisor, :except => [:list_processor_occupancy, :list_members]
  layout 'standard'
    def index
    redirect_to :action => :list
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    # Filtering code below
    filter_field = params[:to_find]
    filter_field.strip! unless filter_field.nil?
    if filter_field.nil?
      users = User.find(:all, :conditions => "is_deleted = 0")
    else
      flash[:notice] = nil
      filter_by = params[:criteria]
      case filter_by
      when 'Name'
          users = User.find(:all, :conditions => "name like '%#{filter_field}%' and is_deleted = 0")
      when 'User ID'
          users = User.find(:all, :conditions => "userid like '%#{filter_field}%' and is_deleted = 0")
      when 'Status'
          users = User.find(:all, :conditions => "status like '%#{filter_field}%' and is_deleted = 0")
      when 'Role'
          users = User.find(:all, :conditions => "role like '%#{filter_field}%' and is_deleted = 0")
      when 'Remark'
          users = User.find(:all, :conditions => "remark like '%#{filter_field}%' and is_deleted = 0")
      end
      if users.size == 0
        flash[:notice] = "No user found for <i>'#{filter_by}'</i> as <i>'#{filter_field}'</i>"
      end
    end
    @user_pages, @users = paginate_collection users, :per_page => 30, :page => params[:page]

    # For AJAX requests, render the partial and disable the layout
    if request.xml_http_request?
      render :partial => "users_list", :layout => false
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @shifts = Shift.find_all.map {|s| s.name}
  end

  def create
    @user = User.new(params[:user])
    @user.shift = Shift.find_by_name(params[:shift])
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :controller => 'user',:action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @shifts = Shift.find_all.map {|s| s.name}
    @selected = @user.shift.name
    @password = @user.password
    @user.password = nil
    @page = params[:page]
  end

  def update
    password = params[:pass]
    user = User.find(params[:id])
    user.shift = Shift.find_by_name(params[:shift])    
    flag = 0
    
    previous_role = user.role  
    new_role = params[:user][:role]
    
    if new_role == previous_role      
      user.update_attributes(params[:user])    
    else      
        if user.role == 'Processor'
           count = Job.count(:conditions => "processor_id = #{params[:id]} and processor_status = 'Processor Allocated'")
        elsif user.role == 'QA'
           count = Job.count(:conditions => "qa_id = #{params[:id]} and qa_status = 'QA Allocated'")
        elsif user.role == 'Super QA'
           count = Job.count(:conditions => "sqa_id = #{params[:id]} and sqa_status = 'Processing'")
        end
        if count > 0  
        params[:user][:role] = previous_role
        user.update_attributes(params[:user]) 
        flag = 1         
        else
          user.update_attributes(params[:user])    
        end     
    end    
     
    if params[:user][:password] == '' or params[:user][:password] == nil
      user.password = password      
    else
      user.password = @user.pass_hash(params[:user][:password])
    end

    page = params[:page]
    if user.update
        if flag == 0
          flash[:notice] = 'User was successfully updated.'
        else
          flash[:notice] = 'Role could not be changed, User is having allocated jobs.'
        end
        redirect_to :action => 'list', :page => page
    else
      flash[:notice] = "Update failed."
      render :action => 'edit'
    end
    if @user.id == user.id
      session[:user] = user.id
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.userid == 'admin'
      flash[:notice] = 'Default admin cannot be deleted.'
    else
      user.destroy
    end
    redirect_to :action => 'list'
  end

  def delete_users
    users = params[:users_to_delete]
    users.delete_if do |key, value|
      value == "0"
    end
    @flag=0
    flash[:notice1] = ""
    flash[:notice] = ""
    users.keys.each do |id|
      if id == '1'
        @flag = 1
        flash[:notice1] = 'The default Admin user cannot be deleted.'
      else
        user = User.find(id)
        role = user.role
        jobs = user.jobs
        jobs.each do |j|
          if role == 'Processor'
            if j.processor_status == 'Processor Allocated'
              j.processor_status = ProcessorStatus['New'].to_s
              j.processor = nil
            end
          elsif role == 'QA'
            if j.qa_status == 'QA Allocated'
              j.qa_status = QaStatus['New'].to_s
              j.qa = nil
            end
          end
          if j.qa_status == 'New' and j.processor_status == 'New'
            j.job_status = JobStatus['New'].to_s
          elsif (j.processor_status == 'Processor Complete' or j.processor_status == 'Processor Incomplete') and j.qa_status == 'QA Complete'
            j.job_status = JobStatus['Complete'].to_s
          else
            j.job_status = JobStatus['Processing'].to_s
          end
          j.update
        end

        user.is_deleted = true
        user.userid = user.userid.to_s + '_deleted_' + Time.now.strftime('%m/%d/%y %H:%M').to_s
        user.session = nil
        user.status = "Offline"
        user.update

        if (@flag==1)
          flash[:notice] = "Deleted #{users.keys.size-1} user(s)."
        else
          flash[:notice] = "Deleted #{users.keys.size} user(s)."
        end
      end
    end
    if (@flag==1)
      if(flash[:notice]==nil)
      flash[:notice]=flash[:notice]+""+flash[:notice1]
      else
        if users.keys.size !=1
         flash[:notice]="Deleted #{users.keys.size-1} users.<BR>"+flash[:notice1]
        else
          flash[:notice]=flash[:notice1]
        end
      end
    end

   if users.keys.size == 0
    flash[:notice] = "Please select atleast one user to delete."
    end
   redirect_to :action => 'list'
  end

  def list_jobs
    @user = User.find(params[:id])
    @jobs = Job.find(:all, :conditions => "processor_id = #{@user.id}",
                            :joins => "left join batches on batch_id = batches.id" )

    if @jobs.size == 0
      flash[:notice] = "No job has been assigned to the processor!"
      redirect_to :action => 'list'
    end #if
  end

  # TODO: Rewrite this to drop the return_processors e xvb and use a single query if 
  # possible.
  def list_processor_occupancy
    time_minus_12_hrs = Time.now - 12.hours
    @users = User.find(:all,:conditions => ["jobs.processor_flag_time >= ? and
                                            jobs.processor_id = users.id and
                                            role = 'Processor' and status = 'Online'",time_minus_12_hrs],
                            :include => :processor_jobs,
                            :group => "jobs.processor_id")
    return_processors(@users, time_minus_12_hrs)
  end
  
  #shared method to be used by both online_processor_occupancy and list_members
  def return_processors(users, time)
    users.each do |user|
      user['allocated_jobs'] = Job.count(:conditions => ["processor_id = ? and processor_flag_time >= ?", user.id, time])
      
      user['completed_jobs'] = Job.count(:conditions => ["processor_id = ? and processor_flag_time >= ? and (processor_status = ? or processor_status = ?)", user.id, time, 'Processor Complete', 'Processor Incomplete'])
      
      user['completed_eobs'] = Job.sum(:count, :conditions => ["processor_id =? and processor_flag_time >= ? and (processor_status = ? or processor_status = ?)", user.id, time, 'Processor Complete', 'Processor Incomplete'])
    end    
  end
  
  def list_qa_occupancy
    time_minus_12_hrs = Time.now - 12.hours
   # @users = User.find(:all,:conditions => ["role = 'QA' and status = 'Online'"])                     
     @users = User.find(:all,:conditions => ["role = 'QA' and status = 'Online' and jobs.qa_id = users.id and jobs.qa_flag_time >= ?",time_minus_12_hrs],
                            :include => :qa_jobs,
                            :group => "jobs.qa_id")                       
    return_qa(@users, time_minus_12_hrs)
  end
  
  def return_qa(users, time)
    users.each do |user|
      user['allocated_jobs'] = Job.count(:conditions => ["qa_id = ? and qa_flag_time >= ?", user.id, time])
      
      user['completed_jobs'] = Job.count(:conditions => ["qa_id = ? and qa_flag_time >= ? and qa_status = ?", user.id, time, 'QA Complete'])      
      
    end    
  end
  
  #lists all members for a particular team leader
  def assign_members
    @tl = User.find(params[:id])
    all_processors = User.find(:all, :conditions => "role = 'Processor' and (teamleader_id != #{@tl.id} and teamleader_id not in (select id from users where role = 'TL') or teamleader_id is null)")
    @all_processors_pages, @all_processors = paginate_collection all_processors, :per_page => 2, :page => params[:page]
  end
  
  #allocates/assigns processors to a team leader
  def allocate_members
    @tl = User.find(params[:tl])
    selected_processors = params[:users_to_assign]
    selected_processors = selected_processors.delete_if {|k, v| v=="0"}
    selected_processors.each {|k, v| u = User.find(k); u.teamleader = @tl; u.update }
    redirect_to :action => 'assign_members', :id => @tl
  end
  
  #deallocates/removes members from team leader's team
  def remove_members
    @tl = User.find(params[:tl])
    selected_processors = params[:users_to_remove]
    selected_processors = selected_processors.delete_if {|k, v| v=="0"}
    selected_processors.each {|k, v| u = User.find(k); u.teamleader = nil; u.update }
    redirect_to :action => 'assign_members', :id => @tl
  end
  
  #lists all team members just like Online processor view
  def list_members
    time_minus_24_hrs = Time.now - 24.hours
    @members = @user.members.find(:all,:conditions => ["jobs.processor_flag_time >= ? and
                                            jobs.processor_id = users.id and
                                            role = 'Processor'",time_minus_24_hrs],
                            :include => :processor_jobs,
                            :group => "jobs.processor_id")
    return_processors(@members, time_minus_24_hrs)
  end
  
  #lists all processors for a given time range(default: current day)
  def processor_report
    from = params[:date_from].strip unless params[:date_from].nil?
    to = params[:date_to].strip unless params[:date_to].nil?
    
    #these are required to retain values in text fields
    @date_from = from
    @date_to = to
    @userid = params[:userid]
    
    if not from.blank?
      time_from = (from + " 00:00:00").to_time
      if not to.blank?
        time_to = (to + " 23:59:59").to_time
      else
        time_to = time_from + 1.days
      end
    elsif not to.blank?
      time_to = (to + " 23:59:59").to_time
      time_from = time_to - 1.days
    else
      time_to = Time.now
      time_from = time_to - 24.hours
    end
    users = filter_processor_report(params[:userid], time_from, time_to)
    @users_pages, @users = paginate_collection users, :per_page => 50, :page => params[:page]
  end
  
  #being used by processor report to get final list of users
  def filter_processor_report(user, time_from, time_to)
    user.blank? ? condition = "" : condition = " and users.userid like '%#{user}%'"
    users = User.find(:all,:conditions => ["jobs.processor_flag_time >= ? and
                                            jobs.processor_flag_time <= ? and
                                            jobs.processor_id = users.id and
                                            role = 'Processor'" + condition, time_from, time_to],
                            :include => :processor_jobs,
                            :group => "jobs.processor_id")
    users.each do |user|
      jobs = user.jobs
      completed_jobs = jobs.select do |j| 	 	 
        j.processor_flag_time >= time_from and j.processor_flag_time <= time_to and j.processor_status == 'Processor Complete' or j.processor_status == 'Processor Incomplete'
      end 
      user['completed_jobs'] = completed_jobs.size

      eob_count = 0
      completed_jobs.each do |j|
        eob_count = eob_count + j.count
      end
      user['completed_eobs'] = eob_count
    end
  end
  
  #lists all the facilities for a particular processor for a given time range
  def processor_facility_jobs
    unless params[:date_from].nil?
      @date_from = params[:date_from]
      @date_to = params[:date_to]
      time_from = (params[:date_from] + " 00:00:00").to_time
			#time_from = convert_to_est_time(time_from)
      time_to = (params[:date_to] + " 23:59:59").to_time
			#time_to = convert_to_est_time(time_to)
    else
      time_to = Time.now
      time_from = time_to - 1.days
      @date_from = Date.strptime(time_from.strftime("%m/%d/%y"), "%m/%d/%y")
      @date_to = Date.strptime(time_to.strftime("%m/%d/%y"), "%m/%d/%y")
			time_from = (@date_from.to_s + " 00:00:00").to_time
			time_to = (@date_to.to_s + " 23:59:59").to_time
    end
    
    user = User.find(params[:user])
    facility_id = params[:id].to_i unless params[:id].nil?
    @facility_jobs = user.facility_jobs(time_from, time_to)
    
    unless params[:id].nil?
      jobs = list_facility_jobs(time_from, time_to, facility_id, params[:user].to_i)
    else
      jobs = list_facility_jobs(time_from, time_to, @facility_jobs[0].id.to_i, params[:user].to_i)
    end
    @jobs_pages, @jobs = paginate_collection jobs, :per_page => 50, :page => params[:page]
  end
  
  def productivity_report
    unless params[:date_from].nil?
      @date_from = params[:date_from]
      @date_to = params[:date_to]
      time_from = (params[:date_from] + " 00:00:00").to_time
      time_to = (params[:date_to] + " 23:59:59").to_time
    else
      time_to = Time.now
      time_from = time_to - 1.days
      @date_from = time_from.strftime("%m/%d/%y")
      @date_to = time_to.strftime("%m/%d/%y")
			time_from = (@date_from.to_s + " 00:00:00").to_time
			time_to = (@date_to.to_s + " 23:59:59").to_time
    end
    
    @all_facilities = {}
    
    Facility.find(:all).each do |f|
      @all_facilities[f.name] = f.id
    end

    @all_facilities = @all_facilities.sort_by {|name, id| name}

    @selected_facilities = []
    facility_condition = ""
    unless params[:facilities].nil?
      @selected = params[:facilities]
      # TODO: Review this. I don't think it is producing the right output (HCR)
      @selected.each do |sf|
        @selected_facilities << sf.to_i
      end
      @selected = @selected.join(", ")
      facility_condition = " and facilities.id in (#{@selected})"
    end

    filter = Filter.new
    filter.multiple ['Complete', 'HLSC Verified'], 'batches.status'
    filter.multiple  @selected_facilities, 'facilities.id' unless @selected_facilities.empty?
    @userid = params[:userid] || ""
    userid_array = @userid.split(',').map {|s| s.strip}
    filter.multiple userid_array, 'users.userid' unless userid_array.empty?
    @batchid = params[:batchid] || ""
    batchid_array = @batchid.split(',').map {|s| s.strip}
    filter.multiple batchid_array, 'batches.batchid' unless batchid_array.empty?
    @payid = params[:payid] || ""
    payid_array = @payid.split(',').map {|s| s.strip}
    filter.multiple payid_array, 'payers.payid' unless payid_array.empty?
    
    filter.less time_to.to_s(:db), 'jobs.processor_flag_time'
    filter.great time_from.to_s(:db), 'jobs.processor_flag_time'
    
    logger.debug "Filter conditions: #{filter.conditions}"

    @jobs = Job.paginate(:all, :include => [{:batch => :facility}, :payer, :processor], :conditions => filter.conditions, :page => params[:page])
    
    logger.debug "Pressed #{params[:commit]}"
    
    if params[:commit] == "Export" then 
      if @jobs.empty? then
        flash[:notice] = "No productivity info to export"
      else
        e = Excel::Workbook.new
        jobs_array = Array.new
        jobs = Job.find(:all, :include => [{:batch => :facility}, :payer, :processor], :conditions => filter.conditions)
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
        
        # Cribbed from CSV examples. Not sure it is ideal.
        if request.env['HTTP_USER_AGENT'] =~ /msie/i
          headers['Pragma'] = 'public'
          headers['Content-Type'] = "application/vnd.ms-excel"
          headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
          headers['Content-Disposition'] = "attachment; filename=\"processor_productivity.xls\""
          headers['Expires'] = "0"
        else
          headers['Content-Type'] = "application/vnd.ms-excel"
          headers["Content-Disposition"] = "attachment; filename=\"processor_productivity.xls\""
        end

        render_text(e.build)
      end
    end
  end
  
  #being used by processor_facility_jobs to get list of jobs for a particular
  #user and facility
  def list_facility_jobs(time_from, time_to, id, user_id)
    time_from = time_from.strftime("%Y-%m-%d %H:%M:%S")
    time_to = time_to.strftime("%Y-%m-%d %H:%M:%S")
    jobs = []
    Facility.find(id).batches.each do |b|
      found_jobs = b.jobs.find(:all,
                        :conditions => "processor_flag_time >= '#{time_from}' " +
                                       "and processor_flag_time <= '#{time_to}' " +
                                       "and processor_id = #{user_id}")
      found_jobs.each {|j| jobs << j}
    end
    return jobs
  end
  
  def assign_clients
    @processor = User.find(params[:id])
    @all_clients = Client.find(:all) - @processor.clients
  end
  
  #allocates/assigns clients to a processor
  def allocate_clients
    processor = User.find(params[:processor])
    selected_clients = params[:clients_to_assign]
    selected_clients = selected_clients.delete_if {|k, v| v=="0"}
    selected_clients.each {|k, v|
      c = Client.find(k)
      user_client = UserClientJobHistory.create!(:user => processor, :client => c)
    }
    redirect_to :action => 'assign_clients', :id => processor
  end
  
  def remove_clients
    processor = User.find(params[:processor])
    selected_clients = params[:clients_to_remove]
    selected_clients = selected_clients.delete_if {|k, v| v=="0"}
    selected_clients.each {|k, v|
      UserClientJobHistory.find_by_user_id_and_client_id(processor.id, k).destroy
      }
    redirect_to :action => 'assign_clients', :id => processor    
  end
  
  def paginate_collection(collection, options = {})
    default_options = {:per_page => 30, :page => 1}
    options = default_options.merge options
    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end
  # Listing Productivity Report of RevClaim
  def joblist
    @user1=[]
    puts params[:criteria]
    puts params[:time_difference]
    if ((params[:date_from].blank?) and (params[:date_to].blank?))
      @user=Job.find(:all,:conditions=>"users.is_deleted!=1 and processor_status IN ('Processor Complete','Processor Incomplete') and time_taken is not null",:select=>"processor_id processor_id,sum(count) count,((sum(time_taken)/60)/sum(count)) time ",:group=>"processor_id",:order=>"time",:joins=>"inner join users on users.id=jobs.processor_id")
@user.each do|p|
   p['processor_id']= p.processor_id
   p['count']= p.count
   p['time'] = p.time
   p['totalcount'] = EobQa.count(:all,:conditions=>"processor_id=#{p.processor_id}")
   p['incorrect'] = EobQa.count(:all,:conditions=>"processor_id=#{p.processor_id} and total_incorrect_fields>0")
    @user1 << p
 end
    else if ((params[:date_from].blank?) and (not params[:date_to].blank?))
        flash[:notice] = "From Date Mandatory"
        @user='nil'
        @batch_pages, @users = paginate_collection @user , :per_page => 30 ,:page => params[:page]
        redirect_to :controller=>'user',:action => 'joblist'
      else if ((not params[:date_from].blank?) and (params[:date_to].blank?))
          flash[:notice] = "To Date Mandatory"
          @user='nil'
          @batch_pages, @users = paginate_collection @user , :per_page => 30 ,:page => params[:page]
          redirect_to :controller=>'user',:action => 'joblist'
        else if ((not params[:date_from].blank?) and (not params[:date_to].blank?))
            time_from = (params[:date_from] + " 00:00:00").to_time
            session[:fromtime]= time_from 
            time_to = (params[:date_to] + " 23:59:59").to_time
             time_to1 = (params[:date_to] + " 00:00:00").to_time
             session[:totime]= time_to1
           #For EST to IST conversion minus 10h and 30 min from from date and to_date
            if(params[:criteria]=='IST')
                @user=Job.find(:all,:conditions=>"processor_status IN ('Processor Complete','Processor Incomplete','Complete') and processor_flag_time>=TIMESTAMPADD(hour,-#{params[:time_difference]},'#{time_from.to_date}') and processor_flag_time<TIMESTAMPADD(hour,-#{params[:time_difference]},'#{(time_to + 1.days).to_date}') and time_taken is not null",:select=>"processor_id processor_id,sum(count) count,((sum(time_taken)/60)/(sum(count))) time",:group=>"processor_id",:order=>"time")
            else
                @user=Job.find(:all,:conditions=>"processor_status IN ('Processor Complete','Processor Incomplete','Complete') and processor_flag_time>='#{time_from.to_date}' and processor_flag_time<'#{(time_to + 1.days).to_date}' and time_taken is not null",:select=>"processor_id processor_id,sum(count) count,((sum(time_taken)/60)/(sum(count))) time",:group=>"processor_id",:order=>"time")
            end
            @user.each do|p|
              p['processor_id']= p.processor_id
              p['count']= p.count
              p['time'] = p.time
              p['totalcount'] = EobQa.count(:all,:conditions=>"processor_id=#{p.processor_id} and time_of_rejection>='#{time_from.to_date}' and time_of_rejection<='#{(time_to+1.days).to_date}'")
              p['incorrect'] = EobQa.count(:all,:conditions=>"processor_id=#{p.processor_id} and total_incorrect_fields>0 and time_of_rejection>='#{time_from.to_date}' and time_of_rejection<'#{(time_to+1.days).to_date}'")
              @user1 << p
            end
          end
          
        end
      end
    end
    @batch_pages, @users = paginate_collection @user1 , :per_page => 30 ,:page => params[:page]
  end

#accuracy Report

def accuracy_report
  
  
  @procid=params[:procid]
  if ((session[:fromtime].blank?) and  (session[:totime].blank?))
    @p=[]
    
    @first = Job.find(:all,:conditions=>"processor_status IN ('Processor Complete','Processor Incomplete') and processor_id=#{params[:procid]}",:select=>" min(processor_flag_time) processor_flag_time")
    @last = Job.find(:all,:conditions=>"processor_status IN ('Processor Complete','Processor Incomplete') and processor_id=#{params[:procid]}",:select=>" max(processor_flag_time) processor_flag_time1")
    
    @first.each do |p|
      @firsttime= p.processor_flag_time.to_time
      @firsttime1= p.processor_flag_time.to_time
    end
    @last.each do |p|
      @lasttime= p.processor_flag_time1.to_time
      
    end
    while(@firsttime < @lasttime)
      
      time =Job.find(:all,:conditions=>"processor_status IN ('Processor Complete','Processor Incomplete') and processor_id=#{params[:procid]} and processor_flag_time>='#{@firsttime.to_date}' and processor_flag_time<='#{(@firsttime+7.days).to_date}' and time_taken is not null",:select=>"((sum(time_taken)/60)/(sum(count))) time,processor_flag_time",:group=>"processor_id")
      @p<<time
      @firsttime = @firsttime + 7.days
      
      
    end
    else
      @p=[]
    
#    @first = Job.find(:all,:conditions=>"processor_status='Processor Complete' and processor_id=#{params[:procid]}",:select=>" min(processor_flag_time) processor_flag_time")
#    @last = Job.find(:all,:conditions=>"processor_status='Processor Complete' and processor_id=#{params[:procid]}",:select=>" max(processor_flag_time) processor_flag_time1")
    
#    @first.each do |p|
      @firsttime= session[:fromtime].to_time
      @firsttime1= session[:fromtime].to_time
#    end
#    @last.each do |p|
#      @lasttime= p.processor_flag_time1.to_time
#      
#    end

    while(@firsttime.to_date < session[:totime].to_date)
      puts @firsttime.to_date
      time =Job.find(:all,:conditions=>"processor_status IN ('Processor Complete','Processor Incomplete') and processor_id=#{params[:procid]} and processor_flag_time>='#{@firsttime.to_date}' and processor_flag_time<'#{(@firsttime+7.days).to_date}' and time_taken is not null ",:select=>"((sum(time_taken)/60)/(sum(count))) time,processor_flag_time",:group=>"processor_id")
      @p<<time
      @firsttime = (@firsttime + 7.days)
      
      
    end
    end
    session[:fromtime]=nil
    session[:totime] =nil 
  end

end
