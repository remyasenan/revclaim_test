# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class HlscController < ApplicationController


  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  require_role ["admin","Supervisor","QA"]
  require 'will_paginate/array'
 # before_filter :validate_hlsc_supervisor, :except => [:unprocessed_batches]
  #before_filter :validate_hlsc_supervisor_tl, :only => [:unprocessed_batches]
  auto_complete_for :batch_rejection_comment , :comment
  auto_complete_for :job_rejection_comment , :comment

  def index
    batch_status
    render :action => 'batch_status'
  end

  def batch_status
    
    #@user=current_remittor
    @rol=@user.roles
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]

    search_field.strip! unless search_field.nil?

    # Handle mark/unmark
    if params[:mark] or params[:unmark]
      batch = Batch.find_by_batchid(params[:batch])
      if params[:mark]
        if !batch.hlsc.nil? and batch.hlsc != @user
          flash[:notice] = "Batch already marked by #{batch.hlsc}"
        else
          batch.hlsc = @user
          unless batch.update
            flash[:notice] = "Batch cannot be marked. Reason : #{batch.errors.entries[0]}"
          else
            flash[:notice] = "Batch marked successfully."
          end
        end
      end
      if params[:unmark]
        batch.hlsc = nil
        batch.status = BatchStatus['Complete'].to_s
        unless batch.update
          flash[:notice] = "Batch cannot be unmarked. Reason : #{batch.errors.entries[0]}"
        else
          flash[:notice] = "Batch unmarked successfully."
        end
      end
    end

    # Handle Accept Batch
    if params[:accept] and request.post?
      batch = Batch.find_by_batchid(params[:batch])
      batch.jobs.each do |job|
        job.job_status = JobStatus['HLSC Verified'].to_s
        job.update
      end
      batch.status = BatchStatus["HLSC Verified"].to_s
      batch.comment = "Verified by HLSC"

      #only payment batches are entered in report
      if batch.correspondence == 0 or batch.correspondence.nil?
        hlsc_report = HlscQa.create(:batch => batch,
          :total_eobs => batch.get_completed_eobs,
          :rejected_eobs => 0,
          :user => @user )
      end

      batch.hlsc = nil
      status_history = ClientStatusHistory.new
      status_history.time = Time.now
      status_history.status = batch.status
      status_history.user = @user.login
      unless status_history.update
        flash[:notice]  = 'Failed updating batch status history'
      end
      batch.client_status_histories << status_history
      batch.update

      flash[:notice] = "Batch #{batch.batchid} accepted on request"
    end

   
    conditions = "(status = 'Complete' or status = 'HLSC Verified' or status = 'HLSC Processing ')"
    order = "status, comment desc, completion_time"
 

    unless search_field.nil?
      case criteria
      when 'Batch Date'
        begin
          date = Date.strptime(search_field,"%m/%d/%y")
        rescue ArgumentError
          flash[:notice] = "Invalid date format"
        end
        batches = Batch.find(:all,:conditions => " date #{compare} '#{date}'")

      when 'Batch ID'
        batches = Batch.find(:all,:conditions => " batchid #{compare} '#{search_field}'")
      when 'Site Number'
        batches = Batch.find(:all,
          :conditions => conditions + " and facilities.sitecode #{compare} '#{search_field}'",
          :order => order,
          :joins => "left join facilities on facilities.id = batches.facility_id ")
      when 'Site Name'
        flash[:notice] = "String search, #{compare} ignored."
        batches = Batch.find(:all,
          :conditions => conditions + " and facilities.name like '%#{search_field}%'",
          :order => order,
          :joins => "left join facilities on facilities.id = batches.facility_id ")
      end
    else
      if @rol[0].name == 'HLSC'
        batches = Batch.completed_batches_payment
      else
        batches = Batch.find(:all,:conditions=>"status='Complete'")
      end
    end

    unless search_field.nil?
      if batches.size > 0
        flash[:notice] = "Match found"
      else
        flash[:notice] = "No match found"
        if @rol[0].name == 'HLSC'
          batches = Batch.completed_batches_payment
        else
          batches = Batch.find(:all,:conditions=>"status='Complete'")
        end
      end
    end

    # @batch_pages, @batches = paginate_collection batches, :per_page => 30, :page => params[:page]
    @batches =batches.paginate(:page => params[:page], :per_page =>2)
  end

  def unprocessed_batches

