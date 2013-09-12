# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.


#require 'zip/zipfilesystem'

class Admin::BatchController < ApplicationController

  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  require_role ["admin","Supervisor"]

  require 'date'
  #require 'rubygems'
  require "nokogiri"

  #This method extracts the cms1500 and its service line details from the OCRed XML files.
  #The method fetches the XML files from XMLs_New directory and push it for parsing.
  #This method calls the get_values() and insert_meta_data() sub-routines to extract and insert the meta data associated with every XML Node.
  #The Parsed XML files will be pushed to an archieve directory named as XML_archieve.

  def cms_parser
    Dir.glob("#{Rails.root}/XMLs_New/*.xml").each do |xml_file|
    doc = Nokogiri::XML.parse(File.open("#{xml_file}"))
#    @cms = Cms1500.create(:details=>{:patient_first_name_ocr_output=>""})

    unless doc.xpath("//Revclaim_2/sources/image").blank?

    image_name = doc.xpath("//Revclaim_2/sources/image").attr("name").gsub('.tif','')
    @job = Job.find_by_tiff_number(image_name)
    unless @job.nil?
      puts "got match"
    else
      puts "No Match"
      puts image_name
    end
    end
    unless @job.nil?
    @cms = @job.cms1500s.create(:details=>{:patient_first_name_ocr_output=>""})
    doc.xpath("//Revclaim_2").each do |element|
                   element.children.each do |row_node|
                   #For Parsing the claim level informations

                  if (row_node.name.include?'balance') or (row_node.name.include?'total') or (row_node.name.include?'amount') or (row_node.name.include?'federal') or (row_node.name.include?'nature_of') or (row_node.name.include?'hospitalization') or (row_node.name.include?'billing') or (row_node.name.include?'date') or (row_node.name.include?'other')
                    xml_data  = get_values(row_node)
                    insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
                  end

                  db_field = row_node.name.include?'patient'
                  non_db_field = row_node.name.include?'patient_name'
                  if (db_field == true) and (non_db_field == false)
                    xml_data  = get_values(row_node)
                    insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
                  end


                  db_field = row_node.name.include?'referring'
                  non_db_field = row_node.name.include?'referring_provider_name'
                  if (db_field == true) and (non_db_field == false)
                    xml_data  = get_values(row_node)
                    insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
                  end

                  db_field = row_node.name.include?'physician'
                  non_db_field = row_node.name.include?'physician_name'
                  if (db_field == true) and (non_db_field == false)
                    xml_data  = get_values(row_node)
                    insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
                  end

                  db_field = row_node.name.include?'insur'
                  non_db_field = row_node.name.include?'insured_name'
                  if (db_field == true) and (non_db_field == false)
                    xml_data  = get_values(row_node)
                    insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
                  end

                  db_field = row_node.name.include?'service'
                  non_db_field = row_node.name.include?'service_line'
                  if (db_field == true) and (non_db_field == false)
                    xml_data  = get_values(row_node)
                    insert_meta_data(xml_data[1],xml_data[4],xml_data[3],row_node.name,xml_data[0].strip,xml_data[2],@cms,xml_data[5])
                  end

                  #For Parsing the Service Lines

                  if (row_node.name.include?'service_line')
                    row_node.xpath("//service_line/row").each do |child1|
                      @service_line = @cms.service_lines.create(:details=>{:service_from_date_ocr_output=>""})
                      child1.children.each do |subchild|
                        if (subchild.name.include?'service') or (subchild.name.include?'charges') or (subchild.name.include?'diagnosis') or (subchild.name.include?'cpt') or (subchild.name.include?'days') or (subchild.name.include?'rendering') or (subchild.name.include?'modifier')
                          xml_data  = get_values(subchild)
                          insert_meta_data(xml_data[1],xml_data[4],xml_data[3],subchild.name,xml_data[0].strip,xml_data[2],@service_line,xml_data[5])
                        end
                      end
                    end

                  end

    end
    end
    end
    system "mv #{xml_file} #{Rails.root}/XML_archieve/"
    end
  end



  def index
    redirect_to :action => :list
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)

  def list
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]

    search_field.strip! unless search_field.nil?

    if not search_field.blank?
      filtered_batches = filtering_batch(criteria, compare, search_field)
      if filtered_batches.size == 0
        flash[:notice] = " No record found for <i>#{criteria} #{compare} \"#{search_field}\"</i>"
      else
        batches = filtered_batches
      end
    else
      batches = Batch.find(:all, :conditions => "status != 'Complete' and status != 'HLSC Verified'",
        :order => "arrival_time")
    end

    @batches =Batch.paginate(:page => params[:page], :per_page =>1)

    # For AJAX requests, render the partial and disable the layout
    if request.xml_http_request?
      render :partial => "batches_list", :layout => false
    end
  end

  def allocate

    search_field = params[:to_find]
    criteria = params[:criteria]
    compare = params[:compare]

    search_field.strip! unless search_field.nil?
    if not search_field.blank?
      filtered_batches = filtering_batch(criteria, compare, search_field)
      if filtered_batches
        batches = filtered_batches
        @batches =batches.paginate(:page => params[:page], :per_page =>10)
      else
        flash[:notice] = " No record found for <i>#{criteria} #{compare} \"#{search_field}\"</i>"
        @batches = Batch.paginate(:conditions => "status = 'New' or status = 'Processing' ",:page => params[:page], :per_page =>10)

      end
    else
      @batches = Batch.paginate(:conditions => "status = 'New' or status = 'Processing'",:order=>"date,batchid",:page => params[:page], :per_page =>10)
      #@batches =batches.paginate(:page => params[:page], :per_page =>10)
    end

  end

  def non_compliant
    search_field = params[:to_find]
    criteria = params[:criteria]
    compare = params[:compare]

    search_field.strip! unless search_field.nil?
    batches = Batch.find(:all, :conditions => "status != 'HLSC Verified' and status != 'Complete'
                                                 and tats.expected_time > batches.target_time",
      :joins => "left join tats on batches.id = tats.batch_id ")
    if batches.size == 0
      # No non-compliant batches found
      # redirect to all batches view
      flash[:notice] = "No non-compliant batches found. Redirecting to Payer wise Job Allocation view."
      redirect_to :action => "payer_list"
    end

    if not search_field.blank?
      filtered_batches = filtering_batch_for_non_compliant(criteria, compare, search_field)
      if filtered_batches.size == 0
        flash[:notice] = " No record found for <i>#{criteria} #{compare} \"#{search_field}\"</i>"
      else
        batches = filtered_batches
      end
    end
    @batches =Batch.paginate(:all, :page => params[:page], :per_page =>20)
  end

  def filtering_batch_for_non_compliant(field, comp, search)
    flash[:notice] = nil
    conditions = "status != 'HLSC Verified' and status != 'Complete' and tats.expected_time > batches.target_time"
    case field
    when 'Batch ID'
      temp_search = search
      search = search.to_i
      batches = Batch.find(:all,
        :conditions => conditions + " and batchid #{comp} #{search}",
        :joins => "left join tats on batches.id = tats.batch_id ")
      search = temp_search
    when 'Date'
      begin
        date = Date.strptime(search,"%m/%d/%y")
      rescue ArgumentError
        flash[:notice] = "Invalid date format"
      end
      batches = Batch.find(:all,
        :conditions => conditions + " and date #{comp} '#{date}'",
        :joins => "left join tats on batches.id = tats.batch_id ")
    when 'Facility'
      flash[:notice] = "String search, '#{comp}' ignored."
      batches = Batch.find(:all,
        :conditions => conditions + " and facilities.name like '%#{search}%'",
        :joins => "left join tats on batches.id = tats.batch_id " +
          "left join facilities on facility_id = facilities.id")
    when 'Status'
      flash[:notice] = "String search, '#{comp}' ignored."
      batches = Batch.find(:all,
        :conditions => conditions + " and status like '%#{search}%'",
        :joins => "left join tats on batches.id = tats.batch_id ")
    when 'Estimated EOB'
      batches = Batch.find(:all,
        :conditions => conditions,
        :joins => "left join tats on batches.id = tats.batch_id ")
      case comp
      when '='
        batches = batches.select do |batch|
          batch.estimated_eobs == search.to_i
        end
      when '>'
        batches = batches.select do |batch|
          batch.estimated_eobs > search.to_i
        end
      when '<'
        batches = batches.select do |batch|
          batch.estimated_eobs < search.to_i
        end
      end
    end
    return batches
  end

  def filtering_batch(field, comp, search)

    flash[:notice] = nil
    case field
    when 'Batch ID'
      temp_search = search
      # search = search.to_i
      if(comp=="<" or comp== ">")
        flash[:notice] = "String search, '#{comp}' ignored."
      end
      batches = Batch.find(:all, :conditions =>"batchid #{comp} '#{search}'")
      search = temp_search

    when 'Date'
      begin
        search=search.split("/")
        yy="20"+search[2]
        year=yy.to_i
        mm=search[0].to_i
        dd=search[1].to_i
        date=Date.new(year,mm,dd)
        #date = Date.strptime(search,"%m/%d/%y")
        batches = Batch.find(:all, :conditions =>{:date=> date})
      rescue ArgumentError
        flash[:notice] = "Invalid date format"
      end
    when 'Facility'
      if(comp=="<" or comp== ">")
        flash[:notice] = "String search, '#{comp}' ignored."
      end
      batches = Batch.find(:all, :conditions => "facilities.name like '%#{search}%'",
        :joins => "left join facilities on facility_id = facilities.id")
    when 'Status'
      if(comp=="<" or comp== ">")
        flash[:notice] = "String search, '#{comp}' ignored."
      end
      batches = Batch.find(:all, :conditions => "status like '%#{search}%'")
    when 'Estimated EOB'
      batches = Batch.find(:all)
      case comp
      when '='
        batches = batches.select do |batch|
          batch.estimated_eobs == search.to_i
        end
      when '>'
        batches = batches.select do |batch|
          batch.estimated_eobs > search.to_i
        end
      when '<'
        batches = batches.select do |batch|
          batch.estimated_eobs < search.to_i
        end
      end
    when 'Client'

      batches = Batch.find(:all,  :conditions => "clients.name like '%#{search}%'",
        :joins => "left join facilities on facility_id = facilities.id " +
          "left join clients on client_id = clients.id")
    end

    return batches
  end

  def comments
    @tat = Batch.find(params[:id]).tat
  end

  def show
    @batch = Batch.find(params[:id])
  end

