require  "will_paginate/array"
RAILS_PATH = "#{Rails.root}/"
class DatacapturesController < ApplicationController
 include AuthenticatedSystem
 include RoleRequirementSystem
  layout 'standard1',:except => [:patient_details_from_csv]
 require_role ["admin","Processor","QA","Supervisor"]
skip_before_filter  :verify_authenticity_token
  def frequent_837_output(batch)
    params[:batchid]=batch
    @batch=Batch.find(params[:batchid])
    @isa_identifier = IsaIdentifier.find(:first)
    id_837 = @isa_identifier.isa_number
    limit = 1000
    file_name = @batch.batchid
    #    offset=1
    #    @jobs = Job.find(:all, :conditions => ["batch_id = #{@batch.id} "])
    @jobs = Job.find(:all,:conditions=>"batch_id =#{params[:batchid]}",:select=>"max(sequence_id) seqid")
    @jobs.each do |t|
      @countval = t.seqid.to_i
    end
    @count_check = @countval%1000
    @count_segment = @countval/1000
    if @countval>0 and @count_check==0
      offset = (@count_segment-1)*1000
      #      limit = 10
      #      @cms1500s = @batch.cms1500s.find(:all,:conditions => ["(jobs.job_status='Complete')"], :order=>"jobs.sequence_id asc" , :offset=>offset , :limit=>limit)
      #      @cms1500s = @batch.cms1500s.find(:all,:conditions => ["(jobs.job_status='Complete')"], :order=>"jobs.tiff_number asc" , :offset=>offset , :limit=>limit)
      @cms1500s = Cms1500.find_by_sql("
      select * from(
      select cms1500s.*,jobs.tiff_number from jobs inner join cms1500s on jobs.id=cms1500s.job_id where jobs.job_status='complete' and jobs.batch_id=#{@batch.id} order by sequence_id  limit #{limit} offset #{offset})
      as sortjob order by sortjob.tiff_number")
      #      file_name = @batch.batchid
      cms=@count_segment-1
      template = ERB.new(File.open('app/views/admin/batch/837.txt.erb').read)
      File.open("public/data/#{file_name}." + sprintf('%03d', cms + 1) + ".837" , 'w') do |f|
        #        f.puts template.result(binding)
        output = template.result(binding)
        output.gsub!(/\s+$/, '')
        f.puts output
        offset=limit+offset
        @isa_identifier = IsaIdentifier.find(:first)
        @isa_identifier.isa_number = id_837
        @isa_identifier.save
      end
      @file_name_new = file_name+"."+sprintf('%03d',cms+1)+".837"
      Notifier.deliver_report_generation(@file_name_new)
    else
      @count_check = @countval%1000
      @job_complete=Job.find(:all,:conditions=>"batch_id =#{params[:batchid]} and job_status='Complete'")
      @job_incomplete=Job.find(:all,:conditions=>"batch_id =#{params[:batchid]} and job_status='Incomplete'")
      if @job_complete
        @completed_jobs= @job_complete.length
      else
        @completed_jobs=0
      end
      if @job_incomplete
        @incompleted_jobs=@job_incomplete.length
      else
        @incompleted_jobs=0
      end
      @total_job_completed = @completed_jobs + @incompleted_jobs
      #         if @batch.eob==@total_job_completed.to_i
      #           @job_completed_for_output=Job.find(:all,:conditions=>"batch_id =#{params[:batchid]} and job_status='Complete' and processor_status='Processor Complete' and qa_status='QA Complete'")
      #         end
      if (@countval>0 and @count_check>0) and(@batch.status=='Complete' or (@batch.eob==@total_job_completed))
        @count_check = @countval%1000
        @count_segment = (@countval/1000.0).ceil
        offset = (@count_segment-1)*1000
        @job_records = Job.find(:all,:conditions=>"batch_id =#{params[:batchid]}",:select=>"count(*) job_record")
        @job_records.each do |t|
          @max_job_record = t.job_record.to_i
        end
        @record_length = Job.find_by_sql("select count(id) from jobs where batch_id=#{@batch.id}")
        #             @cms1500s = @batch.cms1500s.find(:all,:conditions => ["(jobs.job_status='Complete')"], :order=>"jobs.sequence_id asc", :offset=>offset,:limit=>@count_check)
        #        @cms1500s = @batch.cms1500s.find(:all,:conditions => ["(jobs.job_status='Complete')"], :order=>"jobs.tiff_number asc", :offset=>offset,:limit=>@count_check)
        @cms1500s = Cms1500.find_by_sql("
          select * from(
          select cms1500s.*,jobs.tiff_number from jobs inner join cms1500s on jobs.id=cms1500s.job_id where jobs.job_status='complete' and jobs.batch_id=#{@batch.id} order by sequence_id  limit #{@max_job_record} offset #{offset})
          as sortjob order by sortjob.tiff_number")
        #      limit = 1000
        #      @cms1500s = @batch.cms1500s.find(:all,:conditions => ["(jobs.job_status='Complete')"], :order=>"jobs.sequence_id asc" , :offset=>offset)
        #      file_name = @batch.batchid
        cms=@count_segment-1
        template = ERB.new(File.open('app/views/admin/batch/837.txt.erb').read)
        File.open("public/data/#{file_name}." + sprintf('%03d', cms + 1) + ".837" , 'w') do |f|
          #        f.puts template.result(binding)
          output = template.result(binding)
          output.gsub!(/\s+$/, '')
          f.puts output
          offset=limit+offset
          @isa_identifier = IsaIdentifier.find(:first)
          @isa_identifier.isa_number = id_837
          @isa_identifier.save
        end
        @file_name_new = file_name+"."+sprintf('%03d',cms+1)+".837"
        Notifier.deliver_report_generation(@file_name_new)
        #        end

      end
    end
    #    respond_to do |format|
    #      format.html # index.html.erb
    #      format.xml  { render :xml => @cms1500s }
    #    end
  end

  def payer_informations
    payer = params[:payer]
    payer_based_informations = Payer.payer_details(payer)
    render :text => payer_based_informations
  end

  def provider_informations
    provider = params[:provider]
    provider_based_informations = Cms1500.provider_details(provider)
    render :text => provider_based_informations
  end

  def provider_organization_informations
    provider = params[:provider]
    provider_based_informations = Cms1500.provider_organization_details(provider)
    render :text => provider_based_informations
  end

  def service_facility_informations
    service_facility = params[:service_facility]
    service_facility_based_informations = Cms1500.service_facility_details(service_facility)
    render :text => service_facility_based_informations
  end


  def submit
#    is_new_post = true
#    session[:avoid_form_resubmit] = params[:avoid_form_resubmit]
#    if params[:avoid_form_resubmit] == session[:cms1500_csrf_token]
#      is_new_post = false
#    end
#    if is_new_post
#      session[:cms1500_csrf_token] = params[:avoid_form_resubmit]

  params[:proc_comments] = params[:comment] if params[:proc_comments] == "Other" 
  current_remittor = @user
 @cmsjobcount = Cms1500.count(:all, :conditions=>"job_id='#{params[:jobid]}'")
      Rails.logger.info "#{Time.now};jobid #{params[:jobid]};batchid #{params[:batchid]}test...."
      role=current_remittor.roles[0]
      current_user = current_remittor
      processor_status = Job.find_by_id(params[:jobid]).processor_status
      if params[:option1]=='Save'
        #checking whether the job is New/Rejected
        if @cmsjobcount > 0
          details = Cms1500.find_by_job_id(params[:jobid]).details.first
          #checking if the claim is OCR
            if details  != nil
              processor_update(params[:jobid])
            else
              processor_insert()
            end
        else
#          session[:jobid] = params[:jobid]
          processor_insert()
          @batch = Batch.find(params[:batchid])
          @jobinfo = Job.find(:all, :conditions=>"batch_id ='#{params[:batchid]}'", :select=>"max(sequence_id) seqid")
          @jobinfo.each do |t|
            @countval = t.seqid.to_i
          end
          @jobupdate = Job.find(params[:jobid])
          if @jobupdate.qa_status !="QA Allocated"
            @jobupdate.sequence_id = @countval +1
            @jobupdate.save
          end
          @job_complete=Job.find(:all, :conditions=>"batch_id ='#{params[:batchid]}' and job_status='Complete'")
          @job_incomplete=Job.find(:all, :conditions=>"batch_id ='#{params[:batchid]}' and job_status='Incomplete'")
          if @job_complete
            @completed_jobs= @job_complete.length
          else
            @completed_jobs=0
          end
          if @job_incomplete
            @incompleted_jobs=@job_incomplete.length
          else
            @incompleted_jobs=0
          end
          @total_job_completed = @completed_jobs + @incompleted_jobs
        end
      elsif params[:option1] == "Mark as Incomplete"
#        session[:jobid]=params[:jobid]
#        @cmsjobcount = Cms1500.count(:all, :conditions=>"job_id='#{params[:jobid]}'")
#  This will get messed up in case of mulitple claims save and incomplete
#        if @cmsjobcount > 0
#          processor_insert()
#        else
         
          @job=Job.find(params[:jobid])
          @job.processor_comments = params[:proc_comments]
          @job.job_status = JobStatus.find_by_name('Incomplete').name.to_s
          @job.processor_flag_time = Time.now
          @job.processor_status = ProcessorStatus.find_by_name('Processor Incomplete').name.to_s
          if role.name != 'Admin'
            @job.time_taken = params[:job1][:countr]
          end
          @job.save

          if params[:save_claim] == 'true'
            processor_insert()
          else
            update_jobs(@job)
          end
#         
#        end
#        if params[:option1]=="Mark as Incomplete"
#          @job=Job.find(session[:jobid])
#          @job.job_status = JobStatus['Incomplete'].to_s
#          @job.save
#        end
      elsif params[:option1] == "Complete"
        if @cmsjobcount > 0
#        params[:jobid]=session[:jobid]
    job = Job.find(params[:jobid])
    job.count = 1
    job.incomplete_count = 0
    job.time_taken = params[:job1][:countr]
    job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
#    if params[:option1] != "Save"
     job.processor_flag_time = Time.now
     job.processor_status = ProcessorStatus.find_by_name('Processor Complete').name.to_s
     if job.qa_id != nil
      if job.qa_status == 'QA Complete'
        job.job_status = JobStatus.find_by_name('Complete').name.to_s
        job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
      elsif job.qa_status == 'QA Rejected'
        job.qa_status = QaStatus.find_by_name('QA Allocated').name.to_s
      end
     else
      job.job_status = JobStatus.find_by_name('Complete').name.to_s
      job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
     end
#    end
    update_jobs(job)
       # processor_insert()
        else
          flash[:notice] = 'Please Save atleast one claim before Complete'
          redirect_to :back
        end
      end

      job = Job.find(params[:jobid])
      @batches_status_check= Batch.find(job.batch_id)
      completed_jobs_count= Job.find(:all, :conditions=>"batch_id= '#{params[:batchid]}' and job_status= 'Complete'").length
      incompleted_jobs_count= Job.find(:all, :conditions=>"batch_id= '#{params[:batchid]}' and job_status= 'Incomplete'").length
      total_jobs_count= @batches_status_check.jobs.count
      if total_jobs_count==completed_jobs_count or total_jobs_count==incompleted_jobs_count or total_jobs_count==incompleted_jobs_count+completed_jobs_count
        @batches_status_check.status="Complete"
        @batches_status_check.save
      end
      current_user.set_remark
#    else
#      flash[:form_resubmit]  = "This claim is in Completed status now. You cannot resave a claim unless it is allocated to you. Please inform Supervisor to allocate it"
#      redirect_to :back
#    end
  end


  def submit_ub04
    params[:ub04_claim_informations][:remarks] = params[:payer_details][:payer_name].to_s + "\n" + params[:payer_details][:payer_address1].to_s + "\n" + params[:payer_details][:payer_address2].to_s + "\n" + params[:payer_details][:payer_city].to_s + "\n" + params[:payer_details][:payer_state].to_s + "\n" + params[:payer_details][:payer_zipcode].to_s
    params[:ub04_claim_informations][:billing_provider_first_name] =  params[:billing_provider_details][:billing_provider_first_name]
    params[:ub04_claim_informations][:billing_provider_last_name]=params[:billing_provider_details][:billing_provider_last_name]
    params[:ub04_claim_informations][:billing_provider_address1]=  params[:billing_provider_details][:billing_provider_address1]
    params[:ub04_claim_informations][:billing_provider_address2]=  params[:billing_provider_details][:billing_provider_address2]
    params[:ub04_claim_informations][:billing_provider_city]=   params[:billing_provider_details][:billing_provider_city]
    params[:ub04_claim_informations][:billing_provider_state]=  params[:billing_provider_details][:billing_provider_state]
    params[:ub04_claim_informations][:billing_provider_zipcode]=  params[:billing_provider_details][:billing_provider_zipcode]
    params[:ub04_claim_informations][:billing_provider_telephone]=  params[:billing_provider_details][:billing_provider_telephone]
    params[:ub04_claim_informations][:billing_provider_tin_or_ein]=  params[:ub04_claim_informations][:billing_provider_tin_or_ein]
    params[:ub04_claim_informations][:billing_provider_npi]=  params[:ub04_claim_informations][:billing_provider_npi]
    params[:ub04_claim_informations][:rendering_provider_first_name] =  params[:rendering_provider_details][:rendering_provider_first_name]
    params[:ub04_claim_informations][:rendering_provider_last_name]=params[:rendering_provider_details][:rendering_provider_last_name]
    params[:ub04_claim_informations][:rendering_provider_address1]=  params[:rendering_provider_details][:rendering_provider_address1]
    params[:ub04_claim_informations][:rendering_provider_address2]=  params[:rendering_provider_details][:rendering_provider_address2]
    params[:ub04_claim_informations][:rendering_provider_city]=   params[:rendering_provider_details][:rendering_provider_city]
    params[:ub04_claim_informations][:rendering_provider_state]=  params[:rendering_provider_details][:rendering_provider_state]
    params[:ub04_claim_informations][:rendering_provider_zipcode]=  params[:rendering_provider_details][:rendering_provider_zipcode]
    is_new_post = true
    session[:avoid_form_resubmit] = params[:avoid_form_resubmit]
#    if params[:avoid_form_resubmit] == session[:csrf_token]
#      is_new_post = false
#    end
    
    params[:proc_comments] = params[:comment] if params[:proc_comments] == "Other" 

 @ub04jobcount = Ub04ClaimInformation.count(:all, :conditions=>"job_id = #{params[:jobid]}")
    if is_new_post
      session[:csrf_token] = params[:avoid_form_resubmit]

      role = current_remittor.roles[0]
      current_user = current_remittor
      if params[:option1] == 'Save'
        
        #checking whether the job is New/Rejected
        @job = Job.find(params[:jobid])
#      if @ub04jobcount > 0
#        if (!@job.processor_comments == 'null') || params[:admin_update] || @ub04jobcount > 0
        if (!@job.processor_comments.blank?) || params[:admin_update]
          ub04_processor_update(params[:jobid])
          @job = Job.find(params[:jobid])
          @job.processor_comments = params[:proc_comments]
          @job.save
        else
          ub04_processor_insert()
          #july 18
          @batch = Batch.find(params[:batchid])
          @jobinfo = Job.find(:all, :conditions=>"batch_id = #{params[:batchid]}", :select=>"max(sequence_id) seqid")
          @jobinfo.each do |t|
            @countval = t.seqid.to_i
          end
          @jobupdate = Job.find(params[:jobid])
          if @jobupdate.qa_status != "QA Allocated"
            @jobupdate.sequence_id = @countval +1
            @jobupdate.save
          end
          @job_complete = Job.find(:all, :conditions=>"batch_id = #{params[:batchid]} and job_status = 'Complete'")
          @job_incomplete = Job.find(:all, :conditions=>"batch_id = #{params[:batchid]} and job_status = 'Incomplete'")
          if @job_complete
            @completed_jobs = @job_complete.length
          else
            @completed_jobs = 0
          end
          if @job_incomplete
            @incompleted_jobs = @job_incomplete.length
          else
            @incompleted_jobs = 0
          end
          @total_job_completed = @completed_jobs + @incompleted_jobs
        end
      elsif params[:option1] == 'Mark as Incomplete'
       
        #checking whether the job is New/Rejected
        if @ub04jobcount > 0
          @job = Job.find(params[:jobid])
          if @job.processor_comments != nil || @ub04jobcount > 0
            @job.processor_comments = params[:proc_comments]
            @job.processor_flag_time = Time.now
            @job.processor_status = ProcessorStatus.find_by_name('Processor Incomplete').name.to_s
            @job.job_status = JobStatus.find_by_name('Incomplete').name.to_s
            @job.save
            if params[:save_claim] == 'true'
              ub04_processor_insert()
            else
              update_jobs(@job)
            end
          else
            @job = Job.find(params[:jobid])
            ubclaims = @job.ub04_claim_informations
            ubclaims.each do |ubclaim|
              ubclaim.destroy
            end
            @job.processor_comments = params[:proc_comments]
            @job.processor_flag_time = Time.now
            @job.job_status =  JobStatus.find_by_name('Incomplete').name.to_s
            @job.save
          end
        else
          @job = Job.find(params[:jobid])
          @job.processor_comments = params[:proc_comments]
          @job.processor_flag_time = Time.now
          @job.processor_status = ProcessorStatus.find_by_name('Processor Incomplete').name.to_s
          @job.job_status = JobStatus.find_by_name('Incomplete').name.to_s
          if role.name != 'Admin'
            @job.time_taken = params[:job1][:countr]
          end
          @job.save
          if params[:save_claim] == 'true'
            ub04_processor_insert()
          else
            update_jobs(@job)
          end
        end
      elsif params[:option1] == 'Complete'
#        ub04_processor_insert()
if @ub04jobcount > 0
    job = Job.find(params[:jobid])
    job.count = 1
    job.incomplete_count = 0
    job.time_taken = params[:job1][:countr]
    job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
#    if params[:option1] != "Save"
    job.processor_flag_time = Time.now
    job.processor_status = ProcessorStatus.find_by_name('Processor Complete').name.to_s
    if job.qa_id != nil
      if job.qa_status == 'QA Complete'
        job.job_status = JobStatus.find_by_name('Complete').name.to_s
        job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
      elsif job.qa_status == 'QA Rejected'
        job.qa_status = QaStatus.find_by_name('QA Allocated').name.to_s
      end
    elsif params[:option1]== "Complete"
      job.job_status = JobStatus.find_by_name('Complete').name.to_s
      job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
    else
      job.job_status = JobStatus.find_by_name('Incomplete').name.to_s
    end
#    end
    if UserPayerJobHistory.find_by_payer_id_and_user_id(job.payer.id, job.processor.id).nil?
      new_job_history = UserPayerJobHistory.new
      new_job_history.job_count = 1
      new_job_history.user_id = job.processor_id
      new_job_history.payer_id = job.payer_id
      new_job_history.save
    else
      job_history = UserPayerJobHistory.find_by_payer_id_and_user_id(job.payer.id, job.processor.id)
      job_history.job_count += 1
      job_history.save
    end
    @userclinetjobhistory = UserClientJobHistory.find(:first,:conditions=>"client_id='#{job.batch.facility.client.id}' and user_id='#{ job.processor.id}'")
    if @userclinetjobhistory.nil?
      new_client_history = UserClientJobHistory.new
      new_client_history.job_count = 1
      new_client_history.user_id = job.processor_id
      new_client_history.client_id = job.batch.facility.client_id
      new_client_history.save
    else
      client_history = @userclinetjobhistory
      client_history.job_count += 1
      client_history.save
    end
    update_jobs(job)
else
          flash[:notice] = 'Please Save atleast one claim before Complete'
          redirect_to :back
        end
      else
      end
      @batches_status_check= Batch.find(params[:batchid])
      completed_jobs_count= Job.find(:all, :conditions=>"batch_id= '#{params[:batchid]}' and job_status= 'Complete'").length
      incompleted_jobs_count= Job.find(:all, :conditions=>"batch_id= '#{params[:batchid]}' and job_status= 'Incomplete'").length
      total_jobs_count= @batches_status_check.jobs.count
      if total_jobs_count==completed_jobs_count or total_jobs_count==incompleted_jobs_count or total_jobs_count==incompleted_jobs_count+completed_jobs_count
        @batches_status_check.status="Complete"
        @batches_status_check.save
      end
      current_user.set_remark
    else
      flash[:form_resubmit]  = "This claim is in Completed status now. You cannot resave a claim unless it is allocated to you. Please inform Supervisor to allocate it"
      redirect_to :back
    end
  end
 

  def payer_informations_ub04

    payer=params[:payer].strip
    payer_id= payer.split("+").last
    payer_based_informations=PayerDetail.payer_details(payer_id)
    render :text => payer_based_informations
  end

  def provider_informations_ub04
    provider=params[:provider].strip
    provider_id = provider.split("+").last
    provider_based_informations=RenderingProviderDetail.provider_details(provider_id)
    render :text => provider_based_informations
  end

 def billing_provider_informations_ub04
    provider=params[:provider].strip
    provider_id = provider.split("+").last
    provider_based_informations=BillingProviderDetail.billing_provider_details(provider_id)
    render :text => provider_based_informations
  end

  def auto_complete_for_rendering_provider_details_rendering_provider_last_name
    @provider = RenderingProviderDetail.find(:all,:conditions =>["rendering_provider_last_name like ?","#{params[:rendering_provider_details][:rendering_provider_last_name]}%" ],:limit=>5)
    @provider_names = []
    @provider.collect {|x| @provider_names << x.rendering_provider_last_name.to_s + "+" + x.rendering_provider_address1.to_s + "+" + x.rendering_provider_city.to_s + "+" + x.rendering_provider_state.to_s + "+" + x.rendering_provider_zipcode.to_s + "+" + x.id.to_s }
    render :partial=>"auto_complete_for_rendering_provider_details_rendering_provider_last_name",:layout => false
  end

  def auto_complete_for_billing_provider_details_billing_provider_last_name
    @provider = BillingProviderDetail.find(:all,:conditions =>["billing_provider_last_name like ?","#{params[:billing_provider_details][:billing_provider_last_name]}%" ],:limit=>5)
    @provider_names = []
    @provider.collect {|x| @provider_names << x.billing_provider_last_name.to_s + "+" + x.billing_provider_address1.to_s+ "+" + x.billing_provider_address2.to_s + "+" + x.billing_provider_city.to_s + "+" + x.billing_provider_state.to_s + "+" + x.billing_provider_zipcode.to_s + "+" + x.id.to_s }
    render :partial=>"auto_complete_for_billing_provider_details_billing_provider_last_name",:layout => false
  end

  def auto_complete_for_payer_details_payer_name
    @payers = PayerDetail.find(:all,:conditions =>["payer_name like ?","#{params[:payer_details][:payer_name]}%" ],:limit=>5)
    @payer_names = []
    @payers.collect{|x| @payer_names << x.payer_name.to_s + "+" + x.payer_address1.to_s  + "+" + x.payer_address2.to_s + "+" + x.payer_city.to_s + "+" + x.payer_state.to_s + "+" + x.payer_zipcode.to_s + "+" + x.id.to_s }
    render :partial=>"auto_complete_for_payer_details_payer_name",:layout => false
  end



  def ub04_processor_update( job_id )
    @ub04_claims = Ub04ClaimInformation.find_by_job_id( job_id )
    params[:ub04_claim_informations][:statement_cover_from] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:statement_cover_from])
    params[:ub04_claim_informations][:statement_cover_to] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:statement_cover_to])
    patient_dob = params[:ub04_claim_informations][:patient_dob]
    params[:ub04_claim_informations][:patient_dob]  = "#{patient_dob.slice(4,4)}-#{patient_dob.slice(0,2)}-#{patient_dob.slice(2,2)}" if !patient_dob.blank? and  !patient_dob.nil?
    params[:ub04_claim_informations][:admission_date] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:admission_date] )
    params[:ub04_claim_informations][:creation_date] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:creation_date])
    params[:ub04_claim_informations][:principal_proc_date] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:principal_proc_date])
    for date_counter in 1..5
      params[:ub04_claim_informations][:"other_proc_date#{date_counter}"] = date_conversion_to_yy_mm_dd(params[:ub04_claim_informations][:"other_proc_date#{date_counter}"])
    end
    @ub04_claims.update_attributes(params[:ub04_claim_informations])