#    @user=current_remittor
    @rol=@user.roles
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]

    filter=0
    conditions="(status = 'New' or status = 'Processing')"
    batches1=Batch.find(:all,:conditions =>conditions)

    search_field.strip! unless search_field.nil?


    unless search_field.nil?
      filter=1
      case criteria
      when 'Batch Date'
        begin
          date = Date.strptime(search_field,"%m/%d/%y")
        rescue ArgumentError
          flash[:notice] = "Invalid date format"
        end
        batches = Batch.find(:all,
          :conditions => conditions + " and date #{compare} '#{date}'")
      when 'Batch ID'
        batches = Batch.find(:all,
          :conditions => conditions + " and batchid #{compare} '#{search_field}'")

      when 'Site Number'
        batches = Batch.find(:all,
          :conditions => conditions + " and facilities.sitecode #{compare} #{search_field.to_i}",:joins => "left join facilities on facilities.id = batches.facility_id ")
      when 'Site Name'
        batches = Batch.find(:all,
          :conditions => conditions + " and facilities.name like '%#{search_field}%'",
          :order => order,
          :joins => "left join facilities on facilities.id = batches.facility_id ")
        flash[:notice] = "String search, #{compare} ignored."
      end

      if batches.size > 0
        flash[:notice] = "Match found"
      else
        flash[:notice] = "No Matches found"

       # batches = Batch.uncompleted_batches

      end
    end

