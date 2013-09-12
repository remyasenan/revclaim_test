class Admin::PayergroupController < ApplicationController

  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#    :redirect_to => { :action => :list }

  def list
    search_field = params[:to_find] 
    compare = params[:compare]
    criteria = params[:criteria]
    search_field.strip! unless search_field.nil?
    if search_field.blank?
      shifts = Payergroup.find(:all)
   
    else
      shifts= filter_payergroup(criteria, compare, search_field)
         
    end
    @payergroup_pages,  @shifts =paginate_collection    shifts, :per_page =>10 ,:page => params[:page]
  end
  def filter_payergroup(field, comp, search)
    flash[:notice] = nil
    case field
    when 'PayerGroupName'
      flash[:notice] = "String search, '#{comp}' ignored."
      payergroup = Payergroup.find(:all, :conditions => "payergroupname like '%#{search}%'")
      
    end
    if  payergroup.size == 0
      flash[:notice] = " Search for \"#{search}\" did not return any results. Try another keyword!"
      redirect_to :action => 'list'
    end 
    payergroup
  end
  def payergroupmanage
    all_jobs = params[:payers_to_delete]
    all_jobs1=params[:payers_to_delete]

    @job=[]
    @job1=[]
    all_jobs.delete_if do |key,value|
      value == "0"
    end
    if   params[:option1] == 'Manage Payer'
      if all_jobs.size>1 or all_jobs.size==0
        flash[:notice]="Please  select one payergroup to insert payer "
        redirect_to :controller =>'payergroup',:action => 'list'
      else
        all_jobs.keys.each do |id|
          redirect_to :controller =>'payergroup',:action => 'viewpayer',:id=>id
    
        end
      end
    elsif params[:option1] == 'Allocate TL'
  
      all_jobs1.delete_if do |key,value|
        value == "0"
      end
      all_jobs1.keys.each do |id1|
        @job << id1
         
      end
      
      if @job.empty?
        flash[:notice]="Please  select one payergroup  "
        redirect_to :controller =>'payergroup',:action => 'list'
      else
        redirect_to :controller=>'payergroup',:action => 'addtl',:jobs=>@job
      end
    else 
      all_jobs1.delete_if do |key,value|
        value == "0"
      end
      all_jobs1.keys.each do |id2|
        @job1 << id2
      end
      redirect_to :controller=>'payergroup',:action => 'deallocatetl',:jobs1=>@job1
    end
  
  end
  def dest
    status=0
    @grpid= params[:id]
   
    @pay=Payer.count(:all,:conditions=>"payer_group_id=#{@grpid}")
    if @pay!=0
    @payid=Payer.find_by_payer_group_id(@grpid).id
    
    if @payid!=0
    @job=Job.find(:all,:conditions=>"payer_id='#{@payid}'")
    
    @job.each do |gpjob|
      if gpjob.job_status =="Processing" or gpjob.job_status=="New"
        status=status+1
      end
    end
    if status>0
      flash[:notice] = 'Payergroup not able to delete,Job under Processing.'
      redirect_to :controller =>'payergroup',:action => 'list'
    else
      @s=Payergroup.find_by_id(params[:id])
      @count= Payer.count(:conditions => "payer_group_id = '#{@grpid}' ")
      if @count==0
        @s.destroy
      elsif !(@count= Payer.count(:conditions => "payer_group_id = '#{@grpid}' ")).blank?

        1.upto @count do |x|
          @w = Payer.find_by_payer_group_id(params[:id])
          # if !(@w=Payer.find_by_payergroupid(params[:id])).blank?

          @w.payer_group_id = '0'
          @w.gr_name=' '
          @w.update
          @s.destroy
        end
      else
        @s.destroy
      end
      flash[:notice] = 'Payergroup was Deleted.'
      redirect_to :controller =>'payergroup',:action => 'list'
    end
  end
    else
   @a=Payergroup.find_by_id(params[:id])
   @a.destroy
   redirect_to :controller =>'payergroup',:action => 'list'
  end
  end
  def show
    @payergroup = Payergroup.find(params[:id])
  end

  def new
    @payergroup = Payergroup.new
  end

  def create
    puts params[:payergroup][:payergroupname]
    @payergroup = Payergroup.new
    @payergroup.payergroupname = params[:payergroup][:payergroupname]
    if @payergroup.save
      flash[:notice] = 'Payergroup was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    status = 0
    payergroupid =  params[:id]
   @pay=Payer.count(:all,:conditions=>"payer_group_id=#{payergroupid}")
    if @pay!=0
   
    @job1 = Payer.find_by_payer_group_id(payergroupid).id
    
   payerid = Payer.find_by_payer_group_id(payergroupid).id
   puts 
 @job = Job.find(:all,:conditions=>"payer_id='#{payerid}'")
    
    if(@job1!=0)
      @job.each do |gpjob|
        if gpjob.job_status =="Processing" or gpjob.job_status=="New"
          status=status+1
        end
      end
      puts  status
      if status>0
        flash[:notice] = 'Payergroup not able to Edit,Job(s) under Processing.'
        redirect_to :controller =>'payergroup',:action => 'list'
      else
        @payergroup = Payergroup.find(params[:id])
        render :action => 'edit'
      end
    else
      @payergroup = Payergroup.find(params[:id])
      render :action => 'edit'
    end
    else
       @payergroup = Payergroup.find(params[:id])
      render :action => 'edit'
    end
  end
  def update
    puts params[:id]
    @payergroup = Payergroup.find(params[:id])
    if @payergroup.update_attributes(params[:payergroup])
      flash[:notice] = 'Payergroup was successfully updated.'
      redirect_to :action => 'show', :id => @payergroup
    else
      render :action => 'edit'
    end
  end

  def destroy
    Payergroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def listpayer
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]
    @t= params[:id]
 
    if search_field.blank?
      payers = Payer.find(:all, :conditions =>" payer_group_id = '0'")
    else
      payers = filter_payers(criteria, compare, search_field, action = 'list')
    end
    @payer_pages, @payers = paginate_collection payers, :per_page =>30,:page => params[:page]
  end
  def filter_payers(field, comp, search, act)
    flash[:notice] = nil
    case field
    when 'Date Added'
      if search !~ /\d{4}-\d{2}-\d{2}/ then @flag_incorect_date = 0; end
      payers = Payer.find(:all, :conditions => "date_added #{comp} '#{search}'")
    when 'Initials'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "initials like '%#{search}%'")
    when 'From Date'
      if search !~ /\d{4}-\d{2}-\d{2}/ then @flag_incorect_date = 0; end
      payers = Payer.find(:all, :conditions => "from_date #{comp} '#{search}'")
    when 'Gateway'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "gateway like '%#{search}%' and payer_group_id = '0'")
    when 'Payer Id'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "payid like '%#{search}%' and payer_group_id = '0'")
    when 'Payer'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "payer like '%#{search}%' and payer_group_id = '0'")
    when 'Address-1'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "pay_address_one like '%#{search}%'")
    when 'Address-2'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "pay_address_two like '%#{search}%'")
    when 'Address-3'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "pay_address_three like '%#{search}%'")
    when 'Address-4'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "pay_address_four like '%#{search}%'")
    when 'Phone'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "phone like '%#{search}%'")
    end
    
    if payers.size == 0
      flash[:notice] = "Search for \"#{search}\" did not give any Results "
      redirect_to :action => 'listpayer'
    end

    return payers
  end

  
  
  def viewpayer
    @pgid =  params[:id]
  
    @pay= Payer.find(:all, :conditions =>" payer_group_id = '#{@pgid}' ")
   @payer_pages, @pay = paginate_collection @pay, :per_page =>30,:page => params[:page]
   
  end
  def addtolist
    # TODO: Messy way to handle multiple checkboxes from the view
    pggpid= params[:id1]
   payers = params[:payers_to_delete]
   payers.delete_if do |key, value|
      value == "0"
    end
    payers.keys.each do |id|
      @payer= Payer.find(id)
      @payer.payer_group_id = pggpid
      payergpname = Payergroup.find_by_id(pggpid).payergroupname
      @payer.gr_name = payergpname
      @payer.update
      
    end
    if payers.size != 0
      flash[:notice] = "Inserted #{payers.size} payer(s)."
    else
      flash[:notice] = "Please select atleast one payer to Insert"
    end
    redirect_to :action => 'list'
  end
  def delete
    # TODO: Messy way to handle multiple checkboxes from the view
   
   
    payers = params[:payers_to_delete]
    payers.delete_if do |key, value|
      value == "0"
    end
    payers.keys.each do |id|
      @payer= Payer.find(id)
      @payer.payer_group_id = 0
      @payer.gr_name = ""
      @payer.update
    
    
    end
    if payers.size != 0
      flash[:notice] = "Deleted #{payers.size} payer(s)."
    else
      flash[:notice] = "Please select atleast one payer to Insert"
    end
    redirect_to :action => 'list'
  end
  
  def  assigntl
    @job = params[:jobs]
    @job.each do |id|
      p = TeamLeaderQueue.find_by_payer_group_id(id)
      if p.blank?
        @jobtl = TeamLeaderQueue.new
        @jobtl.payer_group_id = id
        userid = User.find_by_id(params[:user]).userid
        @jobtl.tlusername = params[:user]
        @jobtl.workstatus = '1'
        @jobtl.job_allocated_time = Time.now
        @jobtl.save
      end
    end
    redirect_to :controller=>'batch',:action => 'payer_grouplist'
  end
  def  deallocatetl
    @jobs=params[:jobs1]
    @jobs.each do |id|
      if  TeamLeaderQueue.find_by_payer_group_id(id).blank?
        flash[:notice] = 'Allocated TL Can Deallocate.'
        #setting flag
        @t=1
      else
       TeamLeaderQueue.find_by_payer_group_id(id).destroy
        @t=0
      end
 
    end
    if @t == 1
      redirect_to :controller=>'payergroup',:action => 'list'
    else
      redirect_to :controller=>'batch',:action => 'payer_grouplist'
    end
  end
  def tlworkque
    payers1 = []
    c=0
    # puts    params[:id]
    userid=params[:id]
    
    #@jobs=Tlque.find_by_tlusername(userid)
    jobs=  TeamLeaderQueue.find(:all, :conditions => "tlusername = '#{userid}'")
    jobs.each do |user|
 payergroupid=user.payer_group_id

 payid=Payer.find_by_payer_group_id(payergroupid).id
 
     
      ##payer_job_count=Job.find_by_sql("(SELECT sum(jobs.estimated_eob) eobs, count(*) count,payers.id payer_id from jobs LEFT JOIN batches on  batches.id=jobs.batch_id  and batches.status != 'Complete' and batches.status != 'HLSC Verified' LEFT JOIN payers on payers.id=jobs.payer_id where payers.payer_group_id=#{payergroupid} group by payers.payer_group_id)  ")
      payer_job_count=Job.find_by_sql("select sum(jobs.estimated_eob) eobs, count(*) count,jobs.payer_id payer_id from payers,batches,jobs where jobs.payer_id=payers.id and payers.payer_group_id!=0 and batches.id=jobs.batch_id  and batches.status != 'Complete' and batches.status != 'HLSC Verified' and payers.payer_group_id=#{payergroupid} group by payers.payer_group_id")
        
        
      
    
      #other_payers - array of payers with ETC as null.
      #etc_payers - array of payers which have ETC defined.
      other_payers = []
      etc_payers = []
      payer_job_count.each do |p|  
                  
              payer23=Payer.find_by_id(p.payer_id).payer_group_id 
        payer1= Payergroup.find_by_id(payer23).payergroupname
          
            
           
        # puts p.payer_id
        # puts  payer_job_count
        p['id']=payer23
        p['payergroupname'] =payer1
        payer3= Payer.find_by_id(p.payer_id)

        job_with_min_eobs =payer3.least_time
                      
        unless job_with_min_eobs.nil?
          p['etc'] = job_with_min_eobs.batch.expected_time
          p['tat'] = job_with_min_eobs.batch.contracted_time(@user.role)
        else
          p['etc'] = nil
          p['tat'] = nil
        end
        if p['etc'] == nil
          other_payers << p
        else
          etc_payers << p
        
        end
		
		
        #sort payers by ETC
        payers =  etc_payers.sort_by do |payer|
          [payer.tat, payer.etc]
        end
        
        #Add up other payers without ETC assigned @ the end.
	payers = payers + other_payers
       
  	payers1 << payers
       
      
      end
    end
   

    @payer_pages, @payers = paginate_collection  payers1 ,:per_page => 20 ,:page => params[:page]

  end
  def jobfind
    id = params[:id]
    @gpid = params[:id]
    payers1=[]
          @id1=Payer.find_all_by_payer_group_id(params[:id])