#    pat_id = params[:patient_id]
     pat_id = @ub04_claims.id
    @ub04_servicelines = Ub04ServicelineInformation.find(:all,:conditions=>"ub04_claim_information_id = #{pat_id}",:select => "id")
    if @ub04_servicelines.length != 0
      service_count = 0
      @ub04_servicelines.each do |ub04_serviceline|
        service_count = service_count + 1
        @ub04_serviceline = Ub04ServicelineInformation.find_by_id(ub04_serviceline.id)
        @ub04_serviceline.rev_code = params[:ub04_serviceline_informations][:"rev_code#{service_count}"]
        @ub04_serviceline.description = params[:ub04_serviceline_informations][:"description#{service_count}"]
        @ub04_serviceline.hcpcs =  params[:ub04_serviceline_informations][:"hcpcs#{service_count}"]
        @ub04_serviceline.rates =  params[:ub04_serviceline_informations][:"rates#{service_count}"]
        @ub04_serviceline.hipps_codes =  params[:ub04_serviceline_informations][:"hipps_codes#{service_count}"]
        @ub04_serviceline.modifier =  params[:ub04_serviceline_informations][:"modifier1#{service_count}"]
        @ub04_serviceline.modifier2 =  params[:ub04_serviceline_informations][:"modifier2#{service_count}"]
        @ub04_serviceline.modifier3 =  params[:ub04_serviceline_informations][:"modifier3#{service_count}"]
        @ub04_serviceline.modifier4 =  params[:ub04_serviceline_informations][:"modifier4#{service_count}"]
        @ub04_serviceline.service_date =  date_conversion_to_yy_mm_dd( params[:ub04_serviceline_informations][:"service_date#{service_count}"])
        @ub04_serviceline.service_units =  params[:ub04_serviceline_informations][:"service_units#{service_count}"]
        @ub04_serviceline.charges =  params[:ub04_serviceline_informations][:"charges#{service_count}"]
        @ub04_serviceline.non_covered_charges =  params[:ub04_serviceline_informations][:"non_covered_charges#{service_count}"]
        @ub04_serviceline.unlabel_49 =  params[:ub04_serviceline_informations][:"unlabel_49_#{service_count}"]
        @ub04_serviceline.save
        ############################################
      end#iterating
      add_serviceline_ub04(service_count,pat_id)
    else#checking is there any entry in cms1500serviceline
        insert_serviceline_ub04(pat_id)
    end#if ends
    #========= servicelines
    @occurences = Occurence.find(:all,:conditions => "ub04_claim_information_id = #{pat_id}",:select => "id")

    if @occurences.length != 0
      service_count = 0
      @occurences.each do |occurence|
        service_count = service_count + 1
        @occurence = Occurence.find_by_id(occurence.id)
        @occurence.code1 = params[:occurence][:"code#{service_count}"]
        @occurence.date1 =  date_conversion_to_yy_mm_dd( params[:occurence][:"date#{service_count}"])
        service_count = service_count + 1
        @occurence.code2 = params[:occurence][:"code#{service_count}"]
        @occurence.date2 =  date_conversion_to_yy_mm_dd( params[:occurence][:"date#{service_count}"])
        service_count = service_count + 1
        @occurence.code3 = params[:occurence][:"code#{service_count}"]
        @occurence.date3 =  date_conversion_to_yy_mm_dd(params[:occurence][:"date#{service_count}"])
        service_count = service_count + 1
        @occurence.code4 = params[:occurence][:"code#{service_count}"]
        @occurence.date4 =  date_conversion_to_yy_mm_dd( params[:occurence][:"date#{service_count}"])
        @occurence.save
        ############################################
      end#iterating
      add_occurences_ub04(service_count,pat_id)
    else#checking is there any entry in occurences
      insert_occurences_ub04(pat_id)
    end#if ends
    #=========occurence
    @occurence_spans = OccurenceSpan.find(:all,:conditions => "ub04_claim_information_id=#{pat_id}",:select => "id")
    if @occurence_spans.length != 0
      service_count = 0
      @occurence_spans.each do |occurence_span|
        service_count = service_count + 1
        @occurence_span = OccurenceSpan.find_by_id(occurence_span.id)
        @occurence_span.code1 = params[:occurence_span][:"code#{service_count}"]
        @occurence_span.from_date1 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"from_date#{service_count}"])
        @occurence_span.through_date1 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"through_date#{service_count}"])
        service_count = service_count + 1
        @occurence_span.code2 = params[:occurence_span][:"code#{service_count}"]
        @occurence_span.from_date2 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"from_date#{service_count}"])
        @occurence_span.through_date2 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"through_date#{service_count}"])
        @occurence_span.save
        ############################################
      end#iterating
      add_occurence_spans_ub04(service_count,pat_id)
    else#checking add_occurence_spans_ub04 is there any entry in occurence_spans
      insert_occurence_spans_ub04(pat_id)
    end#if ends
    #========= occurence_spans
    @qualifier_code_values = QualifierCodeValue.find(:all,:conditions => "ub04_claim_information_id = #{pat_id}",:select => "id")
    if @qualifier_code_values.length != 0
      service_count = 0
      @qualifier_code_values.each do |qualifier_code_value|
        service_count = service_count + 1
        @qualifier_code_value = QualifierCodeValue.find_by_id(qualifier_code_value.id)
        @qualifier_code_value.qualifier = params[:qualifier_code_value][:"qualifier#{service_count}"]
        @qualifier_code_value.code = params[:qualifier_code_value][:"code#{service_count}"]
        @qualifier_code_value.value = params[:qualifier_code_value][:"value#{service_count}"]
        @qualifier_code_value.save
        ############################################
      end#iterating
      add_qualfier_code_values_ub04(service_count,pat_id)
    else#checking is there any entry in qualifier code values
      insert_qualfier_code_values_ub04(pat_id)
    end#if ends
    #========= qualifier code values
    @value_codes = ValueCode.find(:all,:conditions => "ub04_claim_information_id = #{pat_id}",:select => "id")
    if @value_codes.length != 0
      service_count = 0
      @value_codes.each do |value_code|
        service_count = service_count + 1
        @value_code = ValueCode.find_by_id(value_code.id)
        @value_code.code1 = params[:value_code][:"code#{service_count}"]
        @value_code.amount1 = params[:value_code][:"amount#{service_count}"]
        service_count = service_count + 1
        @value_code.code2 = params[:value_code][:"code#{service_count}"]
        @value_code.amount2 = params[:value_code][:"amount#{service_count}"]
        service_count = service_count + 1
        @value_code.code3 = params[:value_code][:"code#{service_count}"]
        @value_code.amount3 = params[:value_code][:"amount#{service_count}"]
        @value_code.save
        ############################################
      end#iterating
      add_value_codes_ub04(service_count,pat_id)
    else#checking is there any entry in  value codes
      insert_value_codes_ub04(pat_id)
    end#if ends
    #=========  value codes
    @ub04payers = Ub04payer.find(:all,:conditions => "ub04_claim_information_id = #{pat_id}",:select => "id")
    if @ub04payers.length != 0
      service_count = 0
      @ub04payers.each do |ub04payer|
        service_count = service_count + 1
        @ub04payer = Ub04payer.find_by_id(ub04payer.id)
        @ub04payer.name = params[:ub04payer][:"name#{service_count}"]
        @ub04payer.health_planid = params[:ub04payer][:"health_planid#{service_count}"]
        @ub04payer.release_info = params[:ub04payer][:"release_info#{service_count}"]
        @ub04payer.assign_benefits = params[:ub04payer][:"assign_benefits#{service_count}"]
        @ub04payer.prior_payments = params[:ub04payer][:"prior_payments#{service_count}"]
        @ub04payer.est_amounts = params[:ub04payer][:"est_amounts#{service_count}"]
        @ub04payer.insured_first_name = params[:ub04payer][:"insured_first_name#{service_count}"]
        @ub04payer.insured_last_name = params[:ub04payer][:"insured_last_name#{service_count}"]
        @ub04payer.insured_middle_initial = params[:ub04payer][:"insured_middle_initial#{service_count}"]
        @ub04payer.patient_relationship = params[:ub04payer][:"patient_relationship#{service_count}"]
        @ub04payer.insured_id = params[:ub04payer][:"insured_id#{service_count}"]
        @ub04payer.group_name = params[:ub04payer][:"group_name#{service_count}"]
        @ub04payer.group_no = params[:ub04payer][:"group_no#{service_count}"]
        @ub04payer.treatment_authorisation = params[:ub04payer][:"treatment_authorisation#{service_count}"]
        @ub04payer.document_control_no = params[:ub04payer][:"document_control_no#{service_count}"]
        @ub04payer.employer_name = params[:ub04payer][:"employer_name#{service_count}"]
        @ub04payer.save
        ############################################
      end#iterating
      add_payer_ub04(service_count,pat_id)
    else#checking is there any entry in ub04payers
      insert_payer_ub04(pat_id)
    end#if ends
    #========= ub04payers
    job = Job.find(params[:jobid])
    job.count = 1
    job.incomplete_count = 0
    job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
    job.processor_flag_time = Time.now
    if job.processor_comments.nil?
      job.processor_status = ProcessorStatus['Processor Complete'].to_s   #  Doubt about the processor status - Processor Complete or Processor Incomplete need to check
    else
      job.processor_status = ProcessorStatus['Processor Incomplete'].to_s
    end
#    if job.qa_id != nil
#      if job.qa_status == 'QA Complete'
#        job.job_status = JobStatus['Complete'].to_s
#        job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
#      elsif job.qa_status == 'QA Rejected'
#        job.qa_status = QaStatus['QA Allocated'].to_s
#      elsif job.qa_status = 'QA InComplete' && params[:admin_update]
#        job.job_status = JobStatus['Complete'].to_s
#        job.qa_status = QaStatus['QA Complete'].to_s
#        job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
#      elsif job.qa_status == 'QA InComplete'
#        job.job_status = JobStatus['Incomplete'].to_s
#      end
#    elsif params[:option1]== "Complete"
#      job.job_status = JobStatus['Complete'].to_s
#      job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
#    else
#      job.job_status = JobStatus['Incomplete'].to_s
#    end
    @userpayerhistory = UserPayerJobHistory.find(:first,:conditions => "payer_id = '#{job.payer_id}'and user_id = '#{job.processor_id}'")
    if @userpayerhistory.nil?
      new_job_history = UserPayerJobHistory.new
      new_job_history.job_count = 1
      new_job_history.user_id = job.processor_id
      new_job_history.payer_id = job.payer_id
      new_job_history.save
    else
      job_history = @userpayerhistory
      job_history.job_count += 1
      job_history.save
    end
    @userclientjobhistory= UserClientJobHistory.find(:first,:conditions=>"client_id='#{job.batch.facility.client_id}'and user_id= '#{job.processor_id}'")
    if @userclientjobhistory.nil?
      new_client_history = UserClientJobHistory.new
      new_client_history.job_count = 1
      new_client_history.user_id = job.processor_id
      new_client_history.client_id = job.batch.facility.client_id
      new_client_history.save
    else
      client_history = @userclientjobhistory
      client_history.job_count += 1
      client_history.save
    end
    update_jobs(job)
  end#function ends

  def ub04_processor_insert()
    total_input_fields_with_data = 0
    params[:ub04_claim_informations][:job_id] = params[:jobid]
    params[:ub04_claim_informations][:statement_cover_from] = date_conversion_to_yy_mm_dd(params[:ub04_claim_informations][:statement_cover_from])
    params[:ub04_claim_informations][:statement_cover_to] = date_conversion_to_yy_mm_dd(params[:ub04_claim_informations][:statement_cover_to])
    patient_dob = params[:ub04_claim_informations][:patient_dob]
    params[:ub04_claim_informations][:patient_dob]  = "#{patient_dob.slice(4,4)}-#{patient_dob.slice(0,2)}-#{patient_dob.slice(2,2)}" if !patient_dob.blank? and !patient_dob.nil?
    params[:ub04_claim_informations][:admission_date] = date_conversion_to_yy_mm_dd(params[:ub04_claim_informations][:admission_date] )
    params[:ub04_claim_informations][:creation_date] = date_conversion_to_yy_mm_dd(params[:ub04_claim_informations][:creation_date])
    params[:ub04_claim_informations][:principal_proc_date] = date_conversion_to_yy_mm_dd(params[:ub04_claim_informations][:principal_proc_date])
    for date_counter in 1..5
      params[:ub04_claim_informations][:"other_proc_date#{date_counter}"] = date_conversion_to_yy_mm_dd(params[:ub04_claim_informations][:"other_proc_date#{date_counter}"])
    end
    #params[:ub04_claim_informations][:remarks] = params[:payer_name][:name].to_s + "\n" + params[:payer_address1][:address1].to_s + "\n" + params[:payer_address2][:address2].to_s + "\n" + params[:payer_city][:city].to_s + "\n" + params[:payer_state][:state].to_s + "\n" + params[:payer_zipcode][:zipcode].to_s
    @ub04_claim = Ub04ClaimInformation.create(params[:ub04_claim_informations])
    insert_serviceline_ub04(@ub04_claim.id)
    insert_occurences_ub04(@ub04_claim.id)
    insert_occurence_spans_ub04(@ub04_claim.id)
    insert_qualfier_code_values_ub04(@ub04_claim.id)
    insert_value_codes_ub04(@ub04_claim.id)
    insert_payer_ub04(@ub04_claim.id)
    total_input_fields_with_data += @ub04_claim.count_processor_input_claim_fields_ub04()+  @total_ub04_payer_fields_with_data + @total_qualifier_code_value_fields_with_data + @total_value_code_fields_with_data + @total_occurence_span_fields_with_data +  @total_occurence_fields_with_data + @total_serviceline_fields_with_data
    @ub04_claim.total_field_count = total_input_fields_with_data
    @ub04_claim.save
    #in order to complete job
    job = Job.find(params[:jobid])
    job.count = 1
    job.incomplete_count = 0
    job.time_taken = params[:job1][:countr]
    job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