#    if filter==0
#      batches = batches1.each {|b|
#        b['allocated'] = b.jobs.find(:first, :conditions => "job_status = 'New'")
#        b['processor_allocated'] = b.jobs.find(:first, :conditions => "processor_status in ('New', 'Processor Allocated')")
#      }
#    end
    # @batch_pages, @batches = paginate_collection batches, :per_page => 30, :page => params[:page]

    if(filter==1)
      @batches =batches.paginate( :page => params[:page], :per_page =>40)
    else

      @batches =batches1.paginate( :page => params[:page], :per_page =>40)
    end
  end

  def reject_batch
    @batch = Batch.find(params[:id])
    @batch.update_attributes(params[:batch_rejection_comment])
    if params[:commit] == "Reject"
      @batch.jobs.each do |job|
        job.job_status = JobStatus['HLSC Rejected'].to_s
        job.comment = params[:batch_rejection_comment][:comment]
        job.update
      end
      @batch.status = BatchStatus['HLSC Rejected'].to_s
      @batch.hlsc = nil

      #only payment batch are entered in report
      if @batch.correspondence == 0 or @batch.correspondence.nil?
        hlsc_report = HlscQa.create(:batch => @batch,
          :total_eobs => @batch.get_completed_eobs,
          :rejected_eobs => @batch.least_eobs,
          :user => @user)
      end

      status_history = ClientStatusHistory.new
      status_history.time = Time.now
      status_history.status = @batch.status
      status_history.user = @user.userid
      unless status_history.update
        flash[:notice]  = 'Failed updating batch status history'
      end
      @batch.client_status_histories << status_history
      @batch.update
      flash[:notice] = "Batch #{@batch.batchid} rejected on request"
      redirect_to :action => "batch_status"
    end
  end

  def reject_checks
    @batch = Batch.find(params[:id])
    @checks = []
    @batch.jobs.each do |job|
      @checks << job.check_number
    end
    @checks.uniq!

    #rejected_check_number = 0
    if params[:commit] == "Reject"
      #rejected_check_number = params[:job][:check_number]
      @jobs = Job.find(:all, :conditions => ["batch_id = ? and check_number = ?", @batch.id, params[:job][:check_number]])
      total_rejected_eobs = 0
      @jobs.each do |job|
        job.job_status = JobStatus['HLSC Rejected'].to_s
        job.comment = params[:job_rejection_comment][:comment]
        total_rejected_eobs += job.count
        job.update
      end
      #only payment batch are entered in report
      if @batch.correspondence == 0 or @batch.correspondence.nil?
        create_entry_for_check_rejection(params[:job][:check_number], total_rejected_eobs)
      end
    end

    unless params[:accept_job].nil?
      check_numbers = Array.new
      accept_jobs  = Job.find_all_by_id(params[:accept_job])
      accept_jobs.each do |accept_job|
        check_numbers << accept_job.check_number
      end

      accept_jobs = Array.new
      check_numbers.each do |check_number|
        accept_jobs = Job.find(:all, :conditions => ["batch_id =? and check_number = ? and job_status  = 'HLSC Rejected' ", @batch.id, check_number])
        accept_jobs.each do |accept_job|
          accept_job.comment = ""
          accept_job.job_status = JobStatus['Complete'].to_s
          accept_job.update
        end
      end
    end

    check_numbers = Array.new

    rejected_jobs = @batch.jobs.select do |job|
      job.job_status == "HLSC Rejected"
      check_numbers << job.check_number
    end

    check_numbers.uniq!
    @rejected_jobs = Array.new

    check_numbers.each do |check_number|
      @rejected_jobs <<  Job.find(:first, :conditions => ["batch_id =? and check_number = ? and job_status  = 'HLSC Rejected' ", @batch.id, check_number])
    end

    #create_entry_for_check_rejection(rejected_check_number, total_rejected_eobs, @rejected_jobs)

    @batch.update_status
    if @batch.status == "HLSC Rejected"
      status_history = ClientStatusHistory.new
      status_history.time = Time.now
      status_history.status = @batch.status
      status_history.user = @user.userid
      unless status_history.update
        flash[:notice]  = 'Failed updating batch status history'
      end
      @batch.client_status_histories << status_history
      @batch.hlsc = nil
      @batch.comment = "Sub Jobs Rejected"
      @batch.update
    end
  end

  def create_entry_for_check_rejection(check_number, rejected_eobs)
    job_for_check_number = Job.find(:first, :conditions => ["batch_id = ? and check_number = ?", @batch.id, check_number])
    #if HlscQa.find_by_job_id(job_for_check_number.id).nil?
    hlsc_report = HlscQa.new
    hlsc_report.batch = @batch
    #hlsc_report.job = job_for_check_number
    hlsc_report.total_eobs = @batch.get_completed_eobs
    hlsc_report.rejected_eobs = rejected_eobs
    hlsc_report.user = @user
    hlsc_report.save
    #end
    return
  end

  def hlsc_report
    search_field_from = params[:find_from]
    search_field_to = params[:find_to]
    search_field_from.strip! unless search_field_from.nil?
    search_field_to.strip! unless search_field_to.nil?

    if not search_field_from.blank? and not search_field_to.blank?
      begin
        date_from = Date.strptime(search_field_from,"%m/%d/%y")
        date_to = Date.strptime(search_field_to,"%m/%d/%y")
      rescue
        flash[:notice] = "Invalid date format (mm/dd/yy)"
      end
      reports = HlscQa.find(:all, :conditions => "batches.date >= '#{date_from}' and batches.date <= '#{date_to}'",
        :joins => "left join batches on batches.id = hlsc_qas.batch_id",
        :group => "batches.date",
        :select => "batches.date batch_date, sum(total_eobs), sum(rejected_eobs) rejected_eobs")
      @batches_processed = Batch.find(:all, :conditions => "date >= '#{date_from}' and date <= '#{date_to}' and status != 'New'",
        :group => "date", :select => "count(batches.id) batch_count, batches.date date")
      total_eobs, total_batches, total_rejected = filter_batches(@batches_processed)
      date_range = date_from.strftime('%m/%d/%y').to_s + " - " + date_to.strftime('%m/%d/%y').to_s
    else
      reports = HlscQa.find(:all, :conditions => "batches.date >= '#{Date.today}' and batches.date <= '#{Date.today}'",
        :joins => "left join batches on batches.id = hlsc_qas.batch_id",
        :group => "batches.date",
        :select => "batches.date batch_date, sum(total_eobs), sum(rejected_eobs) rejected_eobs")
      @batches_processed = Batch.find(:all, :conditions => "date >= '#{Date.today}' and date <= '#{Date.today}' and status != 'New'",
        :group => "date", :select => "count(batches.id) batch_count, batches.date date")
      total_eobs, total_batches, total_rejected = filter_batches(@batches_processed)
      date_range = Date.today.to_s
    end
    summary_report(reports, date_range, total_eobs, total_batches, total_rejected)
    #@report_pages, @reports = paginate_collection reports, :per_page => 30 ,:page => params[:page]

       @reports =Report.paginate(:all, :page => params[:page], :per_page =>40)
  end

  def summary_report(report, date_range, eobs, batches, rejected)
    summary_report = report
    @summary = Hash.new
    @summary['eobs_rejected'] = 0
    @summary['batches_processed'] = batches
    @summary['batches_rejected'] = rejected
    @summary['eobs_processed'] = eobs
    summary_report.each do |sr|
      @summary['eobs_rejected'] = @summary['eobs_rejected'] + sr.rejected_eobs
    end
    if summary_report.size > 1
      @summary['date'] = date_range
    else
      @summary['date'] = Date.today.to_s
    end
    return
  end

  def filter_batches(batches_processed)
    total_batches = 0
    total_rejected_batches = 0
    total_eobs_processed = 0
    total_eobs_rejected = 0
    total_eobs = 0
    total_batches_complete = 0

    batches_processed.each do |b|
      rejected_batch_count = 0
      complete_batches = 0
      total_batches+= b.batch_count.to_i
      Batch.find_all_by_date(b.date).each do |bb|
        hlsc_qas = HlscQa.find_all_by_batch_id(bb.id)
        rejections = hlsc_qas.select {|hq| hq.rejected_eobs > 0}
        if rejections.size > 0
          rejected_batch_count += 1
          total_rejected_batches += 1
        end
        if hlsc_qas.size > 0
          complete_batches += 1
          total_batches_complete += 1
          total_eobs_processed += bb.get_completed_eobs
        end
        hlsc_qa_eobs = 0
        hlsc_qas.each do |hq|
          hlsc_qa_eobs += hq.rejected_eobs unless hq.rejected_eobs.nil?
        end
        total_eobs_rejected += hlsc_qa_eobs unless hlsc_qa_eobs.nil?
      end
      b['total_eobs'] = total_eobs_processed
      b['total_rejected_eobs'] = total_eobs_rejected
      b['complete_batches'] = complete_batches
      b['total_rejected_batches'] = rejected_batch_count
      total_eobs += total_eobs_processed
      total_eobs_rejected = 0
      total_eobs_processed = 0
    end
    return total_eobs, total_batches_complete, total_rejected_batches
  end

  #Report of Batches Completed by HLSC
  def completed_batches_report
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]
    @from_date = params[:from_date]
    @to_date = params[:to_date]

    search_field.strip! unless search_field.nil?
    from_date = (Time.now.to_time).at_beginning_of_day
    to_date = (Time.now.to_time).tomorrow.at_beginning_of_day

    conditions = "client_status_histories.status = 'HLSC Verified' and (batches.correspondence = 0 or batches.correspondence is null)"
    
    if !@from_date.blank? and !@to_date.blank? then
      begin
      	from_date = (@from_date.to_time).at_beginning_of_day
        to_date = ((@to_date.to_time).tomorrow).at_beginning_of_day
      rescue ArgumentError
        flash[:notice] = "Invalid date format"
      end

      # TODO: Convert to will_paginate and away from paginate_collection everywhere
      @report_pages, @reports = paginate :client_status_histories, 
        :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
        :include => [{:batch => :facility}],
        :conditions => [conditions + " and c2.batch_id is null and client_status_histories.time > ? and client_status_histories.time < ?", from_date, to_date],
        :per_page => 30

      
    elsif not search_field.blank?
      case criteria
      when "Batch ID"
        temp_search = search_field
        temp_search = temp_search.to_i
        @complete_reports = ClientStatusHistory.find(:all,
          :include => :batch,
          :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
          :conditions => conditions + " and c2.batch_id is null and batches.batchid #{compare} #{temp_search}")
      when "Batch Date"
        begin
          date = Date.strptime(search_field,"%m/%d/%y")
        rescue ArgumentError
          flash[:notice] = "Invalid date format"
        end
        @complete_reports = ClientStatusHistory.find(:all,
          :include => :batch,
          :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
          :conditions => conditions + " and c2.batch_id is null and batches.date #{compare} '#{date}'")
      when "Report on Date"
        begin
          date = Date.strptime(search_field,"%m/%d/%y")
          @from_date = (search_field.to_time).at_beginning_of_day
          @to_date = ((search_field.to_time).tomorrow).at_beginning_of_day
        rescue ArgumentError
          flash[:notice] = "Invalid date format"
        end
        @complete_reports = ClientStatusHistory.find(:all,
          :include => :batch,
          :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
          :conditions => [conditions + " and c2.batch_id is null and client_status_histories.time > ? and client_status_histories.time < ?",
            from_date, to_date])
      end
    else
      @complete_reports = ClientStatusHistory.find(:all,
        :include => :batch,
        :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
        :conditions => [conditions + " and c2.batch_id is null and client_status_histories.time > ? and client_status_histories.time < ?",
          from_date, to_date])
    end

    # TODO: Another thing to fix along with pagination
    if @report_pages.nil? && (@complete_reports.nil? || @complete_reports.size < 1)
      flash[:notice] = "No Match Found"

      @complete_reports = ClientStatusHistory.find(:all,
        :include => :batch,
        :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
        :conditions => [conditions + " and c2.batch_id is null and client_status_histories.time > ? and client_status_histories.time < ?",
          from_date, to_date])
    end

    # TODO: Clean this up so that pagination is centralized rather than split
    if @reports.nil?
     # @report_pages, @reports = paginate_collection @complete_reports, :per_page => 30 ,:page => params[:page]
         @reports =Report.paginate(:all, :page => params[:page], :per_page =>40)

    end
  end
  def batchlist
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]
    #order = "arrival_time desc"
    conditions = " batches.status in ('Processing' , 'HLSC Rejected') and jobs.job_status='Complete' and (batches.correspondence = 0 or  batches.correspondence is NULL )"
    unless search_field.nil?
      case criteria
      when 'Batch Date'
        begin
          date = Date.strptime(search_field,"%m/%d/%y")
        rescue ArgumentError
          flash[:notice] = "Invalid date format"
        end
        @batches = Batch.find(:all,
          :conditions => conditions + " and date #{compare} '#{date}'",
          :include => :jobs)
                             
      when 'Batch ID'
        @batches = Batch.find(:all,
          :conditions => conditions + " and batchid #{compare} #{search_field.to_i}",    
          :include => :jobs)
       
      when 'Site Name'
        @batches = Batch.find(:all,
          :conditions =>  " batches.status in ('Processing','HLSC Rejected') and batches.id=jobs.batch_id and jobs.job_status='Complete' and facilities.name like '%#{search_field}%'",
          :include=>[:jobs,:facility ])                      
        flash[:notice] = "String search, #{compare} ignored."
      end

    else
      @batches=Batch.find(:all,:conditions=>" batches.status in ('Processing', 'HLSC Rejected')  and jobs.job_status = 'Complete' and batches.id=jobs.batch_id and (batches.correspondence = 0 or  batches.correspondence is NULL ) ",
        :include=>:jobs)
 
    end
   # @batch_pages, @batches = paginate_collection @batches, :per_page => 30 ,:page => params[:page]
            @batches =Batch.paginate(:all, :page => params[:page], :per_page =>40)
  end

  def view_completed_jobs

    @user=current_remittor

    if params[:mark] or params[:unmark]
      batch = Batch.find_by_batchid(params[:batch])
      job = Job.find_by_id(params[:job])
      if params[:mark]
        if !job.hlsc.nil? and job.hlsc != @user
          flash[:notice] = "Job already marked by #{job.hlsc}"
        else
          job.hlsc = @user
          unless job.update
            flash[:notice] = "Job cannot be marked."
          else
            flash[:notice] = "Job marked successfully."
          end
        end
      end
      if params[:unmark]
        job.hlsc = nil
        job.job_status = JobStatus['Complete'].to_s
        unless job.update
          flash[:notice] = "Job cannot be unmarked."
        else
          flash[:notice] = "Job unmarked successfully."
        end
      end
    end

    # Handle mark/unmark
    if params[:mark] or params[:unmark]
      job = Job.find_by_id(params[:job])
      batch = Batch.find_by_batchid(params[:batch])
      if params[:mark]
        if !job.hlsc_id.nil? and job.hlsc_id != @user
          #flash[:notice] = "Job already marked by #{batch.hlsc}"
        else
          job.hlsc_id = @user
          unless job.update
            flash[:notice] = "Job cannot be marked. Reason : #{batch.errors.entries[0]}"
          else
            flash[:notice] = "Job marked successfully."
          end#unless
        end
      end#if mark
      if params[:unmark]
        job.hlsc_id = nil
        batch.status = BatchStatus['Complete'].to_s
        batch.update
        unless job.update
          flash[:notice] = "Job cannot be unmarked. Reason : #{batch.errors.entries[0]}"
        else
          flash[:notice] = "Job unmarked successfully."
        end#unless
      end#is unmark
    end#if mark /unmark
    @selected_batch = ""
    if !params[:payer].nil?
      payer = Payer.find(params[:payer])
    end

    payer.nil? == true ? payer_condition = "": payer_condition = "and payer_id = #{payer.id} "

    search_field = params[:job][:to_find] unless params[:job].nil?
    if search_field.blank?
      if params[:id].nil?
        @batch = Batch.find(session[:batch])
        @selected_batch = @batch
      else
        @batch = Batch.find(params[:id])
        @selected_batch = @batch
        session[:batch] = @batch.id
      end

      @jobs = Job.find(:all, :conditions => ["batch_id =?  and job_status  = 'Complete' ", @batch.id])
    else
      @selected_batch = session[:batch]
      @jobs =  filter_jobs(params[:job][:criteria], params[:job][:compare], params[:job][:to_find], payer_condition,@selected_batch)
    end
    #@job_pages, @jobs = paginate_collection @jobs, :per_page => 30 ,:page => params[:page]
             @jobs =Job.paginate(:all, :page => params[:page], :per_page =>40)
  end#view completed jobs
  

  def filter_jobs(field, comp, search, condition,selected)
    @job_batchid = params[:jobs]
    batch = Batch.find_by_id(selected)
    selected = batch.batchid
    case field
    when 'Check Number'
      @jobs = Job.find(:all, :conditions => "check_number #{comp} '#{search}' and  batchid = #{selected} and job_status = 'Complete' " ,
        :include => :batch)
                        
    when 'Tiff Number'
      @jobs = Job.find(:all, :conditions => "tiff_number #{comp} '#{search}'and  batchid = #{selected} and job_status = 'Complete' " ,
        :include => :batch)
                          

    end
    if @jobs.size == 0
      flash[:notice] = "Search for #{search} did not return any results. Try another keyword!"
      redirect_to :action => 'view_completed_jobs'
    end
    return @jobs
  end
  
  def reject_tiff
    unless params[:id].nil?
      @batch = Batch.find(params[:id])
      @tiff = params[:tiff]
      @job = params[:job]
      @check = params[:check]
      @payer = params[:payer]
      @facility = params[:facility]
    end
  end  

  #uploading  document for comments
  def add
    upload = params[:upload]
    if params[:upload][:file].size == 0
      flash[:notice] = "No File selected / File does not exist!"
      redirect_to :action => 'reject_tiff',:id => params[:batch] ,:tiff => params[:tiff] ,:check => params[:check],:payer => params[:payer] ,:facility => params[:facility]
    else
      data = params[:upload][:file]
      path = File.join('public/data/', data.original_filename)
      File.open(path, "wb") { |f| f.write(upload["file"].read) }
      doc = HlscDocument.new
      doc.file_name = data.original_filename
      doc.file_comments = params[:file_upload_comment][:comment]
      temp_file = data.original_filename
      doc.file_location = 'public/data/' + temp_file
      doc.file_created_time = Time.now
      doc.facility_id = params[:facility]
      doc.payer_id = params[:payer]
      doc.user_id = session[:user]
      if doc.save
        flash[:notice] = "File was successfully uploaded"
      else
        flash[:notice] = "Problem encountered during file upload!"
      end
      redirect_to :action => 'reject_tiff' ,:id => params[:batch] ,:tiff => params[:tiff] ,:check => params[:check],:payer => params[:payer] ,:facility => params[:facility]
    end
  end
  
  # add rejecting comment
  def add_rejection_comment

    @user=current_remittor
    @rol=@user.roles
    @batch = Batch.find(params[:batch])
    @tiff = params[:tiff]
    count = 0
    @batch.update_attributes(params[:batch_rejection_comment])
    if params[:commit] == "Reject"
      @batch.jobs.each do |job|
        if params[:tiff].nil?
          if job.check_number == params[:check]
            job.job_status = JobStatus['HLSC Rejected'].to_s 
            job.comment = params[:batch_rejection_comment][:comment]
            job.hlsc = nil
            job.update
          end
        else
          if job.tiff_number == params[:tiff] and job.check_number == params[:check]
            job.job_status = JobStatus['HLSC Rejected'].to_s 
            job.comment = params[:batch_rejection_comment][:comment]
            job.hlsc = nil
            job.update
            count = count + 1
          end
        end

      end
      @batch.status = BatchStatus['HLSC Rejected'].to_s
      @batch.hlsc = nil
      #only payment batch are entered in report
      if @batch.correspondence == 0 or @batch.correspondence.nil?
        hlsc_report = HlscQa.create(:batch => @batch,
          :total_eobs => @batch.get_completed_eobs,
          :rejected_eobs => @batch.least_eobs,
          :user => @user)
      end

      status_history = ClientStatusHistory.new
      status_history.time = Time.now
      status_history.status = @batch.status
      status_history.user = @user.userid
      unless status_history.update
        flash[:notice]  = 'Failed updating batch status history'
      end
      @batch.client_status_histories << status_history
      @batch.comment = "Sub Jobs Rejected"
      @batch.update
      flash[:notice] = "Job  rejected on request"
      redirect_to :action => "view_completed_jobs" ,:batch => params[:batch]
    end
  end  

end
