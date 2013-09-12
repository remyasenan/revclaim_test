# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.
require 'will_paginate/array'
class QaController < ApplicationController


  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  require_role ["admin", "Processor", "QA"]
  @@eighteenhoursago  = 18.hours.ago.try(:strftime,"%Y-%m-%d %H%M%S")

  #TODO: Processor controller and QA controller does almost the same. Clean up...
#  before_filter :validate_qa
#  layout 'standard'

  def my_job
#    @user = current_remittor
    # @jobs = Job.qa_job(current_remittor.id)
    @jobs=Job.paginate(:conditions =>"qa_id= '#{@user.id}' and qa_status= 'QA Allocated'", :per_page =>5, :page => params[:page])
    
    @ub04, @cms1500 = 0, 0
    jobs = Job.find(:all, :conditions => "qa_id = #{@user.id} and qa_status IN ('QA Complete', 'QA Incomplete') and qa_flag_time >= '#{@@eighteenhoursago}'")
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

    jobs = Job.find(:all, :conditions => "qa_id = #{user.id} and qa_status IN ('QA Complete', 'QA Incomplete') and qa_flag_time >= '#{@@eighteenhoursago}'", :order => "qa_flag_time")
    jobs ? @qa_claims = jobs.count : @qa_claims = 0
    params[:batch_type] ? @batch_type = params[:batch_type] : @batch_type = ""

    if search_field.blank?
      jobs.each do |job|
        if job.batch.batchid.upcase.include?(@batch_type)
          @jobs << job
        end
      end
      @jobs = @jobs.paginate(:per_page => 30, :page => params[:page])
    else
      filter_jobs(params[:job][:criteria], params[:job][:compare], params[:job][:to_find])
      @jobs = @jobs.paginate(:per_page => 30, :page => params[:page])
    end
  end


  def filter_jobs(field, comp, search)
    user = @user

    case field
      when 'Batch Id'
        jobs = Job.find(:all, :conditions => "qa_id in (#{user.id}) and qa_status = 'QA Complete'")
        @jobs = []
        jobs.each do |job|
          if job.batch.batchid == "#{search}"
            @jobs << job
          end
        end
      when 'Count'
        @jobs = Job.find(:all, :conditions => "count #{comp} '#{search}' and qa_id in (#{user.id}) and qa_status = 'QA Complete'")
      when 'Processor'
        @jobs = Job.find(:all, :conditions => "remittors.name like '%#{search}%' and qa_id in (#{user.id}) and qa_status = 'QA Complete'",
                         :joins => "left join remittors on processor_id = remittors.id")
    end
    if @jobs.size == 0
      flash[:notice] = "Search for #{search} did not return any results. Try another keyword!"
      redirect_to :action => 'completed_claims'
    end
  end

  def jobs_for_onlineusers

    user=Remittor.find(params[:id])
    @jobs =Job.paginate(:all, :page => params[:page], :per_page =>100)
  end

  def list_payer

    @payers =Payer.paginate(:all, :page => params[:page], :per_page =>100)
  end

  def online_users
    @users =Remittor.paginate(:all, :page => params[:page], :per_page =>100)
  end

  def eob_complete
    job = Job.find(params[:job])

    payer = params[:payer][:id]
    #validating Total fields and Total incorrect fields
    if (params[:eob][:total_fields].to_i < params[:eob][:total_incorrect_fields].to_i or params[:eob][:total_fields].to_i < 0 or params[:eob][:total_incorrect_fields].to_i < 0 )
      flash[:notice]  = '"Total Incorrect fields" count exceeds "Total fields" count'
    else
      #Eob Entry
      eob = EobQa.new(:total_fields => params[:eob][:total_fields], :total_incorrect_fields => params[:eob][:total_incorrect_fields], :eob_error => EobError.find_by_error_type(params[:error][:type]),
                      :job => job, :processor => job.processor, :qa => job.qa, :time_of_rejection => Time.now, :account_number => params[:eob][:account_number],
                      :comment => params[:eob][:comment], :payer => payer, :accuracy => job.processor.field_accuracy)
      if params[:eob][:status] == 'Verified'
        eob.status = "Accepted"
        eob.prev_status = "new"
      else
        eob.status = "Rejected"
        eob.prev_status = "new"
      end

      unless eob.save
        flash[:notice] = eob.errors.entries[0]
      else
        #User details updating
        user = User.find(job.processor_id)
        user.total_fields = user.total_fields + params[:eob][:total_fields].to_i
        user.total_incorrect_fields = user.total_incorrect_fields + params[:eob][:total_incorrect_fields].to_i
        user.eob_qa_checked = user.eob_qa_checked + 1
        user.update
        user.sampling_rate
      end
    end
    redirect_to :action => 'verify', :job => job.id
  end

  def eob_delete
    job = Job.find(params[:job])
    eob = EobQa.find(params[:eob])

    #User details updating
    user = User.find(job.processor_id)
    user.total_fields = user.total_fields - eob.total_fields
    user.total_incorrect_fields = user.total_incorrect_fields - eob.total_incorrect_fields
    user.eob_qa_checked = user.eob_qa_checked - 1
    user.update
    user.sampling_rate()
    eob.destroy

    redirect_to :action => 'verify', :job => job
  end

  def complete_job
    job = Job.find(params[:job])
    count_for_rejected_eobs = 0
    payer_flag = 0
    #Entry in eob report
    @eobs = job.eob_qas
    #Allow update only when eob info is available
    if @eobs.nil? or @eobs.size == 0
      flash[:notice] = "No verified/rejected EOB found. Add and resubmit."
      redirect_to :action => 'verify', :job => job
    else
      @eobs.each do |eob|
        if eob.prev_status != "old"
          EobReport.create(:verify_time => eob.time_of_rejection, :account_number => eob.account_number, :processor => job.processor.userid, :accuracy => eob.accuracy,
                           :qa => job.qa.userid, :batch_id => job.batch.batchid, :batch_date => job.batch.date, :total_fields => eob.total_fields,
                           :incorrect_fields => eob.total_incorrect_fields, :error_type => eob.eob_error.error_type, :error_severity => eob.eob_error.severity,
                           :error_code => eob.eob_error.code, :status => eob.status, :payer => eob.payer )
          if eob.total_incorrect_fields > 0
            count_for_rejected_eobs += 1
          end
        end
        eob.prev_status = "old"
        eob.update
      end

      user = job.processor
      #if job rejections > 0, do not recount the eob count
      if job.rejections == 0
        user.total_eobs = user.total_eobs + job.count
      end
      #rejected_eobs is the count of eobs with incorrect fields >= 1)
      user.rejected_eobs = user.rejected_eobs + count_for_rejected_eobs
      user.update

      if count_for_rejected_eobs > 0
        job.rejections += 1
      end
      job.update
      user.compute_eob_accuracy

      #Job Status updating
      if @eobs.size > 0
        flag = 0
        comment = ''
        @eobs.each do |eob|
          if comment.nil?
            comment = eob.comment
          else
            if eob.status == 'Rejected'
              comment = eob.comment + '-' + comment
            end
          end
          if eob.status == 'Rejected'
            flag = 1
          end
        end
        if flag == 0
          job.qa_status = QaStatus['QA Complete'].to_s
          job.qa_flag_time = Time.now
          if job.processor_status == 'Processor Complete' || job.processor_status == 'Processor Incomplete'
            job.job_status = JobStatus['Complete'].to_s
          end
          if !job.incomplete_count.blank? and job.incomplete_count > 0
            if job.processor_status == 'Processor Complete' || job.processor_status == 'Processor Incomplete'
              job.job_status = JobStatus['New'].to_s
            end
          end
        else
          job.qa_status = QaStatus['QA Rejected'].to_s
          job.job_status = QaStatus['QA Rejected'].to_s
          job.comment = comment
        end
      else
        job.qa_status = QaStatus['QA Complete'].to_s
        job.qa_flag_time = Time.now
        if job.processor_status == 'Processor Complete' || job.processor_status == 'Processor Incomplete'
          job.job_status = JobStatus['Complete'].to_s
        end
      end

      if payer_flag == 1
        flash[:notice] = 'Payer ID invalid! Please reenter.'
        redirect_to :action => 'verify', :job => job
      elsif job.update
        flash[:notice] = 'Job was successfully updated.'
        # Updating the batch status
        batch = Batch.find(job.batch_id)
        batch.update_status
        redirect_to :action => 'my_job', :job => job
      else
        flash[:notice] = 'Job update failed'
        redirect_to :action => 'my_job', :job => job
      end
    end
  end

  def clear_verified_eobs
    job = Job.find(params[:job])
    #EobQa.delete_all(["job_id = ?" , job.id])
    redirect_to :action => 'verify', :job => job

    #TODO: remove when cron task for reset is added
    job.processor.reset_eob_qa_checked()
  end

  def verify
    @job = Job.find(params[:job])
    @user = Remittor.find(@job.processor_id)
    @eobs = @job.eob_qas
    @sample_rate = @user.sampling_rate()
    @error_types = EobError.find(:all)
  end

end