#  def load
#
#  end
#
#  def loadFile
#   original_facility_name = params[:facility][:id]
#   @facility = Facility.find(:all, :conditions => "batchupload = 0").join(', ')
#   directory_name = Rails.root.to_s + "/public/batchload/"+ params[:facility][:id] rescue nil
#   Dir.mkdir(directory_name) unless File.exists?(directory_name)
#    @batchzip = BatchUpload.new :filename => "#{params[:upload]}" , :content_type => 'application/zip',
#            :temp_path => "#{directory_name}/"
#          p directory_name
#    @batchzip.save
#     path = "#{directory_name}/"
#      File.open(path, "w") { |f| f.write(params[:upload][:file].read) }
#
#  redirect_to :action => 'load'
#  end

  def load
    @user_has_access = @user.has_role?(:admin) || @user.has_role?(:supervisor)
  #  @facility = Facility.find(:all, :conditions => ["batchupload = ?", '1']).join(', ')
    @facilities=Facility.find(:all, :conditions => "batchupload = 1").collect {|p| [ p.name, p.name ] }
#    @layout_needed = params[:layout]
    if @layout_needed == "false"
      render :layout => false
    end
  end



   def loadFile
    original_facility_name = params[:facility][:id]
    facility_name = original_facility_name.gsub("\s","_").downcase
    filename = params[:upload]['file'].original_filename
    time_stamp = "#{Time.now.strftime("%Y%m%d%H%M%S")}".delete(" ").delete(":").delete("+").delete("+").delete("-")
    Dir.mkdir("#{Rails.root}/batchupload/#{facility_name}") unless File.exists?("#{Rails.root}/batchupload/#{facility_name}")
    file = BatchUpload.upload_batch(current_remittor.login,params[:upload],facility_name)