#    if params[:option1] != "Save"
#    job.processor_flag_time = Time.now
#    job.processor_status = ProcessorStatus['Processor Complete'].to_s
#    if job.qa_id != nil
#      if job.qa_status == 'QA Complete'
#        job.job_status = JobStatus['Complete'].to_s
#        job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
#      elsif job.qa_status == 'QA Rejected'
#        job.qa_status = QaStatus['QA Allocated'].to_s
#      end
#    elsif params[:option1]== "Complete"
#      job.job_status = JobStatus['Complete'].to_s
#      job.estimated_eob = Ub04ClaimInformation.count(:all,:conditions=>"job_id = #{job.id}")
#    else
#      job.job_status = JobStatus['Incomplete'].to_s
#    end
#    end
    if UserPayerJobHistory.find_by_payer_id_and_user_id(job.payer.id, job.processor.id).nil?
      new_job_history = UserPayerJobHistory.new
      new_job_history.job_count = 1
      new_job_history.user_id = job.processor_id
      new_job_history.payer_id = job.payer_id
      new_job_history.save
    else
      job_history = UserPayerJobHistory.find_by_payer_id_and_user_id(job.payer.id, job.processor.id)
      job_history.job_count += 1
      job_history.save
    end
    @userclinetjobhistory = UserClientJobHistory.find(:first,:conditions=>"client_id='#{job.batch.facility.client.id}' and user_id='#{ job.processor.id}'")
    if @userclinetjobhistory.nil?
      new_client_history = UserClientJobHistory.new
      new_client_history.job_count = 1
      new_client_history.user_id = job.processor_id
      new_client_history.client_id = job.batch.facility.client_id
      new_client_history.save
    else
      client_history = @userclinetjobhistory
      client_history.job_count += 1
      client_history.save
    end
    update_jobs(job)
  end

  def update_jobs(job)
    role=@user.roles[0]
    job.update_attributes(params[:job])
    flash[:notice] = 'Job updated sucessfully'
    # Updating the batch status
    batch = job.batch
    batch.update_status
    @batchid=Job.find(job.id).batch_id
    @job = Job.find(job.id)


    user_id=@user.id
    if params[:allocation_status] == "1"
      @user.allocation_status = true
      @user.save
    end
    Job.auto_allocate_job(user_id)


    if params[:option1] == "Save"
      redirect_to :action=>"claim",:button_save => 1,:batchid=>@job.batch_id,:jobid=>@job.id, :batch_type => @job.batch.batchid
    else
      if role.name=="admin" or  role.name=='Supervisor'
        redirect_to :controller=>'admin/batch',:action => 'incompletedjobs',:id=>@batchid
      else
        @jobid = Job.find(:first,:conditions=>"processor_id=#{@user.id} and processor_status='Processor Allocated'",:select=>"id id ,batch_id batchid",:order=>"batch_id")
        if not @jobid.blank?
         auto_allocated_job = Batch.find(@jobid.batchid)
         redirect_to :controller => 'datacaptures', :action => 'claim',:batchid=>@jobid.batchid,:jobid=>@jobid.id, :batch_type=> auto_allocated_job.batchid
        else
          redirect_to :controller => 'processor', :action => 'my_job'
        end
      end
    end
  end

  def submit_claim
    @cmsinformation = Cms1500.new(params[:cms1500])
    @cmsinformation.payer_id = params[:payerid]
    @cmsinformation.job_id = params[:jobid]
    @cmsinformation.patient_dob = date_from_month_day_year(params[:month],params[:date],params[:year])
    @cmsinformation.patient_state = params[:state]
    @cmsinformation.reserved_local_use = params[:reserved_local_use]
    @cmsinformation.other_insured_dob = date_from_month_day_year(params[:cms15001][:other_dob_month],params[:cms15001][:other_dob_date],params[:cms15001][:other_dob_year])
    @cmsinformation.patient_signed_date = date_from_month_day_year(params[:cms15001][:signed_month],params[:cms15001][:signed_date],params[:cms15001][:signed_year])
    @cmsinformation.insured_state = params[:insured_state]
    @cmsinformation.insured_dob = date_from_month_day_year(params[:cms15001][:insured_dob_month],params[:cms15001][:insured_dob_date],params[:cms15001][:insured_dob_year])
    @cmsinformation.date_of_current_illness = date_from_month_day_year(params[:cms15001][:current_dob_month],params[:cms15001][:current_dob_date],params[:cms15001][:current_dob_year])
    @cmsinformation.first_date_similar_illness = date_from_month_day_year(params[:cms15001][:similarillness_dob_month],params[:cms15001][:similarillness_dob_date],params[:cms15001][:similarillness_dob_year])
    @cmsinformation.patient_unable_to_work_from_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_from_dob_month],params[:cms15001][:patient_unable_work_from_dob_date],params[:cms15001][:patient_unable_work_from_dob_year])
    @cmsinformation.patient_unable_to_work_to_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_to_dob_month],params[:cms15001][:patient_unable_work_to_dob_date],params[:cms15001][:patient_unable_work_to_dob_year])
    @cmsinformation.hospitalization_from_date = date_from_month_day_year(params[:cms15001][:hospitalization_from_month],params[:cms15001][:hospitalization_from_date],params[:cms15001][:hospitalization_from_year])
    @cmsinformation.hospitalization_to_date = date_from_month_day_year(params[:cms15001][:hospitalization_to_month],params[:cms15001][:hospitalization_to_date],params[:cms15001][:hospitalization_to_year])
    @cmsinformation.physician_sign_date = date_from_month_day_year(params[:cms15001][:physician_month],params[:cms15001][:physician_date],params[:cms15001][:physician_year])
    @cmsinformation.service_facility_state = params[:service_facility_state]
    @cmsinformation.billing_provider_state = params[:billing_prv_state]
    @cmsinformation.save
    @payer = Payer.new(:cms1500_id => @cmsinformation.id,:payer => params[:payer_name],:pay_address_one => params[:pay_add_one],:pay_address_two => params[:pay_add_two],:city => params[:payer_city],:state => params[:payer_state],:zipcode => params[:payer_zipcode])
    @payer.save(false)
    count =  params[:lineinformation][:count].to_i
    for i in 1 .. count
      @cmsserviceline = Cms1500serviceline.new
      @cmsserviceline.qual_id = params[:lineinformation]["id_qual1"+i.to_s]
      @cmsserviceline.rendering_provider_id =  params[:lineinformation]["rendering_provider_id1"+i.to_s]
      service_from_date_array=params[:lineinformation]["dateofservice_from"+i.to_s].split("/")
      service_from_date="#{service_from_date_array[1]}/#{service_from_date_array[0]}/#{service_from_date_array[2]}"
      service_to_date_array=params[:lineinformation]["dateofservice_to"+i.to_s].split("/")
      service_to_date="#{service_to_date_array[1]}/#{service_to_date_array[0]}/#{service_to_date_array[2]}"
      @cmsserviceline.service_from_date = service_from_date
      @cmsserviceline.service_to_date = service_to_date
      @cmsserviceline.service_place = params[:lineinformation]["placeof_service"+i.to_s]
      @cmsserviceline.emg =  params[:lineinformation]["emg"+i.to_s]
      @cmsserviceline.cpt_hcpcts =  params[:lineinformation]["cpthcpcs"+i.to_s]
      @cmsserviceline.modifier1 = params[:lineinformation]["modifier1"+i.to_s]
      @cmsserviceline.modifier2 = params[:lineinformation]["modifier2"+i.to_s]
      @cmsserviceline.modifier3 = params[:lineinformation]["modifier3"+i.to_s]
      @cmsserviceline.modifier4 = params[:lineinformation]["modifier4"+i.to_s]
      @cmsserviceline.diagnosis_pointer = params[:lineinformation]["diagnosis_pointer"+i.to_s]
      @cmsserviceline.charges = params[:lineinformation]["charges"+i.to_s]
      @cmsserviceline.days_units = params[:lineinformation]["days_or_units"+i.to_s]
      @cmsserviceline.minutes = params[:lineinformation]["minutes"+i.to_s]
      @cmsserviceline.epsdt = params[:lineinformation]["epsdt"+i.to_s]
      @cmsserviceline.family_plan = params[:lineinformation]["epsdt_familycharge2"+i.to_s]
      @cmsserviceline.rendering_provider_qualifier_npi_id =  params[:lineinformation]["rendering_provider_id2"+i.to_s]
      @cmsserviceline.cms1500_id = @cmsinformation.id
      @cmsserviceline.save
    end
    redirect_to :action => "claimqa",:job => params[:jobid],:payerid => params[:payerid]
  end
  def add_claim
      @error_type_new = EobError.find(:all)
      @state = State.find(:all).map{|f|f.state_code}
      @relationship_code = ["--", "01", "04", "05", "07", "09", "10", "15", "17", "18", "19", "20", "21", "22", "23", "24", "29", "32", "33", "34", "36", "39", "40", "41", "43", "53", "G8"]
      @errotypes=EobError.find(:all).map{|f|f.error_type}
      @jobid = params[:jobid]
      @job = Job.find(@jobid)
      @batchid = @job.batch.batchid



      @image = ImagesForJob.find(@job.images_for_job_id)
      session[:batchid] = @batchid
#      session[:jobid] = @jobid
  end

  def auto_complete_for_payer_name
    @payers = TypeaheadPayers.find(:all,:conditions =>['LOWER(payer) LIKE ?', "#{params[:payer][:name].downcase}%"],:limit=>10)
    render :layout => false
  end

  def auto_complete_for_cms1500_billing_provider_last_name
    @billing_providers = TypeaheadBillingProviders.find(:all,:conditions =>["billing_provider_last_name like ?","#{params[:cms1500][:billing_provider_last_name]}%"],:limit=>10)
    render :layout => false
  end


  def auto_complete_for_cms1500_service_facility_name
    @service_facilities = TypeaheadServiceFacilities.find(:all,:conditions =>["service_facility_name like ?","#{params[:cms1500][:service_facility_name]}%"],:limit=>10)
    render :layout => false
  end

  def auto_complete_for_cms1500_billing_provider_name
    @billing_providers = TypeaheadBillingProviders.find(:all,:conditions =>["billing_provider_name like ?","#{params[:cms1500][:billing_provider_name]}%"],:limit=>10)
    render :layout => false
  end


  def claim
  
    @ub04_incomplete_comment_list = ["--", "Total Charge Incorrect", "Negative Charge",
      "Invalid Format", "Partial Image", "Illegible Image", "Continued Page", 
      "A multi-page claim was scanned into two separate files"]
      
    @cms1500_incomplete_comment_list = ["--", "Missing CPT Code", "More than 50 service line",
        "Total Charge Incorrect", "Diagnosis code Missing", "Page 2 of 2", "Page 1 of 2", "Negative charge",
        "Continued page", "Invalid Format", "Partial Image", "Illegible Image", "From date missing",
        "Second page of claim does not match first page"]      
  
    if params[:patientid]
      patient_informations(params[:patientid])
    end
    if params[:button_save] == "1"

      @error_type_new = EobError.find(:all)
      @state = State.find(:all).map{|f|f.state_code}
      @relationship_code = ["--","01", "04", "05", "07", "08", "09", "10", "15", "17", "18", "19", "20", "21", "22", "23", "24", "29", "32", "33", "34", "36", "39", "40", "41", "43", "53", "G8"]
      @errotypes=EobError.find(:all).map{|f|f.error_type}
      @batchid = params[:batchid]
      @payerid = params[:payerid]
      @jobid = params[:jobid]
      @job = Job.find(@jobid)
      @pagecount = @job.page_count
      @image = ImagesForJob.find(@job.images_for_job_id)
      session[:batchid] = @batchid
      session[:payerid] = @payerid
#      session[:jobid] = @jobid

      unless @job.batch.batchid.upcase.include?("CMS1500")
          @patientinfo = Ub04ClaimInformation.find_by_job_id(params[:jobid])
          if @patientinfo
            @patientinfo = Ub04ClaimInformation.new
            @occurences = @patientinfo.occurences
            @occurence_spans = @patientinfo.occurence_spans
            @ub04_servicelines = @patientinfo.ub04_serviceline_informations
            @value_codes = @patientinfo.value_codes
            @qualifier_code_values = @patientinfo.qualifier_code_values
            @occurence_spans = @patientinfo.occurence_spans
            @occurences = @patientinfo.occurences
            @ub04payers = @patientinfo.ub04payers
#          else
#            @ub04_servicelines = @patientinfo.ub04_serviceline_informations
#            @value_codes = @patientinfo.value_codes
#            @qualifier_code_values = @patientinfo.qualifier_code_values
#            @occurence_spans = @patientinfo.occurence_spans
#            @occurences = @patientinfo.occurences
#            @ub04payers = @patientinfo.ub04payers
          end
        render :action => "claim_ub04" , :layout => "ub04"
      end

    else

      @error_type_new = EobError.find(:all)
      @state = State.find(:all).map{|f|f.state_code}
      @relationship_code = ["--", "01", "04", "05", "07", "08", "09", "10", "15", "17", "18", "19", "20", "21", "22", "23", "24", "29", "32", "33", "34", "36", "39", "40", "41", "43", "53", "G8"]
      @errotypes=EobError.find(:all).map{|f|f.error_type}
      @batchid = params[:batchid]
      @payerid = params[:payerid]
      @jobid = params[:jobid]
      @job = Job.find(@jobid)
      @job.processor_start_time = Time.now
      @job.save
      @pagecount = @job.page_count
      @image = ImagesForJob.find(@job.images_for_job_id)
      session[:batchid] = @batchid
      session[:payerid] = @payerid
#      session[:jobid] = @jobid
      if @job.batch.batchid.upcase.include?("CMS1500")
        @patientinfo = Cms1500.find_by_job_id(params[:jobid])
      else
#        @patientinfo = Ub04ClaimInformation.find_by_job_id(params[:jobid])
      end
      unless @patientinfo.blank? or @patientinfo.nil?
        if @job.batch.batchid.upcase.include?("CMS1500")
          @lineinfo = Cms1500serviceline.find(:all,:conditions=>"cms1500_id=#{@patientinfo.id}")
        else
          @ub04_servicelines = @patientinfo.ub04_serviceline_informations if @patientinfo
          @value_codes = @patientinfo.value_codes if @patientinfo
          @qualifier_code_values = @patientinfo.qualifier_code_values if @patientinfo
          @occurence_spans = @patientinfo.occurence_spans if @patientinfo
          @occurences = @patientinfo.occurences if @patientinfo
          @ub04payers = @patientinfo.ub04payers if @patientinfo
          render :action => "claim_ub04" , :layout => "ub04" if @patientinfo
        end
      else
        unless @job.batch.batchid.upcase.include?("CMS1500")
          @patientinfo = Ub04ClaimInformation.find_by_job_id(params[:jobid])
          @patientinfo = Ub04ClaimInformation.new unless @patientinfo
          @ub04_servicelines = @patientinfo.ub04_serviceline_informations
          @value_codes = @patientinfo.value_codes
          @qualifier_code_values = @patientinfo.qualifier_code_values
          @occurence_spans = @patientinfo.occurence_spans
          @occurences = @patientinfo.occurences
          @ub04payers = @patientinfo.ub04payers

         render :action => "claim_ub04" , :layout => "ub04"
        end
      end
    end
  end

  def claimqa
    @state=State.find(:all).map{|f|f.state_code}
    @errotypes=EobError.find(:all).map{|f|f.error_type}
    @relationship_code = ["--", "01", "04", "05", "07", "09", "10", "15", "17", "18","19", "20", "21", "22", "23", "24", "29", "32", "33", "34", "36", "39", "40", "41", "43", "53", "G8"]
    @placeofservice = ['','11','12','20','21','22','23','24','25','26','31','32','33','34','41','42','49','50','51','52','53','54','55','56','60','61','62','65','71','72','81','99']
    @batchid = params[:batchid]
    # @checknumber = params[:checknumber]
    @payerid = params[:payerid]
    @jobid = params[:job]
    session[:batchid] = @batchid
    #session[:checknumber] = @checknumber
    session[:payerid] = @payerid
#    session[:jobid] = @jobid
    @job = Job.find(params[:job])
    @image = ImagesForJob.find(@job.images_for_job_id)

    if @job.batch.batchid.upcase.include?("CMS1500")
     @error_type_new = EobError.find(:all)
      @patientinfo = Cms1500.find(:all, :conditions => ['job_id = ?', params[:job]]).paginate(:per_page => 1, :page => params[:page])
    else
      @error_type_new = EobError.find(:all)
      @patientinfo = Ub04ClaimInformation.find(:all, :conditions => ['job_id = ?', params[:job]]).paginate(:per_page => 1, :page => params[:page])
    end
    if @patientinfo.blank? or @patientinfo.nil?
      if @job.processor_status == 'Processor Incomplete'
        flash[:notice] = "Processor marked the job as incomplete and doesn't submit any claims"
      else
        flash[:notice] = "Processor did not complete the Job."
      end


      redirect_to :controller=>'qa',:action => 'my_job'
    else
      if @job.processor_status == 'Processor Incomplete'
        flash[:notice] = "Processor marked the job as incomplete"
        end
      if @job.batch.batchid.upcase.include?("CMS1500")
        @patientinfo.each do |patient_info|
        @lineinfo = Cms1500serviceline.find(:all,:conditions=>"cms1500_id=#{patient_info.id}")
        end
      else
        @patientinfo.each do |patient_info|
        @ub04_servicelines = patient_info.ub04_serviceline_informations if patient_info
        @value_codes = patient_info.value_codes if patient_info
        @qualifier_code_values = patient_info.qualifier_code_values if patient_info
        @occurence_spans = patient_info.occurence_spans if patient_info
        @occurences = patient_info.occurences if patient_info
        @ub04payers = patient_info.ub04payers if patient_info
        end
        render :action => "claimqa_ub04" , :layout => "ub04" if @patientinfo

      end
    end
  end
  
  def updateqa_ub04
    current_user = current_remittor
    if params[:option1] == "Update" || params[:option1] == "Save claim"
    params[:batchid]=Job.find(params[:jobid]).batch.id
    @user = current_remittor
    @total_count_claim = 0
    @total_count_service_line = 0
    @total_count_occurences = 0
    @total_count_occurence_spans = 0
    @total_count_qualifier_code_values = 0
    @total_count_value_codes = 0
    @total_count_ub04payers = 0
    @ub04_claims = Ub04ClaimInformation.find(:all, :conditions => ['job_id = ? and id = ?',params[:jobid],params[:patient_id]])
    @ub04_claims.each do |ub04claims|
    params[:ub04_claim_informations][:billing_provider_first_name] = params[:billing_provider_details][:billing_provider_first_name]
    params[:ub04_claim_informations][:billing_provider_last_name] = params[:billing_provider_details][:billing_provider_last_name]
    params[:ub04_claim_informations][:billing_provider_address1] = params[:billing_provider_details][:billing_provider_address1]
    params[:ub04_claim_informations][:billing_provider_address2] = params[:billing_provider_details][:billing_provider_address2]
    params[:ub04_claim_informations][:billing_provider_city] = params[:billing_provider_details][:billing_provider_city]
    params[:ub04_claim_informations][:billing_provider_state] = params[:billing_provider_details][:billing_provider_state]
    params[:ub04_claim_informations][:billing_provider_zipcode] = params[:billing_provider_details][:billing_provider_zipcode]
    params[:ub04_claim_informations][:billing_provider_telephone] = params[:billing_provider_details][:billing_provider_telephone]
