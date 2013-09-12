class Admin::RemittorsController < ApplicationController

require "will_paginate/array"
  include AuthenticatedSystem
  include RoleRequirementSystem
  require_role ["admin","QA","Supervisor"]

  layout 'standard'
  #auto_complete_for :remittor, :login
  def index

    redirect_to :action => "list"
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)


  def new
    @remittor = Remittor.new
    @remittors_role =RemittorsRole.new
      @shifts = Shift.find(:all).map {|s| s.name}
      @roles = Role.find(:all).map {|r| r.name}
      @facilities = Facility.find(:all).map {|f| f.name}
  end
 
  def create

    @remittor =  Remittor.new(params[:remittor])
    @remittor.status = "Offline"
   if @remittor.save
    @remittor.is_deleted=0
    @remittor.eob_accuracy=100
    @remittor.field_accuracy=100
    @remittor.processing_rate_others=8
    @remittor.processing_rate_triad=5
    @remittor.total_fields=0
    @remittor.total_incorrect_fields=0
    @remittor.eob_qa_checked=0

    shift = Shift.find_by_name(params[:shift])
    @remittor.update_attributes(:shift_id =>shift.id)
    @roles  =  params[:role][:id] unless params[:role].blank?
   
      if @roles && @remittor
        @roles.each do|role|
          role = Role.find_by_name(role)
          @remittor.remittors_roles.create(:role_id => role.id)
        end

        flash[:notice] = 'User was successfully created.'
        redirect_to :controller => 'remittors',:action => 'list'
      else
        flash[:notice]  = "UserID and Password should be min 6 characters long, Email should be in correct format"
        redirect_to :controller => 'remittors',:action => 'new'
      end
    else
      @shifts = Shift.find(:all).map {|s| s.name}
      @roles = Role.find(:all).map {|r| r.name}
      @facilities = Facility.find(:all).map {|f| f.name}
        flash[:notice] = 'User is already created.'
        render :action => 'new'
    end

  end

  def list

   
    @rol=@user.roles
    roles= @rol[0].name
    @remittors1 =Remittor.paginate(:page => params[:page], :per_page =>30, :order=>"created_at DESC")

    relation_include = [ {:remittors_roles => :role}]
   
    # Filtering code below
    filter_field = params[:to_find]
    filter_field.strip! unless filter_field.nil?
    if filter_field.nil?
      @remittors = Remittor.paginate(:conditions => " remittors.is_deleted = 0", :include => relation_include,:page => params[:page], :per_page =>30)
    
    else
      flash[:notice] = nil
      filter_by = params[:criteria]
      case filter_by
      when 'Name'
        @remittors = Remittor.paginate(:conditions => "remittors.login like '%#{filter_field}%' and  remittors.is_deleted = 0", :include => relation_include,:page => params[:page], :per_page =>3)

      when 'User ID'
        @remittors = Remittor.paginate(:conditions => "remittors.login like '%#{filter_field}%' and  remittors.is_deleted = 0", :include => relation_include,:page => params[:page], :per_page =>3)

      when 'Status'
        @remittors = Remittor.paginate(:conditions => "remittors.status like '%#{filter_field}%' and  remittors.is_deleted = 0", :include => relation_include,:page => params[:page], :per_page =>3)

      when 'Role'

        @remittors=[]
        @role = Role.find(:first,:conditions=>["name like ?","%#{filter_field}%"])
        @rem_roles=[]

        @rem_roles<<RemittorsRole.find(:conditions=>["role_id=?",@role.id])
        @rem_roles.each do |t|
          @remittors = Remittor.paginate(:conditions => "remittors.id='#{t[0].remittor_id}' and  remittors.is_deleted = 0", :include => relation_include,:page => params[:page], :per_page =>30)
        end
      when 'Remark'
        @remittors = Remittor.paginate(:conditions => "remittors.remark like '%#{filter_field}%' and remittors.is_deleted = 0", :include => relation_include,:page => params[:page], :per_page =>30)
      end
      if (@remittors==nil)
        flash[:notice] = "No remittors found for <i>'#{filter_by}'</i> as <i>'#{filter_field}'</i>"
      end
    end
 
    # For AJAX requests, render the partial and disable the layout
    if request.xml_http_request?
      render :partial => "remittors_list", :layout => false
    end
  end

  def show

    if params[:id] == "list"
      @remittors = Remittor.paginate(:conditions => " remittors.is_deleted = 0",:page => params[:page], :per_page =>1)
    else
      @remittors = Remittor.paginate(:conditions => " remittors.is_deleted = 0 and remittors.id = #{params[:id]}",:page => params[:page], :per_page =>1)
    end
  end

  def edit

   
    @remittor = Remittor.find(params[:id])
    @shifts = Shift.find(:all).map {|s| s.name}
    @roles = Role.find(:all).map {|r| r.name}
    @selected = @remittor.shift.name
    role_user = RemittorsRole.find(:all,:conditions=>"remittor_id=#{@remittor.id}",:select => "distinct role_id")
    role_user.each do |ru|
      @role_array = ru.role.name
    end
    
  end

  def update

    remittor = Remittor.find(params[:id])
    remittors_roles=RemittorsRole.find(:first,:conditions=>{:remittor_id=>remittor.id})
    remittor.update_attributes(params[:remittor])
    remittor.status = "Offline"
    remittor.save
    unless params[:remittor][:password].empty? or params[:remittor][:password_confirmation].empty?
      remittor.login = params[:remittor][:login]
      remittor.password = params[:remittor][:password]
      remittor.save
      shift = Shift.find_by_name(params[:shift])
      remittor.update_attributes(:shift_id =>shift.id)
      @roles  =  params[:role][:id] unless params[:role].blank?
      if @roles && remittor
        role = Role.find_by_name(@roles)
        remittors_roles.role_id = role.id
        remittors_roles.save
        flash[:notice] = 'User was successfully updated.'
        redirect_to :controller => 'remittors',:action => 'list'
      else
        flash[:notice]  = "UserID and Password should be min 6 characters long, Email should be in correct format"
        redirect_to :controller => 'remittors',:action => 'edit'
      end
    else
      flash[:notice] = 'Password cannot be blank.'
      redirect_to :controller => 'remittors',:action => 'edit',:id=>params[:id]
    end
    page = params[:page]

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
        @remittor = Remittor.find(:first,:conditions=>["id=?",id])
        user =RemittorsRole.find(:first,:conditions=>["remittor_id=?",id]) 
        roles=Role.find(:first,:conditions=>["id=?",user.role_id])
        @remittor.is_deleted = 1
        @remittor.status = "Offline"
        @remittor.save
        if (@flag==1)
          flash[:notice] = "Deleted #{users.keys.size-1} user(s)."
        else
          flash[:notice] = "Deleted #{users.keys.size} user(s)."
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

  end

  def list_processor_occupancy
   
    time_minus_12_hrs = Time.now - 12.hours
 
    relation_include = [ {:remittors_roles => :role}]


    users = Remittor.find(:all,:conditions => "roles.name = 'Processor' and status = 'Online'",
      :include => relation_include)
    @users=[]
    users.each do |f|
      @jobs =Job.find(:all,:conditions => " processor_id = '#{f.id}'")
      @jobs.each do |s|
        @users << Remittor.find(:first,:conditions => " id = '#{s.processor_id}'")
      end
    end
    @users.uniq!
    return_processors(@users, time_minus_12_hrs)
  end
  def return_processors(users, time)
    users.each do |user|
      user['allocated_jobs'] = Job.count(:conditions => ["processor_id = ? and processor_flag_time >= ?", user.id, time])

      user['completed_jobs'] = Job.count(:conditions => ["processor_id = ? and processor_flag_time >= ? and processor_status = ?", user.id, time, 'Processor Complete || Processor Incomplete'])

      user['completed_eobs'] = Job.sum(:count, :conditions => ["processor_id =? and processor_flag_time >= ? and processor_status = ?", user.id, time, 'Processor Complete || Processor Incomplete'])
    end
  end