#    @batchzip = BatchUpload.new :filename => "#{params[:upload]}" , :content_type => 'application/zip',
#            :temp_path => "#{directory_name}/"
#          p directory_name
#    @batchzip.save
    bool_ok = true
    flash[:notice] = case file
    when 0
       bool_ok = false
       "Select a file to upload"

    when true
       bool_ok = true
       "File successfully uploaded"

    when false
       bool_ok = false
      "Error while uploading"

    end
    mail_on_success =  bool_ok ? "Successfully" : "Unsuccessfully "
    subject = "Revclaim Batch copied #{mail_on_success} for #{params[:facility][:id].gsub("\s"," ")} at #{Time.now}"
    recipient = $RC_REFERENCES['email']['batch_upload']['notification']#current_user.email
    new_name = "#{time_stamp}_#{current_remittor.login}_#{filename}"
    new_path = File.join("batchupload/#{facility_name}",new_name)
    begin
      file_size = File.basename(new_path).size
    rescue=>e
      flash[:notice] = "Error while uploading.....directory with facility name Does not exist in the application"
    end
    require 'socket'
    RevclaimMailer.notify_batch_upload(recipient,subject,filename,
                             original_facility_name,request.host_with_port,file_size,
                             request.remote_ip,current_remittor.login,bool_ok).deliver

    redirect_to :action => 'load'
  end

  def new
    @batch = Batch.new
    @facilities = Facility.find(:all)
    @payers = Payer.find(:all).map do |payer|
      payer.payer
    end
  end

  def create
    @payers = Payer.find(:all).map do |payer|
      payer.payer
    end
    @facilities = Facility.find(:all)
    @batch = Batch.new(params[:batch])
    facility = params[:form][:facility_name] unless params[:form].nil?
    payer = params[:form1][:payer_payer] unless params[:form1].nil?
    unless facility.nil?
      @batch.facility = Facility.find_by_name(facility)
      @batch.target_time = @batch.arrival_time + @batch.facility.client.tat.hours
      @batch.contracted_time = @batch.arrival_time + @batch.facility.client.contracted_tat.hours
    end
    unless payer.nil?
      @batch.payer = Payer.find_by_payer(payer)
    end
    @batch.status = BatchStatus['New'].to_s

    if @batch.save
      flash[:notice] = 'Batch was successfully created.'
      tat = Tat.new
      @batch.tat = tat
      @batch.update
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @payers = Payer.find(:all).map do |payer|
      payer.payer
    end
    @statuses = Status.find(:all).map do |status|
      status.value
    end
    @facilities = Facility.find(:all).map do |facility|
      facility.name
    end
    @batch = Batch.find(params[:id])
  end

  def update
    @payers = Payer.find(:all).map do |payer|
      payer.payer
    end
    @facilities = Facility.find(:all).map do |facility|
      facility.name
    end
    @batch = Batch.find(params[:id])
    if @batch.update_attributes(params[:batch])
      @batch.facility = Facility.find_by_name(params[:form][:facility_name])
      @batch.payer = Payer.find_by_payer(params[:form1][:payer_payer]) unless @batch.payer.nil?
      @batch.target_time = @batch.arrival_time + @batch.facility.client.tat.hours
      # If the batch is completed, add the batch completion time.
      if @batch.status == 'Complete'
        @batch.completion_time = Time.now
        @batch.update
      end
      flash[:notice] = 'Batch was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
    @batch.update
  end

  def destroy
    Batch.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def delete_batches
    # TODO: Messy way to handle multiple checkboxes from the view
    @batchid = params[:job1][:countr]
    batch_to_del = Batch.where("id = #{@batchid}")
    batch_to_del.each do |batch|
    if batch.status == "New"
      batch.status = "Deleted"
      flash[:notice] = "Batch (#{batch.batchid}) deleted"
    else
      flash[:notice] = "Batch (#{batch.batchid}) cannot be deleted"
    end
    batch.save
    end