#    params[:ub04_claim_informations][:billing_provider_npi] =  params[:ub04_claim_informations][:billing_provider_npi]
#    params[:ub04_claim_informations][:billing_providerid1] =  params[:ub04_claim_informations][:billing_providerid1]
#    params[:ub04_claim_informations][:billing_providerid2] =  params[:ub04_claim_informations][:billing_providerid2]
#    params[:ub04_claim_informations][:billing_providerid3] =  params[:ub04_claim_informations][:billing_providerid3]
    params[:ub04_claim_informations][:rendering_provider_last_name] = params[:rendering_provider_details][:rendering_provider_last_name]
    params[:ub04_claim_informations][:rendering_provider_address1] = params[:rendering_provider_details][:rendering_provider_address1]
    params[:ub04_claim_informations][:rendering_provider_address2]=  params[:rendering_provider_details][:rendering_provider_address2]
    params[:ub04_claim_informations][:rendering_provider_city] = params[:rendering_provider_details][:rendering_provider_city]
    params[:ub04_claim_informations][:rendering_provider_state] = params[:rendering_provider_details][:rendering_provider_state]
    params[:ub04_claim_informations][:rendering_provider_zipcode] = params[:rendering_provider_details][:rendering_provider_zipcode]

    params[:ub04_claim_informations][:statement_cover_from] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:statement_cover_from])
    params[:ub04_claim_informations][:statement_cover_to] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:statement_cover_to])
    patient_dob = params[:ub04_claim_informations][:patient_dob]
    params[:ub04_claim_informations][:patient_dob]  = "#{patient_dob.slice(4,4)}-#{patient_dob.slice(0,2)}-#{patient_dob.slice(2,2)}" if !patient_dob.blank? and  !patient_dob.nil?
    params[:ub04_claim_informations][:admission_date] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:admission_date] )
    params[:ub04_claim_informations][:creation_date] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:creation_date])
    params[:ub04_claim_informations][:principal_proc_date] = date_conversion_to_yy_mm_dd( params[:ub04_claim_informations][:principal_proc_date])
    for date_counter in 1..5
      params[:ub04_claim_informations][:"other_proc_date#{date_counter}"] = date_conversion_to_yy_mm_dd(params[:ub04_claim_informations][:"other_proc_date#{date_counter}"])
    end
    params[:ub04_claim_informations][:attending_npi] = params[:ub04_claim_informations][:attending_npi]
    params[:ub04_claim_informations][:attending_qual] = params[:ub04_claim_informations][:attending_qual]
    params[:ub04_claim_informations][:attendingid] = params[:ub04_claim_informations][:attendingid]
    params[:ub04_claim_informations][:attending_provider_last_name] = params[:ub04_claim_informations][:attending_provider_last_name]
    params[:ub04_claim_informations][:attending_provider_first_name] = params[:ub04_claim_informations][:attending_provider_first_name]
    params[:ub04_claim_informations][:operating_npi] = params[:ub04_claim_informations][:operating_npi]
    params[:ub04_claim_informations][:operating_qual] = params[:ub04_claim_informations][:operating_qual]
    params[:ub04_claim_informations][:operatingid] = params[:ub04_claim_informations][:operatingid]
    params[:ub04_claim_informations][:operating_provider_last_name] = params[:ub04_claim_informations][:operating_provider_last_name]
    params[:ub04_claim_informations][:operating_provider_first_name] = params[:ub04_claim_informations][:operating_provider_first_name]
    params[:ub04_claim_informations][:other_npi1] = params[:ub04_claim_informations][:other_npi1]
    params[:ub04_claim_informations][:other_qual1] = params[:ub04_claim_informations][:other_qual1]
    params[:ub04_claim_informations][:otherid1] = params[:ub04_claim_informations][:otherid1]
    params[:ub04_claim_informations][:other_provider_last_name1] = params[:ub04_claim_informations][:other_provider_last_name1]
    params[:ub04_claim_informations][:other_provider_first_name1] = params[:ub04_claim_informations][:other_provider_first_name1]
    params[:ub04_claim_informations][:other_npi2] = params[:ub04_claim_informations][:other_npi2]
    params[:ub04_claim_informations][:other_qual2] = params[:ub04_claim_informations][:other_qual2]
    params[:ub04_claim_informations][:otherid2] = params[:ub04_claim_informations][:otherid2]
    params[:ub04_claim_informations][:other_provider_last_name2] = params[:ub04_claim_informations][:other_provider_last_name2]
    params[:ub04_claim_informations][:other_provider_first_name2] = params[:ub04_claim_informations][:other_provider_first_name2]
    params[:ub04_claim_informations][:remarks]  = params[:payer_name][:name]+"\n"+params[:payer_address1][:address1]+"\n"+params[:payer_address2][:address2]+"\n"+params[:payer_city][:city]+"\n"+params[:payer_state][:state]+"\n"+params[:payer_zipcode][:zipcode]
    @total_count_claim += ub04claims.count_processor_input_claim_fields_ub04()
    
    pat_id = params[:patient_id]
    @ub04_servicelines = Ub04ServicelineInformation.find(:all,:conditions=>"ub04_claim_information_id=#{pat_id}",:select=>"id")
    if @ub04_servicelines.length!=0
      service_count = 0
      @ub04_servicelines.each do |ub04_serviceline|
        service_count = service_count + 1
        @ub04_serviceline = Ub04ServicelineInformation.find_by_id(ub04_serviceline.id)
        if !params[:ub04_serviceline_informations][:"rev_code#{service_count}"].blank? && !params[:ub04_serviceline_informations][:"charges#{service_count}"].blank?
        @ub04_serviceline.rev_code = params[:ub04_serviceline_informations][:"rev_code#{service_count}"]
        @ub04_serviceline.description = params[:ub04_serviceline_informations][:"description#{service_count}"]
        @ub04_serviceline.hcpcs =  params[:ub04_serviceline_informations][:"hcpcs#{service_count}"]
        @ub04_serviceline.rates =  params[:ub04_serviceline_informations][:"rates#{service_count}"]
        @ub04_serviceline.hipps_codes =  params[:ub04_serviceline_informations][:"hipps_codes#{service_count}"]
        @ub04_serviceline.modifier =  params[:ub04_serviceline_informations][:"modifier1#{service_count}"]
        @ub04_serviceline.modifier2 =  params[:ub04_serviceline_informations][:"modifier2#{service_count}"]
        @ub04_serviceline.modifier3 =  params[:ub04_serviceline_informations][:"modifier3#{service_count}"]
        @ub04_serviceline.modifier4 =  params[:ub04_serviceline_informations][:"modifier4#{service_count}"]
        @ub04_serviceline.service_date =  date_conversion_to_yy_mm_dd( params[:ub04_serviceline_informations][:"service_date#{service_count}"])
        @ub04_serviceline.service_units =  params[:ub04_serviceline_informations][:"service_units#{service_count}"]
        @ub04_serviceline.charges =  params[:ub04_serviceline_informations][:"charges#{service_count}"]
        @ub04_serviceline.non_covered_charges =  params[:ub04_serviceline_informations][:"non_covered_charges#{service_count}"]
        @ub04_serviceline.unlabel_49 =  params[:ub04_serviceline_informations][:"unlabel_49_#{service_count}"]
        @total_count_service_line += @ub04_serviceline.count_processor_input_claim_serviceline_fields_ub04()
        else
          @total_count_service_line += @ub04_serviceline.count_processor_input_claim_serviceline_fields_ub04()
           @ub04_serviceline.destroy()
        end
        @ub04_serviceline.save unless Ub04ServicelineInformation.find_by_id(@ub04_serviceline).blank?
        ############################################
      end#iterating
      add_serviceline_ub04(service_count,pat_id)
    else#checking is there any entry in cms1500serviceline
      unless params[:ub04_serviceline_informations].nil? #work around Ticket #24912
        insert_serviceline_ub04(pat_id)
      end
    end#if ends
    #========= servicelines
    @occurences = Occurence.find(:all,:conditions=>"ub04_claim_information_id=#{pat_id}",:select=>"id")
    if @occurences.length!=0
      service_count = 0
      @occurences.each do |occurence|
        service_count = service_count + 1
        @occurence = Occurence.find_by_id(occurence.id)
        @occurence.code1 = params[:occurence][:"code#{service_count}"]
        @occurence.date1 =  date_conversion_to_yy_mm_dd( params[:occurence][:"date#{service_count}"])
        service_count = service_count + 1
        @occurence.code2 = params[:occurence][:"code#{service_count}"]
        @occurence.date2 =  date_conversion_to_yy_mm_dd( params[:occurence][:"date#{service_count}"])
        service_count = service_count + 1
        @occurence.code3 = params[:occurence][:"code#{service_count}"]
        @occurence.date3 =  date_conversion_to_yy_mm_dd(params[:occurence][:"date#{service_count}"])
        service_count = service_count + 1
        @occurence.code4 = params[:occurence][:"code#{service_count}"]
        @occurence.date4 =  date_conversion_to_yy_mm_dd( params[:occurence][:"date#{service_count}"])
        @total_count_occurences += @occurence.count_processor_input_ub04_occurence_fields()
        @occurence.save
        ############################################
      end#iterating
      add_occurences_ub04(service_count,pat_id)
    else#checking is there any entry in occurences
      insert_occurences_ub04(pat_id)
    end#if ends
    #=========occurence
    @occurence_spans = OccurenceSpan.find(:all,:conditions=>"ub04_claim_information_id=#{pat_id}",:select=>"id")
    if @occurence_spans.length!=0
      service_count = 0
      @occurence_spans.each do |occurence_span|
        service_count = service_count + 1
        @occurence_span = OccurenceSpan.find_by_id(occurence_span.id)
        @occurence_span.code1 = params[:occurence_span][:"code#{service_count}"]
        @occurence_span.from_date1 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"from_date#{service_count}"])
        @occurence_span.through_date1 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"through_date#{service_count}"])
        service_count = service_count + 1
        @occurence_span.code2 = params[:occurence_span][:"code#{service_count}"]
        @occurence_span.from_date2 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"from_date#{service_count}"])
        @occurence_span.through_date2 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"through_date#{service_count}"])
        @total_count_occurence_spans += @occurence_span.count_processor_input_ub04_occurence_span_fields()
        @occurence_span.save
        ############################################
      end#iterating
      add_occurence_spans_ub04(service_count,pat_id)
    else#checking add_occurence_spans_ub04 is there any entry in occurence_spans
      insert_occurence_spans_ub04(pat_id)
    end#if ends
    #========= occurence_spans
    @qualifier_code_values = QualifierCodeValue.find(:all,:conditions=>"ub04_claim_information_id=#{pat_id}",:select=>"id")
    if @qualifier_code_values.length!=0
      service_count = 0
      @qualifier_code_values.each do |qualifier_code_value|
        service_count = service_count + 1
        @qualifier_code_value = QualifierCodeValue.find_by_id(qualifier_code_value.id)
        @qualifier_code_value.qualifier = params[:qualifier_code_value][:"qualifier#{service_count}"]
        @qualifier_code_value.code = params[:qualifier_code_value][:"code#{service_count}"]
        @qualifier_code_value.value = params[:qualifier_code_value][:"value#{service_count}"]
        @total_count_qualifier_code_values  += @qualifier_code_value.count_processor_input_ub04_qualifier_code_value_fields()
        @qualifier_code_value.save
        ############################################
      end#iterating
      add_qualfier_code_values_ub04(service_count,pat_id)
    else#checking is there any entry in qualifier code values
      insert_qualfier_code_values_ub04(pat_id)
    end#if ends
    #========= qualifier code values
    @value_codes = ValueCode.find(:all,:conditions=>"ub04_claim_information_id=#{pat_id}",:select=>"id")
    if @value_codes.length!=0
      service_count = 0
      @value_codes.each do |value_code|
        service_count = service_count + 1
        @value_code = ValueCode.find_by_id(value_code.id)
        @value_code.code1 = params[:value_code][:"code#{service_count}"]
        @value_code.amount1 = params[:value_code][:"amount#{service_count}"]
        service_count = service_count + 1
        @value_code.code2 = params[:value_code][:"code#{service_count}"]
        @value_code.amount2 = params[:value_code][:"amount#{service_count}"]
        service_count = service_count + 1
        @value_code.code3 = params[:value_code][:"code#{service_count}"]
        @value_code.amount3 = params[:value_code][:"amount#{service_count}"]
        @total_count_value_codes += @value_code.count_processor_input_value_code_fields()
        @value_code.save
        ############################################
      end#iterating
      add_value_codes_ub04(service_count,pat_id)
    else#checking is there any entry in  value codes
      insert_value_codes_ub04(pat_id)
    end#if ends
    #=========  value codes
    @ub04payers = Ub04payer.find(:all,:conditions=>"ub04_claim_information_id=#{pat_id}",:select=>"id")
    if @ub04payers.length!=0
      service_count = 0
      @ub04payers.each do |ub04payer|
        service_count = service_count + 1
        @ub04payer = Ub04payer.find_by_id(ub04payer.id)
        @ub04payer.name = params[:ub04payer][:"name#{service_count}"]
        @ub04payer.health_planid = params[:ub04payer][:"health_planid#{service_count}"]
        @ub04payer.release_info = params[:ub04payer][:"release_info#{service_count}"]
        @ub04payer.assign_benefits = params[:ub04payer][:"assign_benefits#{service_count}"]
        @ub04payer.prior_payments = params[:ub04payer][:"prior_payments#{service_count}"]
        @ub04payer.est_amounts = params[:ub04payer][:"est_amounts#{service_count}"]
        @ub04payer.insured_first_name = params[:ub04payer][:"insured_first_name#{service_count}"]
        @ub04payer.insured_last_name = params[:ub04payer][:"insured_last_name#{service_count}"]
        @ub04payer.insured_middle_initial = params[:ub04payer][:"insured_middle_initial#{service_count}"]
        @ub04payer.patient_relationship = params[:ub04payer][:"patient_relationship#{service_count}"]
        @ub04payer.insured_id = params[:ub04payer][:"insured_id#{service_count}"]
        @ub04payer.group_name = params[:ub04payer][:"group_name#{service_count}"]
        @ub04payer.group_no = params[:ub04payer][:"group_no#{service_count}"]
        @ub04payer.treatment_authorisation = params[:ub04payer][:"treatment_authorisation#{service_count}"]
        @ub04payer.document_control_no = params[:ub04payer][:"document_control_no#{service_count}"]
        @ub04payer.employer_name = params[:ub04payer][:"employer_name#{service_count}"]
        @ub04payer.release_info = params[:ub04payer][:"release_info#{service_count}"]
        @ub04payer.assign_benefits = params[:ub04payer][:"assign_benefits#{service_count}"]
        @total_count_ub04payers += @ub04payer.count_processor_input_ub04_payer_fields()
        @ub04payer.save
        ############################################
      end

    #iterating
      add_payer_ub04(service_count,pat_id)
    else#checking is there any entry in ub04payers
      insert_payer_ub04(pat_id)
    end#if ends
totalfields = @total_count_claim.to_i + @total_count_service_line.to_i + @total_count_occurences.to_i + @total_count_occurence_spans.to_i + @total_count_value_codes.to_i + @total_count_ub04payers.to_i + @total_count_qualifier_code_values.to_i

  if params[:view] == "completed_claim"
      params[:ub04_claim_informations][:total_field_count] = totalfields
  else
      params[:ub04_claim_informations][:total_field_count] = params[:eobqa][:total_field_count] rescue nil
  end
    ub04claims.update_attributes(params[:ub04_claim_informations])
        
    end
    #========= ub04payers
    job = Job.find(params[:jobid])
     @batch = Batch.find(job.batch_id)
    if params[:option1] == "Save claim"

     redirect_to :controller => 'datacaptures',:action => 'claimqa',:batchid => params[:batchid],:job => job,:view => params[:view]
