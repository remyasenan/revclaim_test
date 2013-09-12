# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class ProcessorController < ApplicationController

  #TODO: Processor controller and QA controller does almost the same. Clean up ...
  # before_filter :validate_processor

  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  require_role ["admin","Processor"]
  require 'will_paginate/array'
  @@eighteenhoursago  = 18.hours.ago.try(:strftime,"%Y-%m-%d %H%M%S")

  def my_job
    #@user=current_remittor
    user_id=@user.id
    if params[:allocation_status] == "1"
      @user.allocation_status = true
      @user.save
    end
    Job.auto_allocate_job(user_id)
    @jobs = Job.processor_job(@user.id)
    @ub04, @cms1500 = 0, 0
    jobs = Job.find(:all, :conditions => "processor_id = #{@user.id} and processor_status IN ('Processor Complete','Processor Incomplete') and processor_flag_time >= '#{@@eighteenhoursago}'")
    jobs.each do |job|
      if job.batch.batchid.upcase.include?("UB04")
        @ub04 = @ub04 + 1
      else
        @cms1500 = @cms1500 + 1
      end
    end
  end

 def completed_claims
    user = @user
    search_field = params[:job][:to_find] unless params[:job].nil?
    @jobs = []

    jobs = Job.find(:all, :conditions => "processor_id = #{user.id} and processor_status IN ('Processor Complete','Processor Incomplete') and processor_flag_time >= '#{@@eighteenhoursago}'", :order => "processor_flag_time")
    jobs ? @processor_claims = jobs.count : @processor_claims = 0
    params[:batch_type] ? @batch_type = params[:batch_type] : @batch_type = ""

    if search_field.blank?
      jobs.each do |job|
        if job.batch.batchid.upcase.include?(@batch_type)
          @jobs << job
        end
      end
      @jobs = @jobs.paginate(:per_page => 30 ,:page => params[:page])
    else
      filter_jobs(params[:job][:criteria], params[:job][:compare], params[:job][:to_find])
      @jobs = @jobs.paginate(:per_page => 30, :page => params[:page])      
    end
  end

  def filter_jobs(field, comp, search)
    user = current_remittor
    
    case field
      when 'Batch Id'
        jobs = Job.find(:all, :conditions => "((processor_id in (#{user.id}) and processor_status IN ('Processor Complete','Processor Incomplete')))")
        @jobs = []
        jobs.each do |job|
          if job.batch.batchid == "#{search}"
            @jobs << job
          end
        end
      when 'Count'
        @jobs = Job.find(:all, :conditions => "count #{comp} '#{search}' and ((processor_id in (#{user.id}) and processor_status IN ('Processor Complete','Processor Incomplete'))) ")
      when 'QA'
        @jobs = Job.find(:all, :conditions => "remittors.name like '%#{search}%' and ((processor_id in (#{user.id}) and processor_status IN ('Processor Complete','Processor Incomplete'))) ",
                         :joins => "left join remittors on qa_id = remittors.id")
    end
    if @jobs.size == 0
      flash[:notice] = "Search for #{search} did not return any results. Try another keyword!"
      redirect_to :action => 'completed_claims'
    end
  end


  def list_payer
    #  @payer_pages, @payers = paginate :payers, :per_page => 100
    @payers =Payer.paginate(:page => params[:page], :per_page =>10)
    #@payers = Payer.paginate (:all,:condition:page => params[:page], :per_page =>4)
  end

  def complete_job
    job = Job.find(params[:id])
    use=params[:job][:count].to_i + params[:job][:incomplete_count].to_i
     
    
      
    if params[:job][:count].blank?
      flash[:notice] = "EOB Count Incorrect"
      redirect_to :action => 'my_job'
    elsif params[:job][:count].to_i > 200
      flash[:notice] = "You have exceeded maximum Eobs!"
      redirect_to :action => 'my_job'
    elsif params[:payerid].blank?
      flash[:notice] = "Please Enter PayerId"
      redirect_to :action => 'my_job'
    elsif params[:job][:incomplete_count].blank?
      flash[:notice] = "Please Enter remaining Eobs"
      redirect_to :action => 'my_job'
    else
      job.incomplete_count = params[:job][:incomplete_count]
      job.processor_flag_time = Time.now
        if job.processor_comments.nil?
          job.processor_status = ProcessorStatus['Processor Complete'].to_s         # Not sure about the status need to check
        else
          job.processor_status = ProcessorStatus['Processor Incomplete'].to_s
        end
      if job.qa_id != nil
        if job.qa_status == 'QA Complete'
          job.job_status = JobStatus['Complete'].to_s
        elsif job.qa_status == 'QA Rejected'
          job.qa_status = QaStatus['QA Allocated'].to_s
        end
      else
        job.job_status = JobStatus['Complete'].to_s
      end
     @userpayerjobhistory=UserPayerJobHistory.find(:first,:conditions=>"payer_id='#{job.payer_id}'and user_id= '#{job.processor_id}'")
      if @userpayerjobhistory.nil?
        new_job_history = UserPayerJobHistory.new
        new_job_history.job_count = 1
        new_job_history.user = job.processor
        new_job_history.payer = job.payer
        new_job_history.save
      else
        job_history = @userpayerjobhistory
        job_history.job_count += 1
        job_history.update
      end
      @userclientjobhistory=UserClientJobHistory.find(:first,:conditions=>"client_id='#{job.batch.facility.client_id}'and user_id= '#{job.processor_id}'")
      if @userclientjobhistory.nil?
        new_client_history = UserClientJobHistory.new
        new_client_history.job_count = 1
        new_client_history.user = job.processor
        new_client_history.client = job.batch.facility.client
        new_client_history.save
      else
        client_history = @userclientjobhistory
        client_history.job_count += 1
        client_history.update
      end
      
      if !job.incomplete_count.nil? and job.incomplete_count > 0
        if not params[:payerid].blank?
          payer = Payer.find_by_payid(params[:payerid])
          @payergroup=Payer.find_by_payid(params[:payerid]).payer_group_id
          unless payer.nil?
            new_job = Job.new(:check_number => job.check_number, :batch => job.batch,
              :estimated_eob => job.incomplete_count, :payer => payer)
            new_job.save!
            update_jobs(job)
          else
            flash[:notice] = "PayerID is invalid"
            redirect_to :action => 'my_job'
          end
        end
      elsif 
        payer = Payer.find_by_payid(params[:payerid])
        if !payer.nil?
          update_jobs(job)
        else
          flash[:notice] = "PayerID is invalid. Enter Correct PayerID (or) Please Create New Payer."
          redirect_to :action => 'my_job'
        end
      else
        flash[:notice] = 'PayerID is invalid. Enter Correct PayerID (or) Please Create New Payer.'
        redirect_to :action => 'my_job'
      end
    end
  end

  def stop_allocate
    remitor = Remittor.find(@current_remittor)
    remitor.allocation_status = 0
    remitor.save
    render :text => "You are temporary Suspended from Job Allocation"
  end

  def update_jobs(job)
    job.update_attributes(params[:job])
    flash[:notice] = 'Job was sucessfully updated'
    # Updating the batch status
    batch = job.batch
    batch.update_status
    redirect_to :action => 'my_job'
  end
end