#    batches.delete_if do |key, value|
#      value == "0"
#    end
#    batches.keys.each do |id|
#      Batch.find(id).destroy
#    end
#    if batches.size != 0
#      flash[:notice] = "Deleted #{batches.size} batch(es)."
#    else
#      flash[:notice]="Please select atleast one batch to delete"
#    end
    redirect_to :action => 'allocate'
  end

  def add_job
    unless params[:id].nil?
      @batch = Batch.find(params[:id])
      @jobs = @batch.jobs
      if @jobs.size > 0
        @jobs = @jobs.sort_by {|j| j.payer.payer}
      end
    else
      flash[:notice] = "Job administration screen cannot be accessed directly."
      redirect_to :controller => '/admin/batch', :action => 'index'
    end
  end

  def delete_jobs
    jobs = params[:jobs_to_delete]
    batch = Batch.find(params[:batch])
    jobs.delete_if do |key, value|
      value == "0"
    end

    jobs.keys.each do |id|
      Job.find(id).destroy
    end
    if jobs.keys.size > 0
      flash[:notice] = "Deleted #{jobs.keys.size} Job(s)."
    else
      flash[:notice] = "Please select atleast one Job to delete."
    end

    redirect_to :action => 'add_job', :id => batch

  end

  def create_job
    job = Job.new(params[:job])
    batch = Batch.find(params[:batch])
    job.batch = batch
    begin
      job.payer_id = Payer.find_by_payer(params[:job1][:payer]).id

      job.job_status = JobStatus['New'].to_s
      job.processor_status = ProcessorStatus['New'].to_s
      job.qa_status = QaStatus['New'].to_s
      # If no check number is specified get the check number of the last created job.
      # Less pain when allocating large jobs with many tiffs.
      if params[:job][:check_number] == ""
        last_job = Job.find(:first, :order=> 'id desc')
        job.check_number = last_job.check_number unless last_job.nil?
      end
      multiplier = 10

      job.estimated_eob = params[:job][:estimated_eob]
      if job.save
        flash[:notice] = 'Job was successfully created'
      else
        flash[:notice] = 'Failed creating job'
      end
      redirect_to :action => 'add_job', :id => batch
    rescue
      flash[:notice] = 'Please select Payer'
      redirect_to :action => 'add_job', :id => batch
    end
  end

  def update_tat_comments
    batch = Batch.find(params[:id])
    tat = batch.tat
    if tat.nil?
      tat = Tat.new(params[:tat])
      batch.tat = tat
      batch.save
      batch.reload
    else
      tat.update_attributes(params[:tat])
    end
    batch.manual_override = true
    batch.save
    if params['back_page']==nil
      redirect_to :action => 'allocate'
    else
      redirect_to :action =>'non_compliant'
    end
  end

  def resubmit_to_hlsc
    batch = Batch.find(params[:id])
    id_batch = params[:id]
    batch.completion_time = Time.now unless batch.status == 'Complete'
    count = Job.count(:all,:conditions=>"batch_id=#{id_batch} ")
    hlsc_reject_job_count = 0

    batch.jobs.each do |job|
      if job.job_status == 'HLSC Rejected' or job.job_status == 'Complete'
        hlsc_reject_job_count += 1
        job.update
      end
    end#each
    #to force the batch status of batches  rejected by checks in completed batchlist view only
    if count == hlsc_reject_job_count
      batch.status = BatchStatus['Complete'].to_s
    else
      batch.status = BatchStatus['Processing'].to_s
    end

    batch.jobs.each do |job|
      if job.job_status == 'HLSC Rejected'
        job.job_status = JobStatus['Complete'].to_s
        job.update
      end
    end#each
    batch.update
    flash[:notice] = "Batch #{batch.batchid} resubmitted on to HLSC on request."
    redirect_to :action => 'allocate'
  end

  def payer_list

    @rol=current_remittor.roles
    search_field = params[:to_find]

    compare = params[:compare]
    criteria = params[:criteria]
    search_field.strip! unless search_field.nil?
    if search_field.blank?
      payer_job_count = Job.payer_job_count
    else
      count = Batch.count(:all,:conditions=>"batchid=#{search_field.to_i}")


      if count>0
        search_field1 = Batch.find_by_batchid(search_field).id

        payer_job_count  =Job.find(:all, :conditions => "batch_id = batches.id and batches.status != 'Complete' and batches.status != 'HLSC Verified' and jobs.batch_id=#{search_field1} ",
          #:include => :batch,
          :joins => "LEFT JOIN batches on batch_id = batches.id",
          :group => "jobs.payer_id",

          :select => "sum(jobs.estimated_eob) eobs, count(*) count, jobs.payer_id payer_id")
      else
        flash[:notice] = "No record found for Batch ID= \"#{search_field}\"."
        payer_job_count = Job.payer_job_count
      end
    end

    #other_payers - array of payers with ETC as null.
    #etc_payers - array of payers which have ETC defined.
    other_payers = []
    etc_payers = []
    payer_job_count.each do |p|
      payer = Payer.find(p.payer_id)
      p['payer'] = payer
      job_with_min_eobs = payer.least_time
      unless job_with_min_eobs.nil?
        p['etc'] = job_with_min_eobs.batch.expected_time
        p['tat'] = job_with_min_eobs.batch.contracted_time(@rol[0].name)
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
    payers = etc_payers.sort_by do |payer|
      [payer.tat, payer.etc]
    end
    #Add up other payers without ETC assigned @ the end.
    payers = payers + other_payers
    #@payer_pages, @payers = paginate_collection payers , :per_page => 30 ,:page => params[:page]
    @payers =Payer.paginate(:all, :page => params[:page], :per_page =>10)
  end

  def payer_grouplist

    #payer_job_count=Job.find_by_sql("(SELECT sum(jobs.estimated_eob) eobs, count(*) count,payers.id payer_id from jobs LEFT JOIN batches on  batches.id=jobs.batch_id  and batches.status != 'Complete' and batches.status != 'HLSC Verified' LEFT JOIN payers on payers.id=jobs.payer_id group by payers.payer_group_id) ")
    payer_job_count=Job.find_by_sql("select sum(jobs.estimated_eob) eobs, count(*) count,jobs.payer_id payer_id from payers,batches,jobs where jobs.payer_id=payers.id and payers.payer_group_id!=0  and batches.id=jobs.batch_id  and batches.status != 'Complete' and batches.status != 'HLSC Verified' group by payers.payer_group_id")
    #3 payer_job_count=Job.find_by_sql("select * from jobs")

    #other_payers - array of payers with ETC as null.
    #etc_payers - array of payers which have ETC defined.
    other_payers = []
    etc_payers = []
    payer_job_count.each do |p|
      payergpid = Payer.find_by_id(p.payer_id).payer_group_id

      if payergpid!=0

        payer1=Payergroup.find_by_id( payergpid).payergroupname

        payer3 = Payer.find_by_id(p.payer_id)
        payer2 = TeamLeaderQueue.find_by_payer_group_id( payergpid)
        if payer2.blank?
          p['tlusername'] = 'TL Not Allocated'
        else
          p['tlusername'] = payer2.tlusername
        end

        # puts  payer_job_count
        p['id'] =payergpid

        p['payergroupname'] = payer1


        job_with_min_eobs = payer3.least_time

        unless job_with_min_eobs.nil?
          p['etc'] = job_with_min_eobs.batch.expected_time
          p['tat'] = job_with_min_eobs.batch.contracted_time(@rol[0].name)

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
      #@payer_pages, @payers = paginate_collection payers , :per_page => 20 ,:page => params[:page]
      @payers =Payer.paginate(:all, :page => params[:page], :per_page =>10)

    end
  end

  def jobfind
    payers1=[]
    payers3=[]
    id= params[:id]
    @pgid =  params[:id]
    @id1 = Payer.find_all_by_payer_group_id(params[:id])

    @id1.each do |p|
      @a=Payer.find_by_payid(p.payid).id
      # puts @a

      payer_job_count =Job.find(:all, :conditions => "batch_id = batches.id and batches.status != 'Complete' and batches.status != 'HLSC Verified' and jobs.payer_id = #{@a}",
        #:include => :batch,
        :joins => "LEFT JOIN batches on batch_id = batches.id",
        :group => "jobs.payer_id",
        :select => "sum(jobs.estimated_eob) eobs, count(*) count, jobs.payer_id payer_id")

      #other_payers - array of payers with ETC as null.
      #etc_payers - array of payers which have ETC defined.
      other_payers = []
      etc_payers = []
      payer_job_count.each do |p|
        payer1=Payer.find(p.payer_id)

        # puts  payer_job_count
        p['payid']=p.payer_id
        p['payer'] =payer1

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
    #  @payer_pages, @payers = paginate_collection payers1 , :per_page => 30 ,:page => params[:page]
    @payers =Payer.paginate(:all, :page => params[:page], :per_page =>10)

  end

  def batch_report
    batches = params[:batch_to_delete]
    batch_presence = false
    time_stamp = "#{Time.now.strftime("%Y-%m-%d")}".delete(" ").delete(":").delete("+").delete("+")
    batches.each do |key,value|
      if value == "1"
        batch_presence = true
        break;
      end
    end
    if batch_presence
      if  params[:option1].to_s == "Archive"
        redirect_to :action => 'batch_archive'
        session[:eee] = params[:batch_to_delete]
      else
        batches = params[:batch_to_delete]
        batches.each do |key, value|
          if value == "1"
            search = key
            @batches = Batch.find(:all,:conditions => "batchid = '#{search}'" )
          end
        end
        @isa_identifier = IsaIdentifier.find(:first)
        id_837 = @isa_identifier.isa_number
        @batches.each do |batch|
          @batch = batch
          cms_count = 0
          @jobs = Job.find(:all, :conditions => ["batch_id = #{batch.id}"])
          facilityname = batch.facility.name
          Dir.mkdir("#{Rails.root}/public/data/#{time_stamp}") unless File.exists?("#{Rails.root}/public/data/#{time_stamp}")
          Dir.mkdir("#{Rails.root}/public/data/#{time_stamp}/#{facilityname}") unless File.exists?("#{Rails.root}/public/data/#{time_stamp}/#{facilityname}")

          #if params[:option1].to_s == "XML Report"
          if(batch.batchid.upcase.include?("UB04"))
