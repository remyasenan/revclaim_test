# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class SqaController < ApplicationController
 
  layout 'standard'
  def my_job
    user = @user
    @jobs=Job.find_all_by_sqa_id(sqa_id =@user.id, :conditions => ["sqa_status = 'Processing'"])
    @job_count=Job.count(:conditions => "work_queue = 1 and sqa_status = 'New'")   
    @count=Job.count(:conditions => ["sqa_status = 'Processing' and sqa_id = ?", @user.id])
    #@value=SqaJobSetting.find_by_id(1)
    if @count == 0
      redirect_to :action => 'get_job'         
    else     
      render :action => 'my_job'
    end        
  end

  def get_job
    @work_queue = Job.count(:conditions => ["work_queue = 1 and sqa_status = 'New' and sqa_id = 0"])
    @job_count=Job.count(:conditions => "work_queue = 1 and sqa_status = 'New'")
    unless @work_queue == 0
      user = @user
      @count=Job.count(:conditions => ["sqa_status = 'Processing' and sqa_id = ?", @user.id])
      @value=SqaJobSetting.find_by_id(1)
      unless @count == @value.value       
        @job_new = Job.find(:first, :conditions => [ "work_queue = 1 and sqa_status = 'New'"] , :order => "work_queue_flagtime")         
        unless @job_new.nil?  
          @job=Job.find_by_id(@job_new.id)
          @job.sqa_id = @user.id
          @job.sqa_status = 'Processing'
          #@job.work_queue_flagtime = Time.now
          @job.update        
          redirect_to :action => 'get_job'
        else          
          redirect_to :action => 'my_job'
        end
      else
        redirect_to :action => 'my_job'
      end
    else   
      user = @user
      @jobs=Job.find_all_by_sqa_id(sqa_id =@user.id, :conditions => ["sqa_status = 'Processing'"])
      render :action => 'my_job'
    end

  end

  def eob_complete
    job = Job.find(params[:job])  
    eobs = job.eob_qas
    #payer = params[:payer][:id]
    # puts payer
    if(params[:eob][:total_fields].to_i < params[:eob][:total_incorrect_fields].to_i or params[:eob][:total_fields].to_i < 0 or params[:eob][:total_incorrect_fields].to_i < 0 )
      flash[:notice]  = '"Total Incorrect fields" count exceeds "Total fields" count'
      redirect_to :action => 'verify', :job => job.id 
    elsif (params[:eob][:total_eobs].to_i > eobs.count or params[:eob][:total_eobs].to_i < 0)
      flash[:notice]  = '"Total EOBs" count exceeds "Total EOBs Verified by QA" count'
      redirect_to :action => 'verify', :job => job.id 
    elsif (params[:eob][:total_eobs].to_i < params[:eob][:total_incorrect_eobs].to_i)
      flash[:notice]  = '"Total Incorrect EOBs" count exceeds "Total EOBs" count'
      redirect_to :action => 'verify', :job => job.id 
    else   
     
      eob = EobSqa.new(:total_fields => params[:eob][:total_fields], :total_incorrect_fields => params[:eob][:total_incorrect_fields], :error_id => EobError.find_by_error_type(params[:error][:type]).id,
        :job_id => job.id, :processor_id => job.processor_id, :qa_id => job.qa_id, :sqa_id => job.sqa_id , :sqa_flag_time => Time.now, :comments => params[:eob][:comment], :total_eobs => params[:eob][:total_eobs], :total_incorrect_eobs => params[:eob][:total_incorrect_eobs], :eob_comments => params[:eob][:eob_comment],:batch_date => job.batch.date ,:batch_id => job.batch.batchid )        
      unless eob.save
        flash[:notice] = eob.errors.entries[0] 
        redirect_to :action => 'verify', :job => job.id 
      else      
        user = User.find(job.qa_id)
        user.total_fields = user.total_fields + params[:eob][:total_fields].to_i
        user.total_incorrect_fields = user.total_incorrect_fields + params[:eob][:total_incorrect_fields].to_i
        user.eob_qa_checked = user.eob_qa_checked + params[:eob][:total_eobs].to_i
        user.total_eobs = user.total_eobs + params[:eob][:total_eobs].to_i
        user.rejected_eobs = user.rejected_eobs + params[:eob][:total_incorrect_eobs].to_i
        
        user.update
        user.sampling_rate
        
        # to store field accuracy for qa each time in EobSqa table
        super_qa_id = @user.id
        qas_id = job.qa_id
        sqa_job_id = job.id
        qa_job = EobSqa.find_by_job_id(sqa_job_id ,:conditions => ["sqa_id = '#{super_qa_id}' and qa_id = '#{qas_id}' and job_id = #{sqa_job_id}" ])
        qa_field_accuracy = user.field_accuracy
        qa_job.field_accuracy = qa_field_accuracy
        
        #computes eob accuracy for qa and stores in EobSqa  table
        user.compute_eob_accuracy
        qa_eob_accuracy = user.eob_accuracy
        qa_job.accuracy = qa_eob_accuracy
        qa_job.update
        
        job.sqa_status='Complete'
        job.update
        
        flash[:notice]  = "Job Successfully Updated"
        user = @user
        @jobs=Job.find_all_by_sqa_id(sqa_id =@user.id, :conditions => ["sqa_status = 'Processing'"])
        @job_count=Job.count(:conditions => "work_queue = 1 and sqa_status = 'New'")
        render :action => 'my_job'
      end        
    end 
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
          if job.processor_status == 'Processor Complete'
            job.job_status = JobStatus['Complete'].to_s
          end
          if !job.incomplete_count.blank? and job.incomplete_count > 0
            if job.processor_status == 'Processor Complete'
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
        if job.processor_status == 'Processor Complete'
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
    #job.processor.reset_eob_qa_checked()
  end



  def verify
    @job = Job.find(params[:job])
    @user = User.find(@job.qa_id)
    @eobs = @job.eob_qas
    @sample_rate = @user.sampling_rate()
    @error_types = EobError.find(:all)   
  end
  
end