#  def joblist
#
#    @remittor=current_remittor
#    @rol=@remittor.roles
#    # @jobs =Batch.paginate(:all, :page => params[:page], :per_page =>1)
# 
#
#    @user1=[]
#     
#    if ((params[:date_from].blank?) and (params[:date_to].blank?))
#
#      @user=Job.find(:all,:conditions=>"processor_status='Processor Complete' and time_taken is not null",:select=>"processor_id processor_id,sum(count) count,((sum(time_taken)/60)/sum(count)) time ",:group=>"processor_id",:order=>"time",:joins=>"inner join remittors on remittors.id=jobs.processor_id")
#      @user.each do|p|
#        @job_completed = Job.count(:all,:conditions=>"processor_id=#{p.processor_id} and processor_status='Processor Complete' and time_taken is not null")
#        p['processor_id']= p.processor_id
#          p['count']= p.count
#      
#        p['time'] = p.time
#        p['totalcount'] = EobQa.count(:all,:conditions=>"processor_id=#{p.processor_id}")
#        p['incorrect'] = EobQa.count(:all,:conditions=>"processor_id=#{p.processor_id} and total_incorrect_fields>0")
#         @user1 << p
#      end
#    else if ((params[:date_from].blank?) and (not params[:date_to].blank?))
#        flash[:notice] = "From Date Mandatory"
#        @user='nil'
#        # @batch_pages, @users = paginate_collection @user , :per_page => 30 ,:page => params[:page]
#        @users =Remittor.paginate(:all,:conditions=>"is_deleted=0", :page => params[:page], :per_page =>50)
#        redirect_to :controller=>'user',:action => 'joblist'
#      else if ((not params[:date_from].blank?) and (params[:date_to].blank?))
#          flash[:notice] = "To Date Mandatory"
#          @user='nil'
#          #@batch_pages, @users = paginate_collection @user , :per_page => 30 ,:page => params[:page]
#          @users =Remittor.paginate(:all,:conditions=>"is_deleted=0", :page => params[:page], :per_page =>50)
#          redirect_to :controller=>'user',:action => 'joblist'
#        else if ((not params[:date_from].blank?) and (not params[:date_to].blank?))
#            time_from = (params[:date_from] + " 00:00:00").to_time
#            session[:fromtime]= time_from
#            time_to = (params[:date_to] + " 23:59:59").to_time
#            time_to1 = (params[:date_to] + " 00:00:00").to_time
#            session[:totime]= time_to1
#            #For EST to IST conversion minus 10h and 30 min from from date and to_date
#            if(params[:criteria]=='IST')
#              @user=Job.find(:all,:conditions=>"processor_status in ('Processor Complete','Complete') and processor_flag_time>=TIMESTAMPADD(hour,-#{params[:time_difference]},'#{time_from.to_date}') and processor_flag_time<TIMESTAMPADD(hour,-#{params[:time_difference]},'#{(time_to + 1.days).to_date}') and time_taken is not null and processor_id is not null",:select=>"processor_id processor_id,sum(count) count,((sum(time_taken)/60)/(sum(count))) time",:group=>"processor_id",:order=>"time")
#            else
#              @user=Job.find(:all,:conditions=>"processor_status in ('Processor Complete','Complete') and processor_flag_time>='#{time_from.to_date}' and processor_flag_time<'#{(time_to + 1.days).to_date}' and time_taken is not null and processor_id is not null",:select=>"processor_id processor_id,sum(count) count,((sum(time_taken)/60)/(sum(count))) time",:group=>"processor_id",:order=>"time")
#            end
#            @user.each do|p|
#              p['processor_id']= p.processor_id
#              p['count']= p.count
#              p['time'] = p.time
#              p['totalcount'] = EobQa.count(:all,:conditions=>"processor_id=#{p.processor_id} and time_of_rejection>='#{time_from.to_date}' and time_of_rejection<='#{(time_to+1.days).to_date}'")
#              p['incorrect'] = EobQa.count(:all,:conditions=>"processor_id=#{p.processor_id} and total_incorrect_fields>0 and time_of_rejection>='#{time_from.to_date}' and time_of_rejection<'#{(time_to+1.days).to_date}'")
#              @user1 << p
#
#            end
#          end
#
#        end
#      end
#    end
#   
#    @users  =@user1.paginate( :page => params[:page], :per_page =>40)
#
#
#  end
#  
#  
  
  def joblist
    @user1=[]
    @criteria=params[:criteria]
    @datefrom=params[:date_from]
    @dateto=params[:date_to]
    @timediff= params[:time_difference]
    if ((params[:date_from].blank?) and (params[:date_to].blank?))
      users=Job.find(:all,:conditions=>"processor_status IN ('Processor Complete', 'Processor Incomplete') and time_taken is not null",:select=>"processor_id processor_id,sum(count) count,((sum(time_taken)/60)/sum(count)) time ",:group=>"processor_id",:order=>"time",:joins=>"inner join users on users.id=jobs.processor_id")
      users.each do|p|
        p['processor_id']= p.processor_id
        p['count']= p.count
        p['time'] = p.time
        p['totalcount'] = EobQa.count(:all,:conditions=>"processor_id='#{p.processor_id}'")
        p['incorrect'] = EobQa.count(:all,:conditions=>"processor_id='#{p.processor_id}' and total_incorrect_fields>0")
        @user1 << p
      end
    else if ((params[:date_from].blank?) and (not params[:date_to].blank?))
        flash[:notice] = "From Date Mandatory"
        users='nil'
        @users=users.paginate(:all,:page=>params[:page],:per_page=>30)
        redirect_to :controller=>'remittors',:action => 'joblist'
      else if ((not params[:date_from].blank?) and (params[:date_to].blank?))
          flash[:notice] = "To Date Mandatory"
          users='nil'
          @users=users.paginate(:all,:page=>params[:page],:per_page=>30)
          redirect_to :controller=>'remittors',:action => 'joblist'
        else if ((not params[:date_from].blank?) and (not params[:date_to].blank?))
            time_from = (params[:date_from] + " 00:00:00").to_time
            session[:fromtime]= time_from 
            time_to = (params[:date_to] + " 23:59:59").to_time
            time_to1 = (params[:date_to] + " 00:00:00").to_time
            session[:totime]= time_to1
            #For EST to IST conversion minus 10h and 30 min from from date and to_date
            if(params[:criteria]=='IST')

              users=Job.find(:all,:conditions=>"processor_status IN ('Processor Complete','Processor Incomplete','Complete') and processor_flag_time>=TIMESTAMPADD(hour,-#{params[:time_difference].first.to_f},'#{time_from.to_date}') and processor_flag_time<TIMESTAMPADD(hour,-#{params[:time_difference].first.to_f},'#{(time_to + 1.days).to_date}') and time_taken is not null",:select=>"processor_id processor_id,sum(count) count,((sum(time_taken)/60)/(sum(count))) time",:group=>"processor_id",:order=>"time")
            else
              users=Job.find(:all,:conditions=>"processor_status IN ('Processor Complete','Processor Incomplete','Complete') and processor_flag_time>='#{time_from.to_date}' and processor_flag_time<'#{(time_to + 1.days).to_date}' and time_taken is not null",:select=>"processor_id processor_id,sum(count) count,((sum(time_taken)/60)/(sum(count))) time",:group=>"processor_id",:order=>"time")
            end
            users.each do|p|
              p['processor_id']= p.processor_id
              p['count']= p.count
              p['time'] = p.time

              p['totalcount'] = EobQa.count(:all,:conditions=>"processor_id='#{p.processor_id}' and time_of_rejection>='#{time_from.to_date}' and time_of_rejection<='#{(time_to+1.days).to_date}'")
              p['incorrect'] = EobQa.count(:all,:conditions=>"processor_id='#{p.processor_id}' and total_incorrect_fields>0 and time_of_rejection>='#{time_from.to_date}' and time_of_rejection<'#{(time_to+1.days).to_date}'")

              @user1 << p
            end
          end
          
        end
      end
    end

    @users=@user1.paginate(:page=>params[:page],:per_page=>50)

  end

  
  
  

  def processor_report
    render :action=>"joblist"
  end
  
  