#            @cms1500s = batch.ub04_claim_informations.find(:all ,:conditions => ["(jobs.job_status='Complete')"], :include => ["ub04_serviceline_informations"], :order=>"ub04_serviceline_informations.rev_code asc, ub04_serviceline_informations.service_date asc, jobs.tiff_number asc")
@cms1500s = batch.ub04_claim_informations.find(:all ,:conditions => ["(jobs.job_status='Complete')"], :include => ["ub04_serviceline_informations"], :order=>"cast(substr(jobs.tiff_number,16) as unsigned)")
          else
            @cms1500s = batch.cms1500s.find(:all ,:conditions => ["(jobs.job_status='Complete')"],:order=>"jobs.tiff_number asc")
          end
          file_name = batch.batchid
          offset = 0
#          limit = 1000
#          if @cms1500s.length > 1000
#            cms_count= (@cms1500s.length/1000.0).ceil
#          else
            id_837 = id_837 + 1
            #if params[:option1].to_s == "XML Report"
            if(batch.batchid.upcase.include?("UB04"))
              if params[:option1].to_s == "XML Report"
                  template = ERB.new(File.open('app/views/admin/batch/ubo4_xml.txt.erb').read)
                  extension =".xml"
              else
                  template = ERB.new(File.open('app/views/admin/batch/pcn_ub04_837.txt.erb').read)
                  extension =".837"
                  template_xml = ERB.new(File.open('app/views/admin/batch/ubo4_check_balancing_xml.txt.erb').read)
                  extension_xml =".xml"
                File.open("public/data/#{time_stamp}/#{facilityname}/#{file_name}" + "#{extension_xml}" , 'w') do |f|
                output_xml = template_xml.result(binding)
                output_xml.gsub!(/\s+$/, '')
                f.puts output_xml
                end
              end
            else
              if(batch.batchid.upcase.include?("AMLI"))
                template = ERB.new(File.open('app/views/admin/batch/837.txt.erb').read)
                extension =".837"
              elsif (batch.batchid.upcase.include?("PCN"))
                template = ERB.new(File.open('app/views/admin/batch/pcn_cms1500_837.txt.erb').read)
                extension =".837"
              elsif (batch.batchid.include?("2790"))
                template = ERB.new(File.open('app/views/admin/batch/2790_cms1500_837.txt.erb').read)
                extension =".837"
              end
            end
           File.open("public/data/#{time_stamp}/#{facilityname}/#{file_name}" + "#{extension}",'w') do |f|
              #        f.puts template.result(binding)
              output = template.result(binding)
              output.gsub!(/\s+$/, '')
              f.puts output
              @isa_identifier = IsaIdentifier.find(:first)
              @isa_identifier.isa_number = id_837
              @isa_identifier.save
            end