#     redirect_to :controller=>'datacaptures',:action => 'claim', :jobid => job, :batch_type => @batch.batchid

    elsif params[:option1] == "Update"
      
    params[:ub04_claim_informations][:remarks] = params[:payer_name][:name].to_s + "\n" + params[:payer_address1][:address1].to_s + "\n" + params[:payer_address2][:address2].to_s + "\n" + params[:payer_city][:city].to_s + "\n" + params[:payer_state][:state].to_s + "\n" + params[:payer_zipcode][:zipcode].to_s

    if params[:status] == "Incomplete" or params[:status] == "Reject"
      @job = Job.find(params[:jobid])
      @job.processor_comments = params[:qa_comments] if params[:qa_comments]
      @job.qa_status = QaStatus.find_by_name('QA Complete').name.to_s
      @job.job_status = 'Incomplete'
      @job.qa_comment = params[:qa_comments]
      @job.save
    end

    puts' Starts the Qa JOB Now'
    temp= params[:pro_error_type]
    incorrect_no = params[:eobqa][:total_incorrect_fields]
    if temp.blank? or  incorrect_no.blank?
      if temp.blank? and  incorrect_no.blank?
        flash[:notice] = 'Please Select an Error Type. and Enter Incorrect Fileds '
      elsif temp.blank?
        flash[:notice] = 'Please Select an Error Type. '
      else
        flash[:notice] = 'Enter Incorrect Fileds '
      end
      # Updating the batch status
      redirect_to :controller=>'datacaptures',:action => 'claimqa', :job => job, :batchid => job.batch.batchid, :batch_type=> job.batch.batchid, :view => params[:view]
    else
      errors =[]
      errors  =  params[:pro_error_type][:id]
      for k in 0..errors.length-1
        jobid= params[:jobid]
        #qaid=@user.id
        processorid =job.processor_id
        qaid=job.qa_id
        timeofrejection = Time.now
        totalfields = @total_count_claim.to_i + @total_count_service_line.to_i + @total_count_occurences.to_i + @total_count_occurence_spans.to_i + @total_count_value_codes.to_i + @total_count_ub04payers.to_i + @total_count_qualifier_code_values.to_i
        accuracy = @user.field_accuracy
        #facility = EobError.find_by_id(e).error_type
        eoberrorid = EobError.find(:first,:conditions=>"error_type='#{errors[k]}'").id
        if params[:status] == 'Complete'
          status = "Accepted"
          prevstatus = "new"
        elsif params[:status] == 'Reject'
          status = "Rejected"
          prevstatus = "new"
        else
          status = "Incomplete"
          prevstatus = "new"
        end
        @eobqa = EobQa.new(:job_id=> jobid,:qa_id=> qaid ,:processor_id=>processorid,:time_of_rejection=> timeofrejection,:total_fields=> totalfields,:comment => params[:qa_comments],:total_incorrect_fields => params[:eobqa][:total_incorrect_fields],:status=>status,:prev_status=>prevstatus,:accuracy=>accuracy,:payer=>1,:eob_error_id=>eoberrorid)
        @eobqa.save
        #facility = EobError.find_by_id(e).error_type
      end
      unless @eobqa.save
        flash[:notice] = @claimqa.errors.entries[0]
      else
        #User details updating
        user = Remittor.find(job.processor_id)
        qa= Remittor.find(job.qa_id)
        user.total_fields = user.total_fields + @total_count_claim.to_i + @total_count_service_line.to_i + @total_count_occurences.to_i + @total_count_occurence_spans.to_i + @total_count_value_codes.to_i + @total_count_ub04payers.to_i + @total_count_qualifier_code_values.to_i
        user.total_incorrect_fields = user.total_incorrect_fields + params[:eobqa][:total_incorrect_fields].to_i
        user.eob_qa_checked = user.eob_qa_checked + 1
        user.save
      end
      job = Job.find(params[:jobid])
      @batch = Batch.find(job.batch_id)
      count_for_rejected_eobs = 0
      payer_flag = 0
      #Entry in eob report
      @eobs = EobQa.find(:all,:conditions=>"job_id='#{params[:jobid]}'")
      #Count the errors in eob_qa
      @eobs1 = EobQa.count(params[:jobid])
      #Allow update only when eob info is available
      if @eobs.blank? or @eobs1 == 0
        flash[:notice] = "No verified/rejected EOB found. Add and resubmit."
        redirect_to :action => 'claimqa', :job => job, :batchid => job.batch.batchid, :view => params[:view]
      else
        @eobs.each do |eob|
          if eob.prev_status != "old"
            EobReport.create(:verify_time => eob.time_of_rejection,:processor => user.login, :accuracy => eob.accuracy,
              :qa => qa.login, :batch_id => job.batch.id, :batch_date => job.batch.date, :total_fields => eob.total_fields,
              :incorrect_fields => eob.total_incorrect_fields, :error_type => eob.eob_error.error_type, :error_severity => eob.eob_error.severity,
              :error_code => eob.eob_error.code, :status => eob.status, :payer => eob.payer )
            if eob.total_incorrect_fields > 0
              count_for_rejected_eobs += 1
            end
          end
          eob.prev_status = "old"
          eob.save
        end
        user = @user
        #if job rejections > 0, do not recount the eob count
        if job.rejections == 0
          user.total_eobs = user.total_eobs.to_i+ job.count.to_i
        end
        #rejected_eobs is the count of eobs with incorrect fields >= 1)
        user.rejected_eobs = user.rejected_eobs.to_i + count_for_rejected_eobs
        user.save
        job.save
        #Job Status updating
        #Find the maximum of the Id from the eob_qa,So that to find the last entry in rejected/accepted
        @eob_max = EobQa.find(:all,:conditions=>"job_id=#{params[:jobid]}",:group=>"job_id",:select=>"max(id) id")
        @eob_max.each do |claim|
          @eobw = EobQa.find(:all,:conditions=>"id=#{claim.id}")
        end
        if @eobs1.size > 0
          flag = 0
          comment = ''
          @eobw.each do |eob|
            if comment.nil?
              comment = eob.comment
            else
              if eob.status == 'Rejected'
                comment = eob.comment + '-' + comment
              end
            end
            if eob.status == 'Rejected'
              flag = 1
            else if eob.status == 'Incomplete'
                flag = 2
              end
            end
          end
          if flag == 0
            job.qa_status = QaStatus.find_by_name('QA Complete').name.to_s
            job.qa_flag_time = Time.now
            @jobinfo = Job.find(:all,:conditions=>"batch_id =#{job.batch_id}",:select=>"max(sequence_id) seqid")
            @jobinfo.each do |t|
              @countval = t.seqid.to_i
            end
            #@jobupdate = Job.find(params[:jobid])
            #if @jobupdate.qa_status !="QA Allocated"
            job.sequence_id = @countval +1
            # @jobupdate.update
            #end
            if job.processor_status == 'Processor Complete' || job.processor_status == 'Processor Incomplete'
              job.job_status = JobStatus.find_by_name('Complete').name.to_s
            end
            if !job.incomplete_count.blank? and job.incomplete_count > 0
              if job.processor_status == 'Processor Complete' || job.processor_status == 'Processor Incomplete'
                job.job_status = JobStatus.find_by_name('New').name.to_s
              end
            end
          else if flag == 1
              job.qa_status = QaStatus.find_by_name('QA Rejected').name.to_s
              job.job_status = QaStatus.find_by_name('QA Rejected').name.to_s
              job.rejected_comment = comment
            else
              job.qa_status = QaStatus.find_by_name('QA Incomplete').name.to_s
              job.job_status = 'Incomplete'
              job.qa_comment = params[:qa_comments]
            end
          end
        else
          job.qa_status = QaStatus.find_by_name('QA Complete').name.to_s
          job.qa_flag_time = Time.now
          if job.processor_status == 'Processor Complete' || job.processor_status == 'Processor Incomplete'
            job.job_status = JobStatus.find_by_name('Complete').name.to_s
          end
        end
        if job.save
          flash[:notice] = 'Job saved successfully'
          # Updating the batch status
          batch = Batch.find(job.batch_id)
          batch.update_status
          @job_complete=Job.find(:all,:conditions=>"batch_id =#{@batch.id} and job_status='Complete'")
          @job_incomplete=Job.find(:all,:conditions=>"batch_id =#{@batch.id} and job_status='Incomplete'")
          if @job_complete
            @completed_jobs= @job_complete.length
          else
            @completed_jobs=0
          end
          if @job_incomplete
            @incompleted_jobs=@job_incomplete.length
          else
            @incompleted_jobs=0
          end
          @total_job_completed = @completed_jobs + @incompleted_jobs
          redirect_to :controller=>'qa',:action => 'my_job', :job => job
        else
          flash[:notice] = 'Job update failed'
          redirect_to :controller=>'qa', :action => 'my_job', :job => job
        end
      end
    end
    @batches_status_check= Batch.find(params[:batchid])
    completed_jobs_count= Job.find(:all,:conditions=>"batch_id= '#{params[:batchid]}' and job_status= 'Complete'").length
    incompleted_jobs_count= Job.find(:all,:conditions=>"batch_id= '#{params[:batchid]}' and job_status= 'Incomplete'").length
    total_jobs_count= @batches_status_check.jobs.count
    if total_jobs_count==completed_jobs_count or total_jobs_count==incompleted_jobs_count or total_jobs_count==incompleted_jobs_count+completed_jobs_count
      @batches_status_check.status="Complete"
      @batches_status_check.save
    end
    current_user.set_remark
    end
  elsif params[:option1] == "Delete claim"
    Ub04ClaimInformation.destroy_all(["id=?",params[:patient_id]])
    job = Job.find(params[:jobid])
    claim_count = job.estimated_eob
    job.estimated_eob = claim_count-1
    job.save
     redirect_to :controller => 'datacaptures',:action => 'claimqa',:batchid => params[:batchid],:job => job,:view => params[:view]
    #redirect_to :controller=>'datacaptures',:action => 'claim', :jobid => job, :batch_type => @batch.batchid
  end
  end

  def add_serviceline_ub04(service_count,claim_id)
    service_count = service_count + 1
    if service_count != 1
      while service_count<=1000
        if (!(params[:ub04_serviceline_informations][:"rev_code#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"description#{service_count}"].blank?)or !(params[:ub04_serviceline_informations][:"hcpcs#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"rates#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"hipps_codes#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"service_date#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"service_units#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"charges#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"non_covered_charges#{service_count}"].blank?))
          @ub04_serviceline = Ub04ServicelineInformation.new
          @ub04_serviceline.rev_code = params[:ub04_serviceline_informations][:"rev_code#{service_count}"]
          @ub04_serviceline.description = params[:ub04_serviceline_informations][:"description#{service_count}"]
          @ub04_serviceline.hcpcs =  params[:ub04_serviceline_informations][:"hcpcs#{service_count}"]
          @ub04_serviceline.rates =  params[:ub04_serviceline_informations][:"rates#{service_count}"]
          @ub04_serviceline.hipps_codes =  params[:ub04_serviceline_informations][:"hipps_codes#{service_count}"]
          @ub04_serviceline.modifier =  params[:ub04_serviceline_informations][:"modifier1#{service_count}"]
          @ub04_serviceline.modifier2 =  params[:ub04_serviceline_informations][:"modifier2#{service_count}"]
          @ub04_serviceline.modifier3 =  params[:ub04_serviceline_informations][:"modifier3#{service_count}"]
          @ub04_serviceline.modifier4 =  params[:ub04_serviceline_informations][:"modifier4#{service_count}"]
          @ub04_serviceline.service_date =  date_conversion_to_yy_mm_dd( params[:ub04_serviceline_informations][:"service_date#{service_count}"])
          @ub04_serviceline.service_units =  params[:ub04_serviceline_informations][:"service_units#{service_count}"]
          @ub04_serviceline.charges =  params[:ub04_serviceline_informations][:"charges#{service_count}"]
          @ub04_serviceline.non_covered_charges =  params[:ub04_serviceline_informations][:"non_covered_charges#{service_count}"]
          @ub04_serviceline.unlabel_49 =  params[:ub04_serviceline_informations][:"unlabel_49_#{service_count}"]
          @ub04_serviceline.ub04_claim_information_id = claim_id
          @ub04_serviceline.save
        end#checkiing the
        service_count = service_count+1
      end
    end
  end

  def insert_serviceline_ub04(claim_id)
    @total_serviceline_fields_with_data = 0
   rowcount = params[:ub04_serviceline_informations][:rowcount].to_i
    for service_count in 1 .. rowcount
      if (!(params[:ub04_serviceline_informations][:"rev_code#{service_count}"].blank?)or !(params[:ub04_serviceline_informations][:"description#{service_count}"].blank?)or !(params[:ub04_serviceline_informations][:"hcpcs#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"rates#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"hipps_codes#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"service_date#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"service_units#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"charges#{service_count}"].blank?) or !(params[:ub04_serviceline_informations][:"non_covered_charges#{service_count}"].blank?))
        @ub04_serviceline = Ub04ServicelineInformation.new
        @ub04_serviceline.rev_code = params[:ub04_serviceline_informations][:"rev_code#{service_count}"]
        @ub04_serviceline.description = params[:ub04_serviceline_informations][:"description#{service_count}"]
        @ub04_serviceline.hcpcs =  params[:ub04_serviceline_informations][:"hcpcs#{service_count}"]
        @ub04_serviceline.rates =  params[:ub04_serviceline_informations][:"rates#{service_count}"]
        @ub04_serviceline.hipps_codes =  params[:ub04_serviceline_informations][:"hipps_codes#{service_count}"]
        @ub04_serviceline.modifier =  params[:ub04_serviceline_informations][:"modifier1#{service_count}"]
        @ub04_serviceline.modifier2 =  params[:ub04_serviceline_informations][:"modifier2#{service_count}"]
        @ub04_serviceline.modifier3 =  params[:ub04_serviceline_informations][:"modifier3#{service_count}"]
        @ub04_serviceline.modifier4 =  params[:ub04_serviceline_informations][:"modifier4#{service_count}"]
        @ub04_serviceline.service_date =  date_conversion_to_yy_mm_dd( params[:ub04_serviceline_informations][:"service_date#{service_count}"])
        @ub04_serviceline.service_units =  params[:ub04_serviceline_informations][:"service_units#{service_count}"]
        @ub04_serviceline.charges =  params[:ub04_serviceline_informations][:"charges#{service_count}"]
        @ub04_serviceline.non_covered_charges =  params[:ub04_serviceline_informations][:"non_covered_charges#{service_count}"]
        @ub04_serviceline.unlabel_49 =  params[:ub04_serviceline_informations][:"unlabel_49_#{service_count}"]
        @ub04_serviceline.ub04_claim_information_id = claim_id
        @total_serviceline_fields_with_data += @ub04_serviceline.count_processor_input_claim_serviceline_fields_ub04()
        @ub04_serviceline.save
      end#checking moratory fileds
    end
  end

  def add_occurences_ub04(service_count,claim_id)

    while service_count<=2
      if (!( params[:occurence][:"code#{4*service_count+1}"].blank?)or !(params[:occurence][:"date#{4*service_count+1}"].blank?)or !( params[:occurence][:"code#{4*service_count+2}"].blank?) or !(params[:occurence][:"date#{4*service_count+2}"].blank?) or !( params[:occurence][:"code#{4*service_count+3}"].blank?) or !(params[:occurence][:"date#{4*service_count+3}"].blank?) or !( params[:occurence][:"code#{4*service_count+4}"].blank?) or !(params[:occurence][:"code#{4*service_count+4}"].blank?) )
        @occurence = Occurence.new
        @occurence.code1 = params[:occurence][:"code#{4*service_count+1}"]
        @occurence.date1 = date_conversion_to_yy_mm_dd( params[:occurence][:"date#{4*service_count+1}"])
        @occurence.code2 = params[:occurence][:"code#{4*service_count+2}"]
        @occurence.date2 = date_conversion_to_yy_mm_dd( params[:occurence][:"date#{4*service_count+2}"])
        @occurence.code3 = params[:occurence][:"code#{4*service_count+3}"]
        @occurence.date3 = date_conversion_to_yy_mm_dd( params[:occurence][:"date#{4*service_count+3}"])
        @occurence.code4 = params[:occurence][:"code#{4*service_count+4}"]
        @occurence.date4 = date_conversion_to_yy_mm_dd( params[:occurence][:"date#{4*service_count+4}"])
        @occurence.ub04_claim_information_id = claim_id
        @occurence.save
      end#checkiing the
      service_count = service_count + 1
    end
  end

  def insert_occurences_ub04(claim_id)
    @total_occurence_fields_with_data = 0
    for service_count in 0 .. 1
      if (!( params[:occurence][:"code#{4*service_count+1}"].blank?)or !(params[:occurence][:"date#{4*service_count+1}"].blank?)or !( params[:occurence][:"code#{4*service_count+2}"].blank?) or !(params[:occurence][:"date#{4*service_count+2}"].blank?) or !( params[:occurence][:"code#{4*service_count+3}"].blank?) or !(params[:occurence][:"date#{4*service_count+3}"].blank?) or !( params[:occurence][:"code#{4*service_count+4}"].blank?) or !(params[:occurence][:"code#{4*service_count+4}"].blank?) )
        @occurence = Occurence.new
        @occurence.code1 = params[:occurence][:"code#{4*service_count+1}"]
        @occurence.date1 = date_conversion_to_yy_mm_dd( params[:occurence][:"date#{4*service_count+1}"])
        @occurence.code2 = params[:occurence][:"code#{4*service_count+2}"]
        @occurence.date2 = date_conversion_to_yy_mm_dd( params[:occurence][:"date#{4*service_count+2}"])
        @occurence.code3 = params[:occurence][:"code#{4*service_count+3}"]
        @occurence.date3 = date_conversion_to_yy_mm_dd( params[:occurence][:"date#{4*service_count+3}"])
        @occurence.code4 = params[:occurence][:"code#{4*service_count+4}"]
        @occurence.date4 = date_conversion_to_yy_mm_dd( params[:occurence][:"date#{4*service_count+4}"])
        @occurence.ub04_claim_information_id = claim_id
        @total_occurence_fields_with_data += @occurence.count_processor_input_ub04_occurence_fields()
        @occurence.save
      end#checking moratory fileds
    end
  end


  def add_occurence_spans_ub04(service_count,claim_id)
    while service_count<=2
      if (!( params[:occurence_span][:"code#{2*service_count+1}"].blank?)or !(params[:occurence_span][:"from_date#{2*service_count+1}"].blank?)or !(params[:occurence_span][:"through_date#{2*service_count+1}"].blank?) or !(params[:occurence_span][:"code#{2*service_count+2}"].blank?) or !( params[:occurence_span][:"from_date#{2*service_count+2}"].blank?) or !( params[:occurence_span][:"through_date#{2*service_count+2}"].blank?) )
        @occurence = OccurenceSpan.new
        @occurence_span.code1 = params[:occurence_span][:"code#{2*service_count+1}"]
        @occurence_span.from_date1 = date_conversion_to_yy_mm_dd( params[:occurence_span][:"from_date#{2*service_count+1}"])
        @occurence_span.through_date1 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"through_date#{2*service_count+1}"])
        @occurence_span.code2 = params[:occurence_span][:"code#{2*service_count+2}"]
        @occurence_span.from_date2 = date_conversion_to_yy_mm_dd( params[:occurence_span][:"from_date#{2*service_count+2}"])
        @occurence_span.through_date2 =  date_conversion_to_yy_mm_dd(params[:occurence_span][:"through_date#{2*service_count+2}"])
        @occurence_span.ub04_claim_information_id = claim_id
        @occurence_span.save
      end#checkiing the
      service_count = service_count + 1
    end
  end

  def  insert_occurence_spans_ub04(claim_id)
    @total_occurence_span_fields_with_data = 0
    for service_count in 0 .. 1
      if (!( params[:occurence_span][:"code#{2*service_count+1}"].blank?)or !(params[:occurence_span][:"from_date#{2*service_count+1}"].blank?)or !(params[:occurence_span][:"through_date#{2*service_count+1}"].blank?) or !(params[:occurence_span][:"code#{2*service_count+2}"].blank?) or !( params[:occurence_span][:"from_date#{2*service_count+2}"].blank?) or !( params[:occurence_span][:"through_date#{2*service_count+2}"].blank?) )
        @occurence_span = OccurenceSpan.new
        @occurence_span.code1 = params[:occurence_span][:"code#{2*service_count+1}"]
        @occurence_span.from_date1 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"from_date#{2*service_count+1}"])
        @occurence_span.through_date1 = date_conversion_to_yy_mm_dd( params[:occurence_span][:"through_date#{2*service_count+1}"])
        @occurence_span.code2 = params[:occurence_span][:"code#{2*service_count+2}"]
        @occurence_span.from_date2 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"from_date#{2*service_count+2}"])
        @occurence_span.through_date2 =  date_conversion_to_yy_mm_dd( params[:occurence_span][:"through_date#{2*service_count+2}"])
        @occurence_span.ub04_claim_information_id = claim_id
        @total_occurence_span_fields_with_data += @occurence_span.count_processor_input_ub04_occurence_span_fields()
        @occurence_span.save
      end#checking moratory fileds
    end
  end

  def add_value_codes_ub04(service_count,claim_id)

    while service_count<=4
      if (!( params[:value_code][:"code#{3*service_count+1}"].blank?)or !(params[:value_code][:"amount#{3*service_count+1}"].blank?)or !(params[:value_code][:"code#{3*service_count+2}"].blank?) or !(params[:value_code][:"amount#{3*service_count+2}"].blank?) or !( params[:value_code][:"code#{3*service_count+3}"].blank?) or !( params[:value_code][:"amount#{3*service_count+3}"].blank?) )
        @value_code = ValueCode.new
        @value_code.code1 = params[:value_code][:"code#{3*service_count+1}"]
        @value_code.amount1 =   params[:value_code][:"amount#{3*service_count+1}"]
        @value_code.code2 = params[:value_code][:"code#{3*service_count+2}"]
        @value_code.amount2  =params[:value_code][:"amount#{3*service_count+2}"]
        @value_code.code3 =  params[:value_code][:"code#{3*service_count+3}"]
        @value_code.amount3  = params[:value_code][:"amount#{3*service_count+3}"]
        @value_code.ub04_claim_information_id = claim_id
        @value_code.save
      end#checkiing the
      service_count = service_count + 1
    end
  end

  def  insert_value_codes_ub04(claim_id)
     @total_value_code_fields_with_data = 0
    for service_count in 0 .. 3
      if (!( params[:value_code][:"code#{3*service_count+1}"].blank?)or !(params[:value_code][:"amount#{3*service_count+1}"].blank?)or !(params[:value_code][:"code#{3*service_count+2}"].blank?) or !(params[:value_code][:"amount#{3*service_count+2}"].blank?) or !( params[:value_code][:"code#{3*service_count+3}"].blank?) or !( params[:value_code][:"amount#{3*service_count+3}"].blank?) )
        @value_code = ValueCode.new
        @value_code.code1 = params[:value_code][:"code#{3*service_count+1}"]
        @value_code.amount1 = params[:value_code][:"amount#{3*service_count+1}"]
        @value_code.code2 =  params[:value_code][:"code#{3*service_count+2}"]
        @value_code.amount2 = params[:value_code][:"amount#{3*service_count+2}"]
        @value_code.code3 =  params[:value_code][:"code#{3*service_count+3}"]
        @value_code.amount3 =params[:value_code][:"amount#{3*service_count+3}"]
        @value_code.ub04_claim_information_id = claim_id
        @total_value_code_fields_with_data += @value_code.count_processor_input_value_code_fields()
        @value_code.save
      end#checking moratory fileds
    end
  end


  def add_qualfier_code_values_ub04(service_count,claim_id)
    while service_count<=4
      service_count = service_count + 1
      if (!( params[:qualifier_code_value][:"qualifier#{service_count}"].blank?)or !(params[:qualifier_code_value][:"code#{service_count}"].blank?)or !(params[:qualifier_code_value][:"value#{service_count}"].blank?)  )
        @qualifier_code_value = QualifierCodeValue.new
        @qualifier_code_value.qualifier = params[:qualifier_code_value][:"qualifier#{service_count}"]
        @qualifier_code_value.code = params[:qualifier_code_value][:"code#{service_count}"]
        @qualifier_code_value.value =  params[:qualifier_code_value][:"value#{service_count}"]
        @qualifier_code_value.ub04_claim_information_id = claim_id
        @qualifier_code_value.save
      end#checkiing the
    end
  end

  def  insert_qualfier_code_values_ub04(claim_id)
    @total_qualifier_code_value_fields_with_data = 0
    for service_count in 1 .. 4
      if (!( params[:qualifier_code_value][:"qualifier#{service_count}"].blank?)or !(params[:qualifier_code_value][:"code#{service_count}"].blank?)or !(params[:qualifier_code_value][:"value#{service_count}"].blank?)  )
        @qualifier_code_value = QualifierCodeValue.new
        @qualifier_code_value.qualifier = params[:qualifier_code_value][:"qualifier#{service_count}"]
        @qualifier_code_value.code = params[:qualifier_code_value][:"code#{service_count}"]
        @qualifier_code_value.value =  params[:qualifier_code_value][:"value#{service_count}"]
        @qualifier_code_value.ub04_claim_information_id = claim_id
        @total_qualifier_code_value_fields_with_data += @qualifier_code_value.count_processor_input_ub04_qualifier_code_value_fields()
        @qualifier_code_value.save
      end#checking moratory fileds
    end
  end

  def add_payer_ub04(service_count,claim_id)
    while service_count<=3
      service_count = service_count + 1
      if (!( params[:ub04payer][:"name#{service_count}"].blank?) or !(params[:ub04payer][:"health_planid#{service_count}"].blank?) or !(params[:ub04payer][:"release_info#{service_count}"].blank?) or !(params[:ub04payer][:"assign_benefits#{service_count}"].blank?) or  !(params[:ub04payer][:"prior_payments#{service_count}"].blank? or !(params[:ub04payer][:"est_amounts#{service_count}"].blank?) or !(params[:ub04payer][:"insured_first_name#{service_count}"].blank?) or !(params[:ub04payer][:"insured_last_name#{service_count}"].blank?) or  !(params[:ub04payer][:"patient_relationship#{service_count}"].blank?) or params[:ub04payer][:"insured_id#{service_count}"].blank?) or  !(params[:ub04payer][:"group_name#{service_count}"].blank?) or !(params[:ub04payer][:"group_no#{service_count}"].blank?) or !(params[:ub04payer][:"treatment_authorisation#{service_count}"].blank?) or !(params[:ub04payer][:"name#{service_count}"].blank?) or !(params[:ub04payer][:"employer_name#{service_count}"].blank?))
        @ub04payer = Ub04payer.new
        @ub04payer.name = params[:ub04payer][:"name#{service_count}"]
        @ub04payer.health_planid = params[:ub04payer][:"health_planid#{service_count}"]
        @ub04payer.release_info = params[:ub04payer][:"release_info#{service_count}"]
        @ub04payer.assign_benefits = params[:ub04payer][:"assign_benefits#{service_count}"]
        @ub04payer.prior_payments = params[:ub04payer][:"prior_payments#{service_count}"]
        @ub04payer.est_amounts = params[:ub04payer][:"est_amounts#{service_count}"]
        @ub04payer.insured_first_name = params[:ub04payer][:"insured_first_name#{service_count}"]
        @ub04payer.insured_last_name = params[:ub04payer][:"insured_last_name#{service_count}"]
        @ub04payer.insured_middle_initial = params[:ub04payer][:"insured_middle_initial#{service_count}"]
        @ub04payer.patient_relationship = params[:ub04payer][:"patient_relationship#{service_count}"]
        @ub04payer.insured_id = params[:ub04payer][:"insured_id#{service_count}"]
        @ub04payer.group_name = params[:ub04payer][:"group_name#{service_count}"]
        @ub04payer.group_no = params[:ub04payer][:"group_no#{service_count}"]
        @ub04payer.treatment_authorisation = params[:ub04payer][:"treatment_authorisation#{service_count}"]
        @ub04payer.document_control_no = params[:ub04payer][:"document_control_no#{service_count}"]
        @ub04payer.employer_name = params[:ub04payer][:"employer_name#{service_count}"]
        @ub04payer.ub04_claim_information_id = claim_id
        @ub04payer.save
      end
    end
  end

  def  insert_payer_ub04(claim_id)
    @total_ub04_payer_fields_with_data = 0
    for service_count in 1 .. 3
      if (!( params[:ub04payer][:"name#{service_count}"].blank?) or !(params[:ub04payer][:"health_planid#{service_count}"].blank?) or !(params[:ub04payer][:"release_info#{service_count}"].blank?) or !(params[:ub04payer][:"assign_benefits#{service_count}"].blank?) or  !(params[:ub04payer][:"prior_payments#{service_count}"].blank? or !(params[:ub04payer][:"est_amounts#{service_count}"].blank?) or !(params[:ub04payer][:"insured_first_name#{service_count}"].blank?) or !(params[:ub04payer][:"insured_last_name#{service_count}"].blank?) or  !(params[:ub04payer][:"patient_relationship#{service_count}"].blank?) or params[:ub04payer][:"insured_id#{service_count}"].blank?) or  !(params[:ub04payer][:"group_name#{service_count}"].blank?) or !(params[:ub04payer][:"group_no#{service_count}"].blank?) or !(params[:ub04payer][:"treatment_authorisation#{service_count}"].blank?) or !(params[:ub04payer][:"name#{service_count}"].blank?) or !(params[:ub04payer][:"employer_name#{service_count}"].blank?))
        @ub04payer = Ub04payer.new
        @ub04payer.name = params[:ub04payer][:"name#{service_count}"]
        @ub04payer.health_planid = params[:ub04payer][:"health_planid#{service_count}"]
        @ub04payer.release_info = params[:ub04payer][:"release_info#{service_count}"]
        @ub04payer.assign_benefits = params[:ub04payer][:"assign_benefits#{service_count}"]
        @ub04payer.prior_payments = params[:ub04payer][:"prior_payments#{service_count}"]
        @ub04payer.est_amounts = params[:ub04payer][:"est_amounts#{service_count}"]
        @ub04payer.insured_first_name = params[:ub04payer][:"insured_first_name#{service_count}"]
        @ub04payer.insured_last_name = params[:ub04payer][:"insured_last_name#{service_count}"]
        @ub04payer.insured_middle_initial = params[:ub04payer][:"insured_middle_initial#{service_count}"]
        @ub04payer.patient_relationship = params[:ub04payer][:"patient_relationship#{service_count}"]
        @ub04payer.insured_id = params[:ub04payer][:"insured_id#{service_count}"]
        @ub04payer.group_name = params[:ub04payer][:"group_name#{service_count}"]
        @ub04payer.group_no = params[:ub04payer][:"group_no#{service_count}"]
        @ub04payer.treatment_authorisation = params[:ub04payer][:"treatment_authorisation#{service_count}"]
        @ub04payer.document_control_no = params[:ub04payer][:"document_control_no#{service_count}"]
        @ub04payer.employer_name = params[:ub04payer][:"employer_name#{service_count}"]
        @ub04payer.ub04_claim_information_id = claim_id
        @total_ub04_payer_fields_with_data += @ub04payer.count_processor_input_ub04_payer_fields()
        @ub04payer.save
      end#checking mandatory fileds
    end
  end

  def updateqa
   params[:patient_id] = params[:patient_id].first
   current_user = @user
   @serviceline_count = 0
   if params[:option1] == "Add Claim"
     redirect_to :action => "add_claim",:jobid => params[:jobid]
   elsif params[:option1] == "Update" || params[:option1] == "Save claim"
    params[:batchid]=Job.find(params[:jobid]).batch.id
    params[:batch_type]=Job.find(params[:jobid]).batch.batchid
    #@user = current_remittor
    totcount = 0
    all_jobs = params[:cms1500]
    all_jobs.values.each do|a|
      totcount = totcount+1
    end
   time_stamp = "#{Time.now.strftime("%Y-%m-%d")}".delete(" ").delete(":").delete("+").delete("+")
    Dir.mkdir("#{RAILS_PATH}log/inputfields_log/#{time_stamp}") unless File.exists?("#{RAILS_PATH}log/inputfields_log/#{time_stamp}")

    file_to_write = Time.now.strftime("%Y%m%d-%H%M").to_s + ".log"
    log_file = File.open("#{RAILS_PATH}log/inputfields_log/#{time_stamp}/#{file_to_write}" , "w")
    $log = Logger.new(log_file)
    @cms = Cms1500.find(:all, :conditions => ['job_id = ? and id = ?',params[:jobid],params[:patient_id]])
    @cms.each do |cms_payer|
    pat_id = cms_payer.id
    @payer = cms_payer.payer
    unless @payer.nil?
      @payer.payer = params[:payer][:name] if params[:payer][:name]
      @payer.pay_address_one = params[:pay_add_one] if params[:pay_add_one]
      @payer.pay_address_two = params[:pay_add_two] if params[:pay_add_two]
      @payer.city = params[:payer_city] if params[:payer_city]
      @payer.zipcode = params[:payer_zipcode] if params[:payer_zipcode]
      @payer.state = params[:payer_state] if params[:payer_state]
      @payer_count = @payer.count_processor_input_payer_fields()
       @payer_fields_count = @payer.count_processor_input_payer_fields()
      @payer.save(:validate =>false)
    end
    pat_id = params[:patient_id]
    @lineids = Cms1500serviceline.find(:all,:conditions=>"cms1500_id=#{pat_id}",:select=>"id")

    if @lineids.length!=0
      p = 0
      @lineids.each do |u|
        p = p + 1
         @cmsserviceline = Cms1500serviceline.find_by_id(u.id)
        if !params[:lineinformation]["dateofservice_from"+p.to_s].blank? && !params[:lineinformation]["charges"+p.to_s].blank?
            @cmsserviceline.qual_id = params[:lineinformation]["qual_id11"+p.to_s]
            @cmsserviceline.rendering_provider_id =  params[:lineinformation]["rendering_provider_id11"+p.to_s]
            service_from_date_array=params[:lineinformation]["dateofservice_from"+p.to_s].split("/")
            service_from_date="#{service_from_date_array[1]}/#{service_from_date_array[0]}/#{service_from_date_array[2]}"
            service_to_date_array=params[:lineinformation]["dateofservice_to"+p.to_s].split("/")
            service_to_date="#{service_to_date_array[1]}/#{service_to_date_array[0]}/#{service_to_date_array[2]}"
            @cmsserviceline.service_from_date =service_from_date
            @cmsserviceline.service_to_date = service_to_date
            @cmsserviceline.service_place = params[:lineinformation]["placeof_service"+p.to_s]
            @cmsserviceline.emg =  params[:lineinformation]["emg"+p.to_s]
            @cmsserviceline.cpt_hcpcts =  params[:lineinformation]["cpthcpcs"+p.to_s]
            @cmsserviceline.modifier1 = params[:lineinformation]["modifierqa1"+p.to_s]
            @cmsserviceline.modifier2 = params[:lineinformation]["modifierqa2"+p.to_s]
            @cmsserviceline.modifier3 = params[:lineinformation]["modifierqa3"+p.to_s]
            @cmsserviceline.modifier4 = params[:lineinformation]["modifierqa4"+p.to_s]
            @cmsserviceline.diagnosis_pointer = params[:lineinformation]["diagnosis_pointer"+p.to_s]
            @cmsserviceline.charges = params[:lineinformation]["charges"+p.to_s]
            @cmsserviceline.days_units = params[:lineinformation]["days_or_units"+p.to_s]
            @cmsserviceline.minutes = params[:lineinformation]["minutes"+p.to_s]
            @cmsserviceline.epsdt = params[:lineinformation]["epsdt11"+p.to_s]
            @cmsserviceline.family_plan = params[:lineinformation]["epsdt_familycharge"+p.to_s]
            @cmsserviceline.rendering_provider_qualifier_npi_id =  params[:lineinformation]["rendering_provider_id2"+p.to_s]
            @serviceline_count += @cmsserviceline.count_processor_input_serviceline_fields()
        else
            @serviceline_count += @cmsserviceline.count_processor_input_serviceline_fields()
            @cmsserviceline.destroy()
        end

     
        @cmsserviceline.save
      end

           svc_count = params[:svc_count]
         for i in @lineids.length+1.. (svc_count.to_i)
         if !params[:lineinformation]["dateofservice_from"+i.to_s].blank? && !params[:lineinformation]["charges"+i.to_s].blank?
           
            @cmsserviceline = Cms1500serviceline.new
            @cmsserviceline.qual_id = params[:lineinformation]["id_qual1"+i.to_s]
            @cmsserviceline.rendering_provider_id =  params[:lineinformation]["rendering_provider_id1"+i.to_s]
            service_from_date_array=params[:lineinformation]["dateofservice_from"+i.to_s].split("/")
            service_from_date="#{service_from_date_array[1]}/#{service_from_date_array[0]}/#{service_from_date_array[2]}"
            service_to_date_array=params[:lineinformation]["dateofservice_to"+i.to_s].split("/")
            service_to_date="#{service_to_date_array[1]}/#{service_to_date_array[0]}/#{service_to_date_array[2]}"
            @cmsserviceline.service_from_date = service_from_date
            @cmsserviceline.service_to_date = service_to_date
            @cmsserviceline.service_place = params[:lineinformation]["placeof_service"+i.to_s]
            @cmsserviceline.emg =  params[:lineinformation]["emg"+i.to_s]
            @cmsserviceline.cpt_hcpcts =  params[:lineinformation]["cpthcpcs"+i.to_s]
            @cmsserviceline.modifier1 = params[:lineinformation]["modifier1"+i.to_s]
            @cmsserviceline.modifier2 = params[:lineinformation]["modifier2"+i.to_s]
            @cmsserviceline.modifier3 = params[:lineinformation]["modifier3"+i.to_s]
            @cmsserviceline.modifier4 = params[:lineinformation]["modifier4"+i.to_s]
            @cmsserviceline.diagnosis_pointer = params[:lineinformation]["diagnosis_pointer"+i.to_s]
            @cmsserviceline.charges = params[:lineinformation]["charges"+i.to_s]
            @cmsserviceline.days_units = params[:lineinformation]["days_or_units"+i.to_s]
            @cmsserviceline.minutes = params[:lineinformation]["minutes"+i.to_s]
            @cmsserviceline.epsdt = params[:lineinformation]["epsdt"+i.to_s]
            @cmsserviceline.family_plan = params[:lineinformation]["epsdt_familycharge2"+i.to_s]
            @cmsserviceline.rendering_provider_qualifier_npi_id =  params[:lineinformation]["rendering_provider_id2"+i.to_s]
            @cmsserviceline.cms1500_id = params[:patient_id]
            @cmsserviceline.save
            @serviceline_count += @cmsserviceline.count_processor_input_serviceline_fields()
         end

         end

      @cms.each do |cms_info|

    cms_info.other_insured_dob = date_from_month_day_year(params[:cms15001][:other_dob_month],params[:cms15001][:other_dob_date],params[:cms15001][:other_dob_year])
    cms_info.patient_signed_date = date_from_month_day_year(params[:cms15001][:signed_month],params[:cms15001][:signed_date],params[:cms15001][:signed_year])
    cms_info.insured_dob = date_from_month_day_year(params[:cms15001][:insured_dob_month],params[:cms15001][:insured_dob_date],params[:cms15001][:insured_dob_year])
    cms_info.date_of_current_illness = date_from_month_day_year(params[:cms15001][:current_dob_month],params[:cms15001][:current_dob_date],params[:cms15001][:current_dob_year])
    cms_info.first_date_similar_illness = date_from_month_day_year(params[:cms15001][:similarillness_dob_month],params[:cms15001][:similarillness_dob_date],params[:cms15001][:similarillness_dob_year])
    cms_info.patient_unable_to_work_from_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_from_dob_month],params[:cms15001][:patient_unable_work_from_dob_date],params[:cms15001][:patient_unable_work_from_dob_year])
    cms_info.patient_unable_to_work_to_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_to_dob_month],params[:cms15001][:patient_unable_work_to_dob_date],params[:cms15001][:patient_unable_work_to_dob_year])
    cms_info.hospitalization_from_date = date_from_month_day_year(params[:cms15001][:hospitalization_from_month],params[:cms15001][:hospitalization_from_date],params[:cms15001][:hospitalization_from_year])
    cms_info.hospitalization_to_date = date_from_month_day_year(params[:cms15001][:hospitalization_to_month],params[:cms15001][:hospitalization_to_date],params[:cms15001][:hospitalization_to_year])
    cms_info.physician_sign_date = date_from_month_day_year(params[:cms15001][:physician_month],params[:cms15001][:physician_date],params[:cms15001][:physician_year])
    cms_info.patient_state = params[:state]
    cms_info.service_facility_state = params[:service_facility_state]
    cms_info.billing_provider_state = params[:billing_prv_state]

 params[:cms1500][:billing_provider_last_name]="" if params[:cms1500][:billing_provider_last_name].nil?
 params[:cms1500][:billing_provider_first_name]="" if params[:cms1500][:billing_provider_first_name].nil?
 params[:cms1500][:billing_provider_suffix]="" if params[:cms1500][:billing_provider_suffix].nil?
 params[:cms1500][:billing_provider_middle_initial]="" if params[:cms1500][:billing_provider_middle_initial].nil?
 params[:cms1500][:billing_provider_name] = "" if params[:cms1500][:billing_provider_name].nil?
 params[:cms1500][:referring_provider_first_name]="" if params[:cms1500][:referring_provider_first_name].nil?
 params[:cms1500][:referring_provider_last_name]="" if params[:cms1500][:referring_provider_last_name].nil?
 params[:cms1500][:referring_provider_middle_initial]="" if params[:cms1500][:referring_provider_middle_initial].nil?
 params[:cms1500][:referring_provider_suffix]="" if params[:cms1500][:referring_provider_suffix].nil?
 params[:cms1500][:reffering_provider_organisation_name] = "" if params[:cms1500][:reffering_provider_organisation_name].nil?
 params[:cms1500][:physician_first_name]="" if params[:cms1500][:physician_first_name].nil?
 params[:cms1500][:physician_last_name]="" if params[:cms1500][:physician_last_name].nil?
 params[:cms1500][:physician_middle_initial]="" if params[:cms1500][:physician_middle_initial].nil?
 params[:cms1500][:physician_suffix]="" if params[:cms1500][:physician_suffix].nil?
 params[:cms1500][:physician_organisation_name] = "" if params[:cms1500][:physician_organisation_name].nil?