@id1.each do |p|  
             @a=Payer.find_by_payid(p.payid).id   
    payer_job_count = Job.find(:all, :conditions => "batch_id = batches.id and batches.status != 'Complete' and batches.status != 'HLSC Verified'  and jobs.payer_id = #{@a}",
      #:include => :batch,
      :joins => "LEFT JOIN batches on batch_id = batches.id",
      :group => "jobs.payer_id",
      :select => "sum(jobs.estimated_eob) eobs, count(*) count, jobs.payer_id payer_id")
    
    #other_payers - array of payers with ETC as null.
    #etc_payers - array of payers which have ETC defined.
    other_payers = []
    etc_payers = []
    payer_job_count.each do |p|  
      payer1 = Payer.find(p.payer_id)
      # puts p.payer_id
      # puts  payer_job_count
      p['payid'] = p.payer_id
      p['payer'] = payer1
                    
      job_with_min_eobs = payer1.least_time
      unless job_with_min_eobs.nil?
        p['etc'] = job_with_min_eobs.batch.expected_time
        p['tat'] = job_with_min_eobs.batch.contracted_time(@user.role)
      else
        p['etc'] = nil
        p['tat'] = nil
      end
      if p['etc'] == nil
        other_payers << p
      else
        etc_payers << p
        
      end
    end
		
    #sort payers by ETC
    payers =  etc_payers.sort_by do |payer|
      [payer.tat, payer.etc]
    end
    #Add up other payers without ETC assigned @ the end.
    payers = payers + other_payers
    payers1<<payers
end
      
    @payer_pages, @payers = paginate_collection payers1 , :per_page => 30 ,:page => params[:page]
  end
  def addtl
  
    @jobs = params[:jobs]

    #users = User.find(:all).select do |user|
    # user.role == 'Processor' and user.is_online?
    #end
    users = User.find(:all, :conditions => "role in ( 'TL') and status = 'Online'")

    # Find the status of the user, needed while allocating
    users.each do |user|
      if user.has_pending_jobs?
        user.remark = 'Occupied'
      else
        user.remark = 'Free'
      end
    end

    # Sorts users by remark
    # Remark holds the current batch allocation status
    # of the user
    @users = users.sort_by do |user|
      user.remark
    end
  end
end