def accuracy_report

 #session[:user]=params[:procid]
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

      @firsttime= session[:fromtime].to_time
      @firsttime1= session[:fromtime].to_time


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
  
  def destroy
    user = Remittor.find(params[:id])
    if user.login == 'admin'
      flash[:notice] = 'Default admin cannot be deleted.'
    else
      user.destroy
    end
    redirect_to :action => 'list'
  end

  
    #being used by processor report to get final list of users
  def filter_processor_report(user, time_from, time_to)
    user.blank? ? condition = "" : condition = " and users.login like '%#{user}%'"
    users = Remittor.find(:all,:conditions => ["jobs.processor_flag_time >= ? and
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
  
    def list_jobs
      @user = Remittor.find(params[:id])
      @jobs = Job.find(:all, :conditions => "processor_id = #{@user.id}",
        :joins => "left join batches on batch_id = batches.id" )
      
      if @jobs.size == 0
        flash[:notice] = "No job has been assigned to the processor!"
        redirect_to :action => 'list'
      end #if
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
    
    user = Remittor.find(params[:user])
    facility_id = params[:id].to_i unless params[:id].nil?
    @facility_jobs = user.facility_jobs(time_from, time_to)
    
    unless params[:id].nil?
      jobs = list_facility_jobs(time_from, time_to, facility_id, params[:user].to_i)
    else
      jobs = list_facility_jobs(time_from, time_to, @facility_jobs[0].id.to_i, params[:user].to_i)
    end
    @jobs = Job.paginate(:per_page => 50, :page => params[:page])
  end
  
  
    
  def remove_clients
    processor = Remittor.find(params[:processor])
    selected_clients = params[:clients_to_remove]
    selected_clients = selected_clients.delete_if {|k, v| v=="0"}
    selected_clients.each {|k, v|
      UserClientJobHistory.find_by_user_id_and_client_id(processor.id, k).destroy
      }
    redirect_to :action => 'assign_clients', :id => processor    
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
  
    def list_qa_occupancy
      time_minus_12_hrs = Time.now - 12.hours
      # @users = User.find(:all,:conditions => ["role = 'QA' and status = 'Online'"])                     
      @users = Remittor.find(:all,:conditions => ["role = 'QA' and status = 'Online' and jobs.qa_id = users.id and jobs.qa_flag_time >= ?",time_minus_12_hrs],
        :include => :qa_jobs,
        :group => "jobs.qa_id")                       
      return_qa(@users, time_minus_12_hrs)
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
  
  
  
  def assign_clients
    @processor = Remittor.find(params[:id])
    @all_clients = Client.find(:all) - @processor.clients
  end
  
 #allocates/assigns processors to a team leader
  def allocate_members
    @tl = Remittor.find(params[:tl])
    selected_processors = params[:users_to_assign]
    selected_processors = selected_processors.delete_if {|k, v| v=="0"}
    selected_processors.each {|k, v| u = User.find(k); u.teamleader = @tl; u.update }
    redirect_to :action => 'assign_members', :id => @tl
  end
  
  
def allocate_clients
    processor = Remittor.find(params[:processor])
    selected_clients = params[:clients_to_assign]
    selected_clients = selected_clients.delete_if {|k, v| v=="0"}
    selected_clients.each {|k, v|
      c = Client.find(k)
      user_client = UserClientJobHistory.create!(:user => processor, :client => c)
    }
    redirect_to :action => 'assign_clients', :id => processor
  end

end