@claim_fields_count = cms_info.count_processor_input_claim_fields()
            if params[:view] == 'completed_claim'
              params[:cms1500][:total_field_count] = @claim_fields_count.to_i + @payer_count.to_i + @serviceline_count.to_i
            else
              params[:cms1500][:total_field_count] = params[:eobqa][:total_field_count] rescue nil
            end
$log.info("CLAIM fields count = #{@claim_fields_count}")
$log.info("PAYER fields count = #{@payer_count}")
$log.info("SERVICELINE fields count = #{@serviceline_count}")
$log.info("TOTAL fiels = #{params[:cms1500][:total_field_count]}")
$log.close
        cms_info.update_attributes(params[:cms1500])
    end
      ##iterating
      cmsid = pat_id.to_s
#      addingmorelinesqa(p,cmsid)
    else#checking is there any entry in cms1500serviceline
      qa_insert(pat_id)
    end#if ends
    end
    job = Job.find(params[:jobid])
    @batch = Batch.find(job.batch_id)
    if params[:option1] == "Save claim"
    redirect_to :controller => 'datacaptures',:action => 'claimqa', :batchid => params[:batch_type],:job=> job,:view => params[:view]
    #redirect_to :controller=>'datacaptures',:action => 'claim', :jobid => job, :batch_type => @batch.batchid

   elsif params[:option1] == "Update"
    puts' Starts the Qa JOB Now'

    temp= params[:pro_error_type]
    if temp.blank?
      flash[:notice] = 'Please Select an Error Type.'
      # Updating the batch status
      redirect_to :controller=>'datacaptures',:action => 'claimqa', :job => job, :batchid => @batch.batchid, :view => params[:view]
    else
      errors =[]
      errors  =  params[:pro_error_type][:id]


      for k in 0..errors.length-1
        jobid= params[:jobid]
        #qaid=@user.id
        processorid =job.processor_id
        qaid=job.qa_id
        timeofrejection = Time.now
        totalfields = @claim_fields_count.to_i + @payer_count.to_i + @serviceline_count.to_i
        accuracy = @user.field_accuracy
        #facility = EobError.find_by_id(e).error_type

       #eoberrorid = EobError.find(:first,:conditions =>"error_type = '#{errors[k]}'").id
       eoberrorid = EobError.find(:first,:conditions =>{:error_type => errors[k]}).id
        if params[:status] == 'Complete'
          status = "Accepted"
          prevstatus = "new"
        elsif params[:status] == 'Reject'
          status = "Rejected"
          prevstatus = "new"
        else
          status = "Incomplete"
          prevstatus = "new"

        end

        @eobqa = EobQa.new(:job_id=> jobid,:qa_id=> qaid ,:processor_id=>processorid,:time_of_rejection=> timeofrejection,:total_fields=> totalfields,:comment => params[:qa_comments],:total_incorrect_fields => params[:eobqa][:total_incorrect_fields],:status=>status,:prev_status=>prevstatus,:accuracy=>accuracy,:payer=>1,:eob_error_id=> eoberrorid)
        @eobqa.save!
        #facility = EobError.find_by_id(e).error_type

      end

      unless @eobqa.save

        flash[:notice] = @claimqa.errors.entries[0]
      else

        #User details updating
        user = Remittor.find(job.processor_id)
        qa= Remittor.find(job.qa_id)
        user.total_fields = user.total_fields + @claim_fields_count.to_i + @payer_count.to_i + @serviceline_count.to_i
        user.total_incorrect_fields = user.total_incorrect_fields + params[:eobqa][:total_incorrect_fields].to_i
        user.eob_qa_checked = user.eob_qa_checked + 1
        user.save

      end

      job = Job.find(params[:jobid])
      @batch = Batch.find(job.batch_id)
      count_for_rejected_eobs = 0
      payer_flag = 0
      #Entry in eob report
      @eobs = EobQa.find(:all,:conditions=>"job_id='#{params[:jobid]}'")
      #Count the errors in eob_qa
      @eobs1 = EobQa.count(params[:jobid])
      #Allow update only when eob info is available
      if @eobs.blank? or @eobs1 == 0
        flash[:notice] = "No verified/rejected EOB found. Add and resubmit."
        redirect_to :action => 'claimqa', :job => job, :batchid => @batch.batchid, :view => params[:view]
      else

        @eobs.each do |eob|
          if eob.eob_error
            error_type= eob.eob_error.error_type
            severity=eob.eob_error.severity
            code=eob.eob_error.code
            eob.save
          else

            error_type=''
            severity=''
            code=''
          end
          if eob.prev_status != "old"
            EobReport.create(:verify_time => eob.time_of_rejection,:processor => user.login, :accuracy => eob.accuracy,
              :qa => qa.login, :batch_id => job.batch.id, :batch_date => job.batch.date, :total_fields => eob.total_fields,
              :incorrect_fields => eob.total_incorrect_fields, :error_type => error_type, :error_severity => severity,
              :error_code => code, :status => eob.status, :payer => eob.payer )
            if  eob.total_incorrect_fields
            if eob.total_incorrect_fields > 0
              count_for_rejected_eobs += 1
            end
            end
          end
          eob.prev_status = "old"
          eob.save
        end

        user = @user

        #if job rejections > 0, do not recount the eob count
        if job.rejections == 0

          user.total_eobs = user.total_eobs.to_i+ job.count.to_i
        end
        #rejected_eobs is the count of eobs with incorrect fields >= 1)
        user.rejected_eobs = user.rejected_eobs.to_i + count_for_rejected_eobs
        user.save
        job.save



        #Job Status updating
        #Find the maximum of the Id from the eob_qa,So that to find the last entry in rejected/accepted
        @eob_max = EobQa.find(:all,:conditions=>"job_id=#{params[:jobid]}",:group=>"job_id",:select=>"max(id) id")
        @eob_max.each do |cliam|
          @eobw = EobQa.find(:all,:conditions=>"id=#{cliam.id}")
        end
        if @eobs1.size > 0
          flag = 0
          comment = ''
          @eobw.each do |eob|
            if comment.nil?
              comment = eob.comment
            else
              if eob.status == 'Rejected'
                comment = eob.comment + '-' + comment
              end
            end
            if eob.status == 'Rejected'
              flag = 1
            else if eob.status == 'Incomplete'
                flag = 2
              end
            end
          end
          if flag == 0
            job.qa_status = QaStatus.find_by_name('QA Complete').name.to_s
            job.qa_flag_time = Time.now

            @jobinfo = Job.find(:all,:conditions=>"batch_id =#{job.batch_id}",:select=>"max(sequence_id) seqid")
            @jobinfo.each do |t|
              @countval = t.seqid.to_i
            end
            #@jobupdate = Job.find(params[:jobid])
            #if @jobupdate.qa_status !="QA Allocated"
            job.sequence_id = @countval +1
            # @jobupdate.update
            #end
            if job.processor_status == 'Processor Complete' || job.processor_status == 'Processor Incomplete'
              job.job_status = JobStatus.find_by_name('Complete').name.to_s
            end
            if !job.incomplete_count.blank? and job.incomplete_count > 0
              if job.processor_status == 'Processor Complete' || job.processor_status == 'Processor Incomplete'
                job.job_status = JobStatus.find_by_name('New').name.to_s
              end
            end
          else if flag == 1
              job.qa_flag_time = Time.now
              job.qa_status = QaStatus.find_by_name('QA Rejected').name.to_s
              job.job_status = QaStatus.find_by_name('QA Rejected').name.to_s
              job.rejected_comment = comment
            else
              job.qa_flag_time = Time.now
              job.qa_status = QaStatus.find_by_name('QA Incomplete').name.to_s
              job.job_status = 'Incomplete'
              job.qa_comment = params[:qa_comments]
            end
          end
        else
          job.qa_status = QaStatus.find_by_name('QA Complete').name.to_s
          job.qa_flag_time = Time.now
          if job.processor_status == 'Processor Complete' || job.processor_status == 'Processor Incomplete'
            job.job_status = JobStatus.find_by_name('Complete').name.to_s
          end
        end
        if job.save
          flash[:notice] = 'Job saved successfully'
          # Updating the batch status
          batch = Batch.find(job.batch_id)
          batch.update_status
          @job_complete=Job.find(:all,:conditions=>"batch_id =#{@batch.id} and job_status='Complete'")
          @job_incomplete=Job.find(:all,:conditions=>"batch_id =#{@batch.id} and job_status='Incomplete'")
          if @job_complete
            @completed_jobs= @job_complete.length
          else
            @completed_jobs=0
          end
          if @job_incomplete
            @incompleted_jobs=@job_incomplete.length
          else
            @incompleted_jobs=0
          end
          @total_job_completed = @completed_jobs + @incompleted_jobs

          #         if @batch.eob==@total_job_completed.to_i
          #           @job_completed_for_output=Job.find(:all,:conditions=>"batch_id =#{@batch.id} and job_status='Complete' and processor_status='Processor Complete' and qa_status='QA Complete'")
          #         end
          #        if ((@jobupdate.sequence_id % 1000==0) or @batch.status=='Complete' or (@job_completed_for_output and (@job_completed_for_output.length==@job_complete.length)))

          #          if ((job.sequence_id % 1000 == 0) or @batch.status=='Complete' or (@batch.eob==@total_job_completed))
          #
          #            frequent_837_output(job.batch_id)
          #          end
          redirect_to :controller=>'qa',:action => 'my_job', :job => job
        else
          flash[:notice] = 'Job update failed'
          redirect_to :controller=>'qa', :action => 'my_job', :job => job
        end
      end
    end

    @batches_status_check= Batch.find(params[:batchid])
    completed_jobs_count= Job.find(:all,:conditions=>"batch_id= '#{params[:batchid]}' and job_status= 'Complete'").length
    incompleted_jobs_count= Job.find(:all,:conditions=>"batch_id= '#{params[:batchid]}' and job_status= 'Incomplete'").length
    total_jobs_count= @batches_status_check.jobs.count
    if total_jobs_count==completed_jobs_count or total_jobs_count==incompleted_jobs_count or total_jobs_count==incompleted_jobs_count+completed_jobs_count
      @batches_status_check.status="Complete"
      @batches_status_check.save
    end
  end
    
   elsif params[:option1] == "Delete claim"
    Cms1500.destroy_all(["id=?",params[:patient_id]])
    job = Job.find(params[:jobid])
    claim_count = job.estimated_eob
    job.estimated_eob = claim_count-1
    job.save
    redirect_to :controller => 'datacaptures',:action => 'claimqa', :batchid => params[:batchid],:job=> job,:view => params[:view]
    #redirect_to :controller=>'datacaptures',:action => 'claim', :jobid => job, :batch_type => params[:batchid]
  end
  current_user.set_remark
  end

  #processor updation after rejecting from qa
  def processor_update(job_id)
    @cms = Cms1500.find_by_job_id(job_id)
    pat_id = @cms.id
    @payer = @cms.payer
    unless @payer.nil?
      @payer.payer = params[:payer][:name] if params[:payer][:name]
      @payer.pay_address_one = params[:pay_add_one] if params[:pay_add_one]
      @payer.pay_address_two = params[:pay_add_two] if params[:pay_add_two]
      @payer.city = params[:payer_city] if params[:payer_city]
      @payer.zipcode = params[:payer_zipcode] if params[:payer_zipcode]
      @payer.state = params[:payer_state] if params[:payer_state]
      @payer.save(:validate=> false)
    end
    @cms.patient_state = params[:state]
    @cms.reserved_local_use = params[:reserved_local_use]
    @cms.patient_dob =  date_from_month_day_year(params[:month],params[:date],params[:year])
    @cms.other_insured_dob = date_from_month_day_year(params[:cms15001][:other_dob_month],params[:cms15001][:other_dob_date],params[:cms15001][:other_dob_year])
    @cms.patient_signed_date = date_from_month_day_year(params[:cms15001][:signed_month],params[:cms15001][:signed_date],params[:cms15001][:signed_year])
    @cms.insured_state = params[:insured_state]
    @cms.insured_dob = date_from_month_day_year(params[:cms15001][:insured_dob_month],params[:cms15001][:insured_dob_date],params[:cms15001][:insured_dob_year])
    @cms.date_of_current_illness = date_from_month_day_year(params[:cms15001][:current_dob_month],params[:cms15001][:current_dob_date],params[:cms15001][:current_dob_year])
    @cms.first_date_similar_illness = date_from_month_day_year(params[:cms15001][:similarillness_dob_month],params[:cms15001][:similarillness_dob_date],params[:cms15001][:similarillness_dob_year])
    @cms.patient_unable_to_work_from_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_from_dob_month],params[:cms15001][:patient_unable_work_from_dob_date],params[:cms15001][:patient_unable_work_from_dob_year])
    @cms.patient_unable_to_work_to_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_to_dob_month],params[:cms15001][:patient_unable_work_to_dob_date],params[:cms15001][:patient_unable_work_to_dob_year])
    @cms.hospitalization_from_date = date_from_month_day_year(params[:cms15001][:hospitalization_from_month],params[:cms15001][:hospitalization_from_date],params[:cms15001][:hospitalization_from_year])
    @cms.hospitalization_to_date = date_from_month_day_year(params[:cms15001][:hospitalization_to_month],params[:cms15001][:hospitalization_to_date],params[:cms15001][:hospitalization_to_year])
    @cms.physician_sign_date = date_from_month_day_year(params[:cms15001][:physician_month],params[:cms15001][:physician_date],params[:cms15001][:physician_year])
    @cms.service_facility_state =  params[:service_facility_state]
    @cms.billing_provider_state =   params[:billing_prv_state]
    @cms.update_attributes(params[:cms1500])

    #updation of Service line
    @lineids=Cms1500serviceline.find(:all,:conditions=>"cms1500_id=#{pat_id}",:select=>"id")
    if @lineids.length!=0
      p = 0
      @lineids.each do |u|
        p = p + 1
        @cmsserviceline = Cms1500serviceline.find_by_id(u.id)
        @cmsserviceline.qual_id = params[:lineinformation]["qual_id11"+p.to_s]
        @cmsserviceline.rendering_provider_id =  params[:lineinformation]["rendering_provider_id11"+p.to_s]
        service_from_date_array=params[:lineinformation]["dateofservice_from"+p.to_s].split("/")
        service_from_date="#{service_from_date_array[1]}/#{service_from_date_array[0]}/#{service_from_date_array[2]}"
        service_to_date_array=params[:lineinformation]["dateofservice_to"+p.to_s].split("/")
        service_to_date="#{service_to_date_array[1]}/#{service_to_date_array[0]}/#{service_to_date_array[2]}"
        @cmsserviceline.service_from_date = service_from_date
        @cmsserviceline.service_to_date = service_to_date
        @cmsserviceline.service_place = params[:lineinformation]["placeof_service"+p.to_s]
        @cmsserviceline.emg =  params[:lineinformation]["emg"+p.to_s]
        @cmsserviceline.cpt_hcpcts =  params[:lineinformation]["cpthcpcs"+p.to_s]
        @cmsserviceline.modifier1 = params[:lineinformation]["modifier"+p.to_s]
        @cmsserviceline.modifier2 = params[:lineinformation]["modifier2"+p.to_s]
        @cmsserviceline.modifier3 = params[:lineinformation]["modifier3"+p.to_s]
        @cmsserviceline.modifier4 = params[:lineinformation]["modifier4"+p.to_s]
        @cmsserviceline.diagnosis_pointer = params[:lineinformation]["diagnosis_pointer"+p.to_s]
        @cmsserviceline.charges = params[:lineinformation]["charges"+p.to_s]
        @cmsserviceline.days_units = params[:lineinformation]["days_or_units"+p.to_s]
        @cmsserviceline.minutes = params[:lineinformation]["minutes"+p.to_s]
        @cmsserviceline.epsdt = params[:lineinformation]["epsdt11"+p.to_s]
        @cmsserviceline.family_plan = params[:lineinformation]["epsdt_familycharge"+p.to_s]
        @cmsserviceline.rendering_provider_qualifier_npi_id =  params[:lineinformation]["rendering_provider_id2"+p.to_s]
        @cmsserviceline.save
        ############################################
      end#iterating
      addingmorelines(p,pat_id)
    else#checking is there any entry in cms1500serviceline
      qa_insert(pat_id)
    end#if ends
    
    job = Job.find(params[:jobid])
    job.count = 1
    job.incomplete_count = 0
    job.processor_flag_time = Time.now