#          end
          #If file contains more than 1000 records
#          for cms in 0..cms_count-1
#            id_837 = id_837 + 1
#            #if params[:option1].to_s == "XML Report"
#            if(@batch.batchid.upcase.include?("UB04"))
#              if params[:option1].to_s == "XML Report"
#                @cms1500s = @batch.ub04_claim_informations.find(:all,:conditions => ["(jobs.job_status='Complete')"], :include => ["ub04_serviceline_informations"], :order=>"ub04_serviceline_informations.rev_code asc, ub04_serviceline_informations.service_date asc, jobs.tiff_number asc" , :offset=>offset , :limit=>1000)
#                template = ERB.new(File.open('app/views/admin/batch/ubo4_xml.txt.erb').read)
#                extension =".xml"
#              else
#                @cms1500s = @batch.ub04_claim_informations.find(:all,:conditions => ["(jobs.job_status='Complete')"], :include => ["ub04_serviceline_informations"], :order=>"ub04_serviceline_informations.rev_code asc, ub04_serviceline_informations.service_date asc, jobs.tiff_number asc" , :offset=>offset , :limit=>1000)
#                template = ERB.new(File.open('app/views/admin/batch/pcn_ub04_837.txt.erb').read)
#                extension =".837"
#                template_xml = ERB.new(File.open('app/views/admin/batch/ubo4_check_balancing_xml.txt.erb').read)
#                extension_xml ="xml"
#                File.open("public/data/#{file_name}." + sprintf('%03d', cms + 1) + "#{extension_xml}" , 'w') do |f|
#                output_xml = template_xml.result(binding)
#                output_xml.gsub!(/\s+$/, '')
#                f.puts output_xml
#                end
#              end
#            else
#              if(@batch.batchid.upcase.include?("AMLI"))
#                @cms1500s = @batch.cms1500s.find(:all,:conditions => ["(jobs.job_status='Complete')"], :order=>"jobs.tiff_number asc" , :offset=>offset , :limit=>1000)
#                template = ERB.new(File.open('app/views/admin/batch/837.txt.erb').read)
#                extension =".837"
#              else
#                @cms1500s = @batch.cms1500s.find(:all,:conditions => ["(jobs.job_status='Complete')"], :order=>"jobs.tiff_number asc" , :offset=>offset , :limit=>1000)
#                template = ERB.new(File.open('app/views/admin/batch/pcn_cms1500_837.txt.erb').read)
#                extension =".837"
#              end
#            end
#
#            File.open("public/data/#{file_name}." + sprintf('%03d', cms + 1) + "#{extension}" , 'w') do |f|
#              #        f.puts template.result(binding)
#              output = template.result(binding)
#              output.gsub!(/\s+$/, '')
#              f.puts output
#              offset=limit+offset
#              @isa_identifier = IsaIdentifier.find(:first)
#              @isa_identifier.isa_number = id_837
#              @isa_identifier.update
#            end
#          end
        end
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @cms1500s }
        end
      end
    else
      flash[:notice] = "Please select atleast one batch"
      redirect_to  :action  => "output_batch"
    end
  end

  def batchlist

    @user=current_remittor
    @rol=current_remittor.roles
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]
    #order = "arrival_time desc"
    conditions = " batches.status in ('Processing') and jobs.job_status='Incomplete' "
    unless search_field.blank?
      case criteria
      when 'Batch Date'
        begin
          date = Date.strptime(search_field,"%m/%d/%y")
        rescue ArgumentError
          flash[:notice] = "Invalid date format"
        end
        @batches = Batch.paginate(:conditions => conditions + " and date #{compare} '#{date}'",
          :include => :jobs,:page => params[:page],:per_page => 10)

      when 'Batch ID'
        @batches = Batch.paginate(:conditions => conditions + " and batchid #{compare} '#{search_field.to_s}'",
          :include => :jobs,:page => params[:page],:per_page => 10)

      when 'Site Name'
        @batches = Batch.paginate(:conditions =>  " batches.status in ('Processing','HLSC Rejected') and batches.id=jobs.batch_id and jobs.job_status='Complete' and facilities.name like '%#{search_field}%'",
          :include=>[:jobs,:facility ],:page => params[:page],:per_page => 10)
        flash[:notice] = "String search, #{compare} ignored."
      end

    else
      @batches=Batch.paginate(:conditions=>[" batches.status =? and jobs.job_status = ? and batches.id=jobs.batch_id  ",'Processing','Incomplete'],
        :include=>:jobs,:page => params[:page],:per_page => 10)

    end
    # @batch_pages, @batches = paginate_collection @batches, :per_page => 30 ,:page => params[:page]
    #@batches =Batch.paginate(:all, :page => params[:page], :per_page =>10)


  end
  def incompletedjobs
    @batchid = params[:id]
    @jobs = Job.find(:all, :conditions => ["batch_id =?  and job_status  = 'Incomplete' ", @batchid])
  end

  def status_change

    batchids = params[:batch_to_delete]
    batchids.delete_if do |key,value|
      value == "0"
    end

    if  (batchids.blank? or batchids.size>1)
      flash[:notice]="Please  select one batch to change status"
      redirect_to :controller =>'batch',:action => 'batchlist'

    else
      batchids.keys.each do |id|
        @batchid = id
      end
      batch_id = Batch.find_by_batchid(@batchid).id
      batchcount = Job.count(:all,:conditions=>"job_status not in ('Complete','Incomplete') and batch_id =#{batch_id} ")

      if batchcount>0
        flash[:notice]="You must process all the jobs"
        redirect_to :controller =>'batch',:action => 'batchlist'
      else
        @batch_change = Batch.find(batch_id)
        @batch_change.status = "Output Ready"
        @batch_change.update
        flash[:notice]="changed batch status"
        redirect_to :controller =>'batch',:action => 'batchlist'
      end
    end
  end



  def output_batch

    @user=current_remittor
    @rol=@user.roles


    date_range = params[:date_range]
    date_type = params[:date_type]
    criteria = params[:criteria]
    option =   params[:option_name]


    #search_field.strip! unless search_field.nil?
    if !date_range.blank? or !criteria.blank?
      filtered_batches = filtering_output_batch(date_range, date_type, criteria, option)
      if filtered_batches.size == 0
        flash[:notice] = " No record found "
      else
        batches = filtered_batches
      end
    else
      batches = Batch.where("status IN ('Output Ready','Complete')").order('completion_time')
    end

    @batches = batches.paginate(:page => params[:page], :per_page =>10)   rescue nil
  end

  def filtering_output_batch(daterange,datetype,criteria,option)
       if !daterange.blank?
          date_split = daterange.split('-')
          date_from = date_split[0].strip.to_time.strftime("%Y-%m-%d")
          date_to = date_split[1].strip.to_time.strftime("%Y-%m-%d")

       end

    case criteria
      when 'Batch ID'
        temp_search = option
        batches = Batch.where("batchid like '%#{option.strip}%' AND status IN ('Output Ready','Complete')")
        option = temp_search

        if !daterange.blank?
          case datetype

            when 'arrival'
              batches = batches.where("arrival_time BETWEEN '#{date_from} 00:00:00' AND '#{date_to} 23:59:59'")
            when 'deposit'
              batches = batches.where("date BETWEEN '#{date_from} 00:00:00' AND '#{date_to} 23:59:59'")
            when ''
              batches = batches
          end
        end

      when 'Facility'
        temp_search = option
        batches = Batch.joins('LEFT OUTER JOIN facilities ON facility_id = facilities.id').where("facilities.name = '#{option}' AND batches.status IN ('Output Ready','Complete')")

        option = temp_search
        if !daterange.blank?
          case datetype
            when 'arrival'
              batches = batches.where("arrival_time BETWEEN '#{date_from} 00:00:00' AND '#{date_to} 23:59:59'")

            when 'deposit'
              batches = batches.where("date BETWEEN '#{date_from} 00:00:00' AND '#{date_to} 23:59:59'")

          end
        end

      when ''
        if !daterange.blank?
          case datetype
            when 'arrival'
              batches = Batch.where("arrival_time BETWEEN '#{date_from} 00:00:00' AND '#{date_to} 23:59:59' AND status IN ('Output Ready','Complete')")

            when 'deposit'
              batches = Batch.where("date BETWEEN '#{date_from} 00:00:00' AND '#{date_to} 23:59:59' AND status IN ('Output Ready','Complete')")

          end
        end
    end

    return batches

  end

  def batch_archive

    batchids = session[:eee]
    batchids.each do |key, value|
      if value == "1"
        search = key
        @batches = Batch.find(:first,:conditions => "batchid = '#{search}'" )
      end
    end
    flag = 0
    if (batchids.blank? )
      flash[:notice]="Please select one batch"
      redirect_to :controller =>'batch',:action => 'output_batch'
    else
      @batches.status = "archive"
      @batches.save
      flag = flag + 1
      if (flag > 0)
        flash[:notice]="Batch Archived"
        redirect_to :controller =>'batch',:action => 'output_batch'
      end

    end
  end

  def archive_batch

    @user=current_remittor
    @rol=@user.roles
    batches=Batch.find(:all,:conditions=>" batches.status='archive'")

    @batches =batches.paginate(:page => params[:page], :per_page =>30)


  end

  def batchspit


    @batchid = params[:job1][:countr]
    puts @batchid

    @jobid = Job.find(:first,:conditions=>"batch_id=#{@batchid}",:select=>"id id ,batch_id batchid")
    @eobcount = Batch.find(@batchid)
    @eobcount1 = Job.count(:all,:conditions=>"batch_id=#{@batchid}")
    @job = Job.find_by_batch_id(@batchid)
    @count = @eobcount1
    @batchar=[]
    if @count>1000

      @val =(@count/1000).to_f

      @jid =  (@jobid.id).to_i
      @val = @val.ceil
      for i in 1 .. @val

        @batch = Batch.new
        @batch.batchid=(@eobcount.batchid).to_s+"_"+i.to_s

        @batch.date = @eobcount.date
        @batch.facility_id = @eobcount.facility_id
        @batch.arrival_time = @eobcount.arrival_time
        @batch.target_time = @eobcount.target_time
        @batch.status = @eobcount.status
        @batch.payer_id = @eobcount.payer_id
        @batch.eob =1000
        @batch.save
        @batchar << @batch.id
      end
      @len =   @batchar.length
      @j=0
      for k in 1 .. @len+1

        @offset = 1000
        @jobselect  = Job.find(:all,:conditions=>"batch_id=#{@batchid}  ",:order=>"tiff_number",:limit=>1000,:offset=>"#{@offset}" )
        @jobselect.each do |item|

          item.batch_id =@batchar[@j]
          item.update

        end
        @j= @j+1
      end
      @lastbatch = Batch.find(@batchid)
      @lastbatch.batchid = (@eobcount.batchid).to_s+"_0".to_s
      @lastbatch.update

      @batchvalid =Batch.find(:all,:select=>"max(id) id")
      @batchvalid.each do|c|
        @idval  =  c.id
      end
      @batchval = Job.count(:all,:conditions=>"batch_id=#{@idval}")
      if(@batchval==0)
        Batch.find(@idval).destroy
      end
    end

    redirect_to :controller =>'batch',:action => 'allocate'
  end
     private
  def insert_meta_data(zone_value,page,dpi,field_name,field_value,account_state,record_pointer,confidence)
    record_pointer.update_attribute("#{field_name}","#{field_value}")
    field_ocr_output = field_name+"_ocr_output"
    field_data_origin = field_name+"_data_origin"
    field_number_page = field_name+"_page"
    field_number_coordinates = field_name+"_coordinates"
    field_number_state = field_name+"_state"
    field_number_confidence = field_name+"_confidence"
    record_pointer.details[field_ocr_output.to_sym] = field_value if field_value
    record_pointer.details[field_data_origin.to_sym] = find_the_data_origin_of(account_state.to_s,field_value,confidence)
    record_pointer.details[field_number_page.to_sym] = page
    record_pointer.details[field_number_coordinates.to_sym] = find_the_cordinates_of(zone_value,dpi.to_i)
    record_pointer.details[field_number_state.to_sym] = account_state.to_s
    record_pointer.details[field_number_confidence.to_sym] = confidence.to_i
  end


  def get_values(patient_tag)
    data_point = []
    data_point << patient_tag.xpath('./value').inner_text
    data_point << patient_tag.xpath('./zone').inner_text
    data_point << patient_tag.attributes["state"]
    data_point << patient_tag.xpath('./sources/image').attr('XResolution')
    #data_point << ImagesForJob.find_by_filename(patient_tag.xpath('./sources/image').attr('name')).image_number if ImagesForJob.find_by_filename(patient_tag.xpath('./sources/image').attr('name'))
    data_point << 1
    data_point << patient_tag.attributes["confidence"].text
    return data_point
  end



  def find_the_data_origin_of(value,text,confidence)
    flag = text.to_s.include?("?") unless text.nil? #chances of ? with 100% confidence
    if (value == "Ok" and flag == false and confidence.to_i > 50)
      return 1
    elsif (value == "Reject" or (value == "Ok" and flag == true) or (confidence.to_i < 50))
      return 2
    elsif (value == "Empty" and flag == true)
      return 2
    elsif value == "Empty"
      return 3
    end
  end

  def find_the_cordinates_of(zone_values,dpi)
    split_zone_values = zone_values.split(" ")
    zone_array = []
    for zone in split_zone_values
      zone = zone.to_i
      a = (zone / 10) * 0.039370079 * dpi
      zone_array << a
    end
    return zone_array
  end


  
end