#    job.processor_status = ProcessorStatus['Processor Complete'].to_s
#    job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
#    if job.qa_id != nil
#      if job.qa_status == 'QA Complete'
#        job.job_status = JobStatus['Complete'].to_s
#        job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
#      elsif job.qa_status == 'QA Rejected'
#        job.qa_status = QaStatus['QA Allocated'].to_s
#      elsif job.qa_status == 'QA InComplete'
#        job.job_status = JobStatus['Incomplete'].to_s
#      end
#    else
#      job.job_status = JobStatus['Complete'].to_s
#      job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
#    end

    @userpayerhistory=UserPayerJobHistory.find(:first,:conditions=>"payer_id='#{job.payer_id}'and user_id= '#{job.processor_id}'")
    if @userpayerhistory.nil?
      new_job_history = UserPayerJobHistory.new
      new_job_history.job_count = 1
      new_job_history.user_id = job.processor_id
      new_job_history.payer_id = job.payer_id
      new_job_history.save
    else
      job_history = @userpayerhistory
      job_history.job_count += 1
      job_history.save
    end

    @userclientjobhistory=UserClientJobHistory.find(:first,:conditions=>"client_id='#{job.batch.facility.client_id}'and user_id= '#{job.processor_id}'")
    if @userclientjobhistory.nil?
      new_client_history = UserClientJobHistory.new
      new_client_history.job_count = 1
      new_client_history.user_id = job.processor_id
      new_client_history.client_id = job.batch.facility.client_id
      new_client_history.save
    else
      client_history = @userclientjobhistory
      client_history.job_count += 1
      client_history.save
    end
    update_jobs(job)

  end#function ends

  #Handling qa rejected jobs, display all information that previosly entered
  def rejected_claim
    @state = State.find(:all).map{|f|f.state_code}
    @relationship_code = ["--", "01", "04", "05", "07", "09", "10", "15", "17","18", "19", "20", "21", "22", "23", "24", "29", "32", "33", "34", "36", "39", "40", "41", "43", "53", "G8"]
    @patientinfo = Cms1500.paginate(:per_page => 1, :page => params[:page], :conditions => ['job_id = ?',params[:jobid]], :order => "id DESC")
#    @patientinfo=Cms1500.find_by_job_id(params[:jobid])
    @patientinfo.each do |patient_info|
    @jobid = params[:jobid]
    @job = Job.find(@jobid)
    @image = ImagesForJob.find(@job.images_for_job_id)
    @lineinfo = Cms1500serviceline.find(:all,:conditions=>"cms1500_id=#{patient_info.id}")
    @user = current_remittor.roles[0]
  end
  end

  def rejected_claim_update
    current_user = current_remittor
   if params[:option1] == "Add Claim"
     redirect_to :action => "add_claim",:jobid => params[:jobid]
   elsif params[:option1] == "Save"
     #@batch = Batch.find(:first, :conditions => "id = #{Job.find(params[:jobid]).batch.id}", :select => "id, batchid")
    params[:batchid]=Job.find(params[:jobid]).batch.id
    params[:batch_type]=Job.find(params[:jobid]).batch.batchid
    params[:issave] = false
    @user = current_remittor
    totcount = 0
    all_jobs = params[:cms1500]
    all_jobs.delete_if do |key,value|
      value == "NULL"
    end
    all_jobs.delete_if do |key,value|
      value == ""
    end
    all_jobs.values.each do|a|
      totcount = totcount+1
    end

    #checking the Cms1500ServiceLine
    totalcount_line_info = 0
    all_jobs_service_line = params[:lineinformation]
    all_jobs_service_line.delete_if do |key,value|
      value == "NULL"
    end
    all_jobs_service_line.delete_if do |key,value|
      value == ""
    end
    all_jobs_service_line.values.each do|a|
      totalcount_line_info = totalcount_line_info + 1

    end
    @cms = Cms1500.find_by_id(params[:claimid])

    @cms.patient_state = params[:state]

    #checking the calculation of total fields
    @cmsdata = [params[:state],params[:reserved_local_use],params[:insured_state],params[:reserved_local_use], params[:service_facility_state], params[:billing_prv_state]]
    for i in 0..@cmsdata.size
      if !@cmsdata[i].blank?
        totcount = totcount + 1
      end

    end

    @cms.reserved_local_use = params[:reserved_local_use]
    if params[:month].blank?
      @dob='null'
    else

      totcount = totcount + 1
    end
    @cms.patient_dob = date_from_month_day_year(params[:month],params[:date],params[:year])
    if params[:cms15001][:other_dob_month].blank?

      @other_insured_dob1 = 'null'
    else

      totcount = totcount + 1
    end

    @cms.other_insured_dob = date_from_month_day_year(params[:cms15001][:other_dob_month],params[:cms15001][:other_dob_date],params[:cms15001][:other_dob_year])

    if params[:cms15001][:signed_month].blank?
      @signed_date = 'null'
    else

      @cms.patient_signed_date = date_from_month_day_year(params[:cms15001][:signed_month],params[:cms15001][:signed_date],params[:cms15001][:signed_year])
      totcount = totcount + 1
    end
    @cms.insured_state = params[:insured_state]

    if params[:cms15001][:insured_dob_month].blank?
      @insureds_dob = 'null'
    else

      @cms.insured_dob = date_from_month_day_year(params[:cms15001][:insured_dob_month],params[:cms15001][:insured_dob_date],params[:cms15001][:insured_dob_year])
      totcount = totcount + 1
    end

    if params[:cms15001][:current_dob_month].blank?
      @current_dob = 'NULL'
    else

      @cms.date_of_current_illness = date_from_month_day_year(params[:cms15001][:current_dob_month],params[:cms15001][:current_dob_date],params[:cms15001][:current_dob_year])
      totcount = totcount + 1
    end
    if params[:cms15001][:similarillness_dob_month].blank?
      @smilarillness_dob = 'NULL'
    else

      @cms.first_date_similar_illness = date_from_month_day_year(params[:cms15001][:similarillness_dob_month],params[:cms15001][:similarillness_dob_date],params[:cms15001][:similarillness_dob_year])
      totcount = totcount + 1
    end
    if params[:cms15001][:patient_unable_work_from_dob_month].blank?
      @patient_unable_work_from = 'NULL'
    else

      @cms.patient_unable_to_work_from_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_from_dob_month],params[:cms15001][:patient_unable_work_from_dob_date],params[:cms15001][:patient_unable_work_from_dob_year])
      totcount = totcount + 1
    end
    if params[:cms15001][:patient_unable_work_to_dob_month].blank?
      @patient_unable_work_to ='NULL'
    else

      @cms.patient_unable_to_work_to_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_to_dob_month],params[:cms15001][:patient_unable_work_to_dob_date],params[:cms15001][:patient_unable_work_to_dob_year])
      totcount = totcount + 1
    end
    if  params[:cms15001][:hospitalization_from_month].blank?
      @cms.hospitalization_from_date = 'NULL'
    else

      @cms.hospitalization_from_date = date_from_month_day_year(params[:cms15001][:hospitalization_from_month],params[:cms15001][:hospitalization_from_date],params[:cms15001][:hospitalization_from_year])
      totcount = totcount + 1
    end
    if params[:cms15001][:hospitalization_to_month].blank?
      @hospitalization_todate = 'NULL'
    else

      @cms.hospitalization_to_date =  date_from_month_day_year(params[:cms15001][:hospitalization_to_month],params[:cms15001][:hospitalization_to_date],params[:cms15001][:hospitalization_to_year])
      totcount = totcount + 1
    end
    if params[:cms15001][:physician_month].blank?
      @physiciansigndate = 'NULL'
    else

      @cms.physician_sign_date = date_from_month_day_year(params[:cms15001][:physician_month],params[:cms15001][:physician_date],params[:cms15001][:physician_year])
      totcount = totcount + 1
    end
    @cms.service_facility_state = params[:service_facility_state]
    @cms.billing_provider_state = params[:billing_prv_state]
    @cms.update_attributes(params[:cms1500])
    
    @cms = Cms1500.find_by_job_id(params[:jobid])
    pat_id = @cms.id
    @payer = @cms.payer
    unless @payer.nil?
      @payer.payer = params[:payer][:name] if params[:payer][:name]
      @payer.pay_address_one = params[:pay_add_one] if params[:pay_add_one]
      @payer.pay_address_two = params[:pay_add_two] if params[:pay_add_two]
      @payer.city = params[:payer_city] if params[:payer_city]
      @payer.zipcode = params[:payer_zipcode] if params[:payer_zipcode]
      @payer.state = params[:payer_state] if params[:payer_state]
      @payer.save(false)
    end
    #pat_id = params[:patient_id]

    @lineids = Cms1500serviceline.find(:all,:conditions=>"cms1500_id=#{pat_id}",:select=>"id")

    if @lineids.length!=0
      p = 0
      @lineids.each do |u|
        p = p + 1
        @cmsserviceline = Cms1500serviceline.find_by_id(u.id)
        @cmsserviceline.qual_id = params[:lineinformation]["qual_id11"+p.to_s]
        @cmsserviceline.rendering_provider_id =  params[:lineinformation]["rendering_provider_id11"+p.to_s]
        service_from_date_array=params[:lineinformation]["dateofservice_from"+p.to_s].split("/")
        service_from_date="#{service_from_date_array[1]}/#{service_from_date_array[0]}/#{service_from_date_array[2]}"
        service_to_date_array=params[:lineinformation]["dateofservice_to"+p.to_s].split("/")
        service_to_date="#{service_to_date_array[1]}/#{service_to_date_array[0]}/#{service_to_date_array[2]}"
        @cmsserviceline.service_from_date = service_from_date
        @cmsserviceline.service_to_date = service_to_date
        @cmsserviceline.service_place = params[:lineinformation]["placeof_service"+p.to_s]
        @cmsserviceline.emg =  params[:lineinformation]["emg"+p.to_s]
        @cmsserviceline.cpt_hcpcts =  params[:lineinformation]["cpthcpcs"+p.to_s]
        @cmsserviceline.modifier1 = params[:lineinformation]["modifier"+p.to_s]
        @cmsserviceline.modifier2 = params[:lineinformation]["modifier2"+p.to_s]
        @cmsserviceline.modifier3 = params[:lineinformation]["modifier3"+p.to_s]
        @cmsserviceline.modifier4 = params[:lineinformation]["modifier4"+p.to_s]
        @cmsserviceline.diagnosis_pointer = params[:lineinformation]["diagnosis_pointer"+p.to_s]
        @cmsserviceline.charges = params[:lineinformation]["charges"+p.to_s]
        @cmsserviceline.days_units = params[:lineinformation]["days_or_units"+p.to_s]
        @cmsserviceline.minutes = params[:lineinformation]["minutes"+p.to_s]
        @cmsserviceline.epsdt = params[:lineinformation]["epsdt11"+p.to_s]
        @cmsserviceline.family_plan = params[:lineinformation]["epsdt_familycharge"+p.to_s]
        @cmsserviceline.rendering_provider_qualifier_npi_id =  params[:lineinformation]["rendering_provider_id2"+p.to_s]
        @cmsserviceline.save
      end#iterating
       params[:issave] = true
      addingmorelines(p,pat_id)
      redirect_to :controller=>'datacaptures', :action => 'rejected_claim', :batch_type => params[:batch_type], :jobid => params[:jobid], :issave => params[:issave]
    else#checking is there any entry in cms1500serviceline
      qa_insert(pat_id)
      redirect_to :controller=>'datacaptures', :action => 'rejected_claim', :batch_type => params[:batch_type], :jobid => params[:jobid], :issave => params[:issave]
    end#if ends
elsif params[:option1] == "Complete"
    job = Job.find(params[:jobid])
    job.processor_status = 'Processor Complete'
    job.job_status = 'Complete'
    job.save
#       params[:jobid]=session[:jobid]
    job = Job.find(params[:jobid])
    job.count = 1
    job.incomplete_count = 0
    job.time_taken = params[:job1][:countr]
    job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
    if UserPayerJobHistory.find_by_payer_id_and_user_id(job.payer.id, job.processor.id).nil?
      new_job_history = UserPayerJobHistory.new
      new_job_history.job_count = 1
      new_job_history.user_id = job.processor_id
      new_job_history.payer_id = job.payer_id
      new_job_history.save

    else
      job_history = UserPayerJobHistory.find_by_payer_id_and_user_id(job.payer.id, job.processor.id)
      job_history.job_count += 1
      job_history.save
    end
    @userclinetjobhistory = UserClientJobHistory.find(:first,:conditions=>"client_id='#{job.batch.facility.client.id}' and user_id='#{ job.processor.id}'")
    if @userclinetjobhistory.nil?
      new_client_history = UserClientJobHistory.new
      new_client_history.job_count = 1
      new_client_history.user_id = job.processor_id
      new_client_history.client_id = job.batch.facility.client_id
      new_client_history.save
    else
      client_history = @userclinetjobhistory
      client_history.job_count += 1
      client_history.save
    end
    update_jobs(job)
   end
 #  redirect_to :controller=>'processor', :action => 'my_job'
  end
  def rejected_claim_ub04
      @error_type_new = EobError.find(:all)
      @state = State.find(:all).map{|f|f.state_code}
      @relationship_code = ["--", "01", "04", "05", "07", "09", "10", "15", "17", "18", "19", "20", "21", "22", "23", "24", "29", "32", "33", "34", "36", "39", "40", "41", "43", "53", "G8"]
      @errotypes=EobError.find(:all).map{|f|f.error_type}
      @batchid = params[:batchid]
      @payerid = params[:payerid]
      @jobid = params[:jobid]
      @job = Job.find(@jobid)
      @image = ImagesForJob.find(@job.images_for_job_id)
      session[:batchid] = @batchid
      session[:payerid] = @payerid
#      session[:jobid] = @jobid
@patientinfo = Ub04ClaimInformation.paginate(:per_page => 1, :page => params[:page], :conditions => ['job_id = ?', params[:jobid]])
@patientinfo.each do |patient_info|
      @ub04_servicelines = patient_info.ub04_serviceline_informations
      @value_codes = patient_info.value_codes
      @qualifier_code_values = patient_info.qualifier_code_values
      @occurence_spans = patient_info.occurence_spans
      @occurences = patient_info.occurences
      @ub04payers = patient_info.ub04payers
      @user = current_remittor.roles[0]
      render :layout => "ub04"
  end
  end
  def processor_insert

    time_stamp = "#{Time.now.strftime("%Y-%m-%d")}".delete(" ").delete(":").delete("+").delete("+")
    Dir.mkdir("#{RAILS_PATH}log/inputfields_log/#{time_stamp}") unless File.exists?("#{RAILS_PATH}log/inputfields_log/#{time_stamp}")
    
    file_to_write = Time.now.strftime("%Y%m%d-%H%M").to_s + ".log"
    log_file = File.open("#{RAILS_PATH}log/inputfields_log/#{time_stamp}/#{file_to_write}" , "w")
    $log = Logger.new(log_file)
    


    total_serviceline_count = 0
    @cmsinformation = Cms1500.new(params[:cms1500])
    @cmsinformation.payer_id = params[:payerid]
    @cmsinformation.job_id = params[:jobid]
    @cmsinformation.patient_dob = date_from_month_day_year(params[:month],params[:date],params[:year])
    @cmsinformation.patient_state = params[:state]
    @cmsinformation.reserved_local_use = params[:reserved_local_use]
    @cmsinformation.other_insured_dob = date_from_month_day_year(params[:cms15001][:other_dob_month],params[:cms15001][:other_dob_date],params[:cms15001][:other_dob_year])
    @cmsinformation.patient_signed_date = date_from_month_day_year(params[:cms15001][:signed_month],params[:cms15001][:signed_date],params[:cms15001][:signed_year])
    @cmsinformation.insured_state = params[:insured_state]
    @cmsinformation.insured_dob = date_from_month_day_year(params[:cms15001][:insured_dob_month],params[:cms15001][:insured_dob_date],params[:cms15001][:insured_dob_year])
    @cmsinformation.date_of_current_illness = date_from_month_day_year(params[:cms15001][:current_dob_month],params[:cms15001][:current_dob_date],params[:cms15001][:current_dob_year])
    @cmsinformation.first_date_similar_illness = date_from_month_day_year(params[:cms15001][:similarillness_dob_month],params[:cms15001][:similarillness_dob_date],params[:cms15001][:similarillness_dob_year])
    @cmsinformation.patient_unable_to_work_from_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_from_dob_month],params[:cms15001][:patient_unable_work_from_dob_date],params[:cms15001][:patient_unable_work_from_dob_year])
    @cmsinformation.patient_unable_to_work_to_date = date_from_month_day_year(params[:cms15001][:patient_unable_work_to_dob_month],params[:cms15001][:patient_unable_work_to_dob_date],params[:cms15001][:patient_unable_work_to_dob_year])
    @cmsinformation.hospitalization_from_date = date_from_month_day_year(params[:cms15001][:hospitalization_from_month],params[:cms15001][:hospitalization_from_date],params[:cms15001][:hospitalization_from_year])
    @cmsinformation.hospitalization_to_date = date_from_month_day_year(params[:cms15001][:hospitalization_to_month],params[:cms15001][:hospitalization_to_date],params[:cms15001][:hospitalization_to_year])
    @cmsinformation.physician_sign_date = date_from_month_day_year(params[:cms15001][:physician_month],params[:cms15001][:physician_date],params[:cms15001][:physician_year])
    @cmsinformation.service_facility_state = params[:service_facility_state]
    @cmsinformation.billing_provider_state = params[:billing_prv_state]
    @cmsinformation.save
    @payer = Payer.new(:cms1500_id => @cmsinformation.id,:payer => params[:payer][:name],:pay_address_one => params[:pay_add_one],:pay_address_two => params[:pay_add_two],:city => params[:payer_city],:state => params[:payer_state],:zipcode => params[:payer_zipcode])
    @payer.save(:validate =>false)
    count =  params[:lineinformation][:count].to_i
    rowcount = params[:lineinformation][:rowcount].to_i
    for i in 1 .. rowcount
      unless params[:lineinformation]["dateofservice_from"+i.to_s].blank?
      @cmsserviceline = Cms1500serviceline.new
      @cmsserviceline.qual_id = params[:lineinformation]["id_qual1"+i.to_s]
      @cmsserviceline.rendering_provider_id =  params[:lineinformation]["rendering_provider_id1"+i.to_s]
      service_from_date_array=params[:lineinformation]["dateofservice_from"+i.to_s].split("/")
      service_from_date="#{service_from_date_array[1]}/#{service_from_date_array[0]}/#{service_from_date_array[2]}"
      service_to_date_array=params[:lineinformation]["dateofservice_to"+i.to_s].split("/")
      service_to_date="#{service_to_date_array[1]}/#{service_to_date_array[0]}/#{service_to_date_array[2]}"
      @cmsserviceline.service_from_date = service_from_date
      @cmsserviceline.service_to_date = service_to_date
      @cmsserviceline.service_place = params[:lineinformation]["placeof_service"+i.to_s]
      @cmsserviceline.emg =  params[:lineinformation]["emg"+i.to_s]
      @cmsserviceline.cpt_hcpcts =  params[:lineinformation]["cpthcpcs"+i.to_s]
      @cmsserviceline.modifier1 = params[:lineinformation]["modifier1"+i.to_s]
      @cmsserviceline.modifier2 = params[:lineinformation]["modifier2"+i.to_s]
      @cmsserviceline.modifier3 = params[:lineinformation]["modifier3"+i.to_s]
      @cmsserviceline.modifier4 = params[:lineinformation]["modifier4"+i.to_s]
      @cmsserviceline.diagnosis_pointer = params[:lineinformation]["diagnosis_pointer"+i.to_s]
      @cmsserviceline.charges = params[:lineinformation]["charges"+i.to_s]
      @cmsserviceline.days_units = params[:lineinformation]["days_or_units"+i.to_s]
      @cmsserviceline.minutes = params[:lineinformation]["minutes"+i.to_s]
      @cmsserviceline.epsdt = params[:lineinformation]["epsdt"+i.to_s]
      @cmsserviceline.family_plan = params[:lineinformation]["epsdt_familycharge2"+i.to_s]
      @cmsserviceline.rendering_provider_qualifier_npi_id =  params[:lineinformation]["rendering_provider_id2"+i.to_s]
      @cmsserviceline.cms1500_id = @cmsinformation.id
      @cmsserviceline.save
      total_serviceline_count += @cmsserviceline.count_processor_input_serviceline_fields()
      end
#      puts @cmsserviceline.inspect
    end

$log.info("CLAIM fields count = #{@cmsinformation.count_processor_input_claim_fields()}")
$log.info("PAYER fields count = #{@payer.count_processor_input_payer_fields()}")
$log.info("SERVICELINE fields count = #{total_serviceline_count}")

#    p "***********************************************************"
#    p @cmsinformation.count_processor_input_claim_fields()
#    p @payer.count_processor_input_payer_fields()
#    p total_serviceline_count
#    p "***********************************************************"
    @cmsinformation.total_field_count = @cmsinformation.count_processor_input_claim_fields()+@payer.count_processor_input_payer_fields()+total_serviceline_count
    $log.info("TOTAL FIELD COUNT = #{@cmsinformation.total_field_count} ")
$log.close
      @cmsinformation.save()
    #in order to complete job
#    params[:jobid]=session[:jobid]
    job = Job.find(params[:jobid])
    job.count = 1
    job.incomplete_count = 0
    job.time_taken = params[:job1][:countr]
    job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
#    if params[:option1] != "Save"
#     job.processor_flag_time = Time.now
#     job.processor_status = ProcessorStatus['Processor Complete'].to_s
#     if job.qa_id != nil
#      if job.qa_status == 'QA Complete'
#        job.job_status = JobStatus['Complete'].to_s
#        job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
#      elsif job.qa_status == 'QA Rejected'
#        job.qa_status = QaStatus['QA Allocated'].to_s
#      end
#     else
#      job.job_status = JobStatus['Complete'].to_s
#      job.estimated_eob = Cms1500.count(:all,:conditions=>"job_id = #{job.id}")
#     end
#    end
    if UserPayerJobHistory.find_by_payer_id_and_user_id(job.payer.id, job.processor.id).nil?
      new_job_history = UserPayerJobHistory.new
      new_job_history.job_count = 1
      new_job_history.user_id = job.processor_id
      new_job_history.payer_id = job.payer_id
      new_job_history.save
    else
      job_history = UserPayerJobHistory.find_by_payer_id_and_user_id(job.payer.id, job.processor.id)
      job_history.job_count += 1
      job_history.save
    end
    @userclinetjobhistory = UserClientJobHistory.find(:first,:conditions=>"client_id='#{job.batch.facility.client.id}' and user_id='#{ job.processor.id}'")
    if @userclinetjobhistory.nil?
      new_client_history = UserClientJobHistory.new
      new_client_history.job_count = 1
      new_client_history.user_id = job.processor_id
      new_client_history.client_id = job.batch.facility.client_id
      new_client_history.save
    else
      client_history = @userclinetjobhistory
      client_history.job_count += 1
      client_history.save
    end
    update_jobs(job)
  end  #end of function

  #Date manipulation
  def date_from_month_day_year(month, day, year)
    date_string = "#{day}/#{month}/#{year}"
    begin
      date_value = date_string.to_date
    rescue
      date_value = nil
    end

    return date_value
  end # end of the date_from_month_day_year

  def select_errortype
    error_type = EobError.find(:all)
    @error_type_new = EobError.find(:all)

    @payer_pages, @errors = paginate_collection error_type, :per_page => 30 ,:page => params[:page],:job_id=>params[:job_id]
  end # select_errortype ends

  def add_errortype
    puts params[:job]
    @ids =[]
    if !params[:payers_to_delete].blank?
      all_jobs = params[:payers_to_delete]
      all_jobs.delete_if do |key,value|
        value == "0"
      end
      all_jobs.keys.each do |id|
        @ids<<id
      end
    end

    redirect_to :action=>'claimqa',:error_type_array=> @ids,:job=>params[:job]
  end

  def addingmorelines(rece_p,cmsid)
    newp = rece_p + 1
    if newp != 1


      while newp<=50
        if (!(params[:lineinformation]["dateofservice_from"+newp.to_s].blank?)&&!(params[:lineinformation]["diagnosis_pointer"+newp.to_s].blank?)&&!(params[:lineinformation]["charges"+newp.to_s].blank?))
          cms1500 = Cms1500.find(cmsid)
          @cmsservicelinenew = cms1500.service_lines.create
          @cmsservicelinenew.qual_id = params[:lineinformation]["qual_id11"+newp.to_s]
          @cmsservicelinenew.rendering_provider_id =  params[:lineinformation]["rendering_provider_id11"+newp.to_s]
          service_from_date_array=params[:lineinformation]["dateofservice_from"+newp.to_s].split("/")
            service_from_date="#{service_from_date_array[1]}/#{service_from_date_array[0]}/#{service_from_date_array[2]}"
            service_to_date_array=params[:lineinformation]["dateofservice_to"+newp.to_s].split("/")
            service_to_date="#{service_to_date_array[1]}/#{service_to_date_array[0]}/#{service_to_date_array[2]}"
          @cmsservicelinenew.service_from_date = service_from_date
          @cmsservicelinenew.service_to_date = service_to_date
          @cmsservicelinenew.service_place = params[:lineinformation]["placeof_service"+newp.to_s]
          @cmsservicelinenew.emg =  params[:lineinformation]["emg"+newp.to_s]
          @cmsservicelinenew.cpt_hcpcts =  params[:lineinformation]["cpthcpcs"+newp.to_s]
          @cmsservicelinenew.modifier1 = params[:lineinformation]["modifier"+newp.to_s]
          @cmsservicelinenew.modifier2 = params[:lineinformation]["modifier2"+newp.to_s]
          @cmsservicelinenew.modifier3 = params[:lineinformation]["modifier3"+newp.to_s]
          @cmsservicelinenew.modifier4 = params[:lineinformation]["modifier4"+newp.to_s]
          @cmsservicelinenew.diagnosis_pointer = params[:lineinformation]["diagnosis_pointer"+newp.to_s]
          @cmsservicelinenew.charges = params[:lineinformation]["charges"+newp.to_s]
          @cmsservicelinenew.days_units = params[:lineinformation]["days_or_units"+newp.to_s]
          @cmsservicelinenew.minutes = params[:lineinformation]["minutes"+newp.to_s]
          @cmsservicelinenew.epsdt = params[:lineinformation]["epsdt11"+newp.to_s]
          @cmsservicelinenew.family_plan = params[:lineinformation]["epsdt_familycharge"+newp.to_s]
          @cmsservicelinenew.rendering_provider_qualifier_npi_id =  params[:lineinformation]["rendering_provider_id2"+newp.to_s]
          @cmsservicelinenew.save
        end#checkiing the
        newp = newp+1
      end
    else
      puts 'No more Lines to be added'
    end

  end
# TO DO: remove this repetition of same function by making the names of 'modifier' and 'modifierqa' same in processor and QA view
def addingmorelinesqa(rece_p,cmsid)
    newp = rece_p + 1
    if newp != 1

      while newp<=50
        if (!(params[:lineinformation]["dateofservice_from"+newp.to_s].blank?)&&!(params[:lineinformation]["diagnosis_pointer"+newp.to_s].blank?)&&!(params[:lineinformation]["charges"+newp.to_s].blank?))
          cms1500 = Cms1500.find(cmsid)
          @cmsservicelinenew = cms1500.service_lines.create
          @cmsservicelinenew.qual_id = params[:lineinformation]["qual_id11"+newp.to_s]
          @cmsservicelinenew.rendering_provider_id =  params[:lineinformation]["rendering_provider_id11"+newp.to_s]
          service_from_date_array=params[:lineinformation]["dateofservice_from"+newp.to_s].split("/")
            service_from_date="#{service_from_date_array[1]}/#{service_from_date_array[0]}/#{service_from_date_array[2]}"
            service_to_date_array=params[:lineinformation]["dateofservice_to"+newp.to_s].split("/")
            service_to_date="#{service_to_date_array[1]}/#{service_to_date_array[0]}/#{service_to_date_array[2]}"
          @cmsservicelinenew.service_from_date = service_from_date
          @cmsservicelinenew.service_to_date = service_to_date
          @cmsservicelinenew.service_place = params[:lineinformation]["placeof_service"+newp.to_s]
          @cmsservicelinenew.emg =  params[:lineinformation]["emg"+newp.to_s]
          @cmsservicelinenew.cpt_hcpcts =  params[:lineinformation]["cpthcpcs"+newp.to_s]
          @cmsservicelinenew.modifier1 = params[:lineinformation]["modifierqa1"+newp.to_s]
          @cmsservicelinenew.modifier2 = params[:lineinformation]["modifierqa2"+newp.to_s]
          @cmsservicelinenew.modifier3 = params[:lineinformation]["modifierqa3"+newp.to_s]
          @cmsservicelinenew.modifier4 = params[:lineinformation]["modifierqa4"+newp.to_s]
          @cmsservicelinenew.diagnosis_pointer = params[:lineinformation]["diagnosis_pointer"+newp.to_s]
          @cmsservicelinenew.charges = params[:lineinformation]["charges"+newp.to_s]
          @cmsservicelinenew.days_units = params[:lineinformation]["days_or_units"+newp.to_s]
          @cmsservicelinenew.minutes = params[:lineinformation]["minutes"+newp.to_s]
          @cmsservicelinenew.epsdt = params[:lineinformation]["epsdt11"+newp.to_s]
          @cmsservicelinenew.family_plan = params[:lineinformation]["epsdt_familycharge"+newp.to_s]
          @cmsservicelinenew.rendering_provider_qualifier_npi_id =  params[:lineinformation]["rendering_provider_id2"+newp.to_s]
          @cmsservicelinenew.save
        end#checkiing the
        newp = newp+1
      end
    else
      puts 'No more Lines to be added'
    end
  end

  def qa_insert(pat_id)
    for i in 1 .. 50
      if (!(params[:lineinformation]["dateofservice_from"+i.to_s].blank?)&&!(params[:lineinformation]["diagnosis_pointer"+i.to_s].blank?)&&!(params[:lineinformation]["charges"+i.to_s].blank?))
        @cmsserviceline = Cms1500serviceline.new
        @cmsserviceline.qual_id = params[:lineinformation]["id_qual11"+i.to_s]
        @cmsserviceline.rendering_provider_id =  params[:lineinformation]["rendering_provider_id11"+i.to_s]
        service_from_date_array=params[:lineinformation]["dateofservice_from"+i.to_s].split("/")
        service_from_date="#{service_from_date_array[1]}/#{service_from_date_array[0]}/#{service_from_date_array[2]}"
        service_to_date_array=params[:lineinformation]["dateofservice_to"+i.to_s].split("/")
        service_to_date="#{service_to_date_array[1]}/#{service_to_date_array[0]}/#{service_to_date_array[2]}"
        @cmsserviceline.service_from_date = service_from_date
        @cmsserviceline.service_to_date =service_to_date
        @cmsserviceline.service_place = params[:lineinformation]["placeof_service"+i.to_s]
        @cmsserviceline.emg =  params[:lineinformation]["emg"+i.to_s]
        @cmsserviceline.cpt_hcpcts =  params[:lineinformation]["cpthcpcs"+i.to_s]
        @cmsserviceline.modifier1 = params[:lineinformation]["modifier"+i.to_s]
        @cmsserviceline.modifier2 = params[:lineinformation]["modifier2"+i.to_s]
        @cmsserviceline.modifier3 = params[:lineinformation]["modifier3"+i.to_s]
        @cmsserviceline.modifier4 = params[:lineinformation]["modifier4"+i.to_s]
        @cmsserviceline.diagnosis_pointer = params[:lineinformation]["diagnosis_pointer"+i.to_s]
        @cmsserviceline.charges = params[:lineinformation]["charges"+i.to_s]
        @cmsserviceline.days_units = params[:lineinformation]["days_or_units"+i.to_s]
        @cmsserviceline.minutes = params[:lineinformation]["minutes"+i.to_s]
        @cmsserviceline.epsdt = params[:lineinformation]["epsdt"+i.to_s]
        @cmsserviceline.family_plan = params[:lineinformation]["epsdt_familycharge2"+i.to_s]
        @cmsserviceline.rendering_provider_qualifier_npi_id =  params[:lineinformation]["rendering_provider_id2"+i.to_s]
        @cmsserviceline.cms1500_id = pat_id
        @cmsserviceline.save
      else
        puts 'Error in Adding Service Line Information'
      end#checking mandatory fileds
    end
  end


  def date_conversion_to_yy_mm_dd(date)
    if !(date.blank? or date.nil?)

      date = "#{date.slice(4,4)}-#{date.slice(0,2)}-#{date.slice(2,2)}"

#      if date.slice(4,1) == "0" or date.slice(4,1) == "1"
#        date = "20#{date.slice(4,2)}-#{date.slice(0,2)}-#{date.slice(2,2)}"
#      else
#        date = "19#{date.slice(4,2)}-#{date.slice(0,2)}-#{date.slice(2,2)}"
#      end

      return date
    end
    return ""
  end

  def patient_details_from_csv
   firstname = params[:firstname]
   lastname = params[:lastname]
   insuredid = params[:insuredid]

   @patient_informations = PatientInformation.paginate(:conditions => ["insured_id LIKE ? and firstname LIKE ? and lastname LIKE ?","#{insuredid.strip rescue nil}%","#{firstname.strip rescue nil}%","#{lastname.strip rescue nil}%"],:page => params[:page], :per_page => 10)
  end

  def patient_informations(id)
    @patient_informations = PatientInformation.find_by_id(id)

  end
end #end of class
