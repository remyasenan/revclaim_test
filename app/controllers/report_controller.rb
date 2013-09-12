# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

#require 'fastercsv'

class ReportController < ApplicationController

  def export_dailyreport
    puts params[:from_date]
    from_date = params[:from_date].to_time
    puts from_date
    to_date = params[:to_date].to_time
    criteria = params[:criteria]
    compare = params[:compare]
    search_field = params[:search_field]
    search_field.strip! unless search_field.nil?

    if not search_field.blank?
      filtered_report = filter_for_daily_report(criteria, compare, search_field, from_date, to_date)
      reports = filtered_report
    else
      reports = EobReport.find(:all, :select => "eob_reports.*, facilities.sitecode as sitecode", :conditions => ["verify_time >= ? and verify_time <= ?",from_date.to_time, to_date.to_time], :joins => " join batches on batches.batchid = eob_reports.batch_id join facilities on batches.facility_id = facilities.id")
    end

    unless from_date.nil? or to_date.nil? or reports.nil?
      stream_csv("QA_Report_#{from_date.strftime('%m/%d/%y')}_to_#{to_date.strftime('%m/%d/%y')}") do |csv|
        csv << ["QA Staffs", "Current Day", "Group", "User Name", "Site Number", "Batch Date", "Batch ID", "Payer ID", "Account Number",
          "Error Severity", "Description of Error", "Total Fields", "Incorrect Fields", "Error Code", "Accuracy"]
        reports.each do |report|
          csv << [report.qa,
            (convert_to_ist_time(report.verify_time)).strftime('%m/%d/%y %H:%M'),
            "RevMed",
            report.processor,
            report.sitecode,
            (report.batch_date).strftime('%m/%d/%y'),
            report.batch_id,
            report.payer,
            report.account_number,
            report.error_severity,
            report.error_type,
            report.total_fields,
            report.incorrect_fields,
            report.error_code,
            report.accuracy]
        end
      end
    else
      flash[:notice] = "No matching report found."
      redirect_to :action => "qa_daily_report", :controller => "/admin/qa_report"
    end
  end

  # Clean all of this up so that the same query logic is executed for all paths.
  def filter_for_daily_report(field, comp, search, from_date, to_date)
    case field
    when 'Account Number'
      reports = EobReport.find(:all, :select => "eob_reports.*, facilities.sitecode as sitecode", :conditions => ["account_number = ? and verify_time >= ? and verify_time <= ?", search, from_date.to_time, to_date.to_time], :joins => " join batches on batches.batchid = eob_reports.batch_id join facilities on batches.facility_id = facilities.id")
    when 'Processor'
      reports = EobReport.find(:all, :conditions => ["processor = '#{search}' and verify_time >= ? and verify_time <= ?",from_date.to_time, to_date.to_time])
    when 'Accuracy %'
      reports = EobReport.find(:all, :conditions => ["Accuracy #{comp} '#{search}' and verify_time >= ? and verify_time <= ?",from_date.to_time, to_date.to_time])
    when 'QA'
      reports = EobReport.find(:all, :conditions => ["qa = '#{search}' and verify_time >= ? and verify_time <= ?",from_date.to_time, to_date.to_time])
    when 'Batch ID'
      reports = EobReport.find(:all, :select => "eob_reports.*, facilities.sitecode as sitecode", :conditions => ["batch_id = ? and verify_time >= ? and verify_time <= ?", search, from_date.to_time, to_date.to_time], :joins => " join batches on batches.batchid = eob_reports.batch_id join facilities on batches.facility_id = facilities.id")
    when 'Batch Date'
      begin
        date = Date.strptime(search,"%m/%d/%y")
      rescue ArgumentError
        flash[:notice] = "Invalid date format"
      end
      reports = EobReport.find(:all, :conditions => ["batch_date #{comp} '#{date}' and verify_time >= ? and verify_time<= ?",from_date.to_time, to_date.to_time])
    when 'Total Fields'
      reports = EobReport.find(:all, :conditions => ["total_fields #{comp} '#{search}' and verify_time >= ? and verify_time <= ?",from_date.to_time, to_date.to_time])
    when 'Incorrect Fields'
      reports = EobReport.find(:all, :conditions => ["incorrect_fields #{comp} '#{search}' and verify_time >= ? and verify_time <= ?",from_date.to_time, to_date.to_time])
    when 'Error Severity'
      reports = EobReport.find(:all, :conditions => ["error_severity #{comp} '#{search}' and verify_time >= ? and verify_time <= ?",from_date.to_time, to_date.to_time])
    when 'Error Code'
      reports = EobReport.find(:all, :conditions => ["error_code like '%#{search}%' and verify_time >= ? and verify_time <= ?",from_date.to_time, to_date.to_time])
      reports = reports.select do |report|
        report.eob_error.code == search
      end
    when 'Status'
      reports = EobReport.find(:all, :conditions => ["status like '%#{search}%' and verify_time >= ? and verify_time <= ?",from_date.to_time, to_date.to_time])
    end
  end
  
  def export_qa_monthly_report
    search_field = params[:search_field]
    compare = params[:compare]
    criteria = params[:criteria]
    search_field.strip! unless search_field.nil?
    @from_date = params[:from_date].to_time
    @to_date = params[:to_date].to_time
    
    if not search_field.blank?
      if @criteria == 'Date'
        begin
          date = Date.strptime(@search_field,"%m/%d/%y")
          @from_date = convert_to_est_time((@search_field.to_time).at_beginning_of_month)
          @to_date = convert_to_est_time(((@search_field.to_time).at_beginning_of_month).months_since(1))
        rescue ArgumentError
          flash[:notice] = "Invalid date format"
        end
      end
      reports = filtering_error(search_field, compare, criteria, @from_date, @to_date)
    else
      reports = EobReport.find(:all, :conditions => ["verify_time >= ? and verify_time < ?", @from_date, @to_date],
        :group => "qa, processor",
        :select => "id, sum(incorrect_fields) incorrect_fields, sum(total_fields) total_fields, verify_time, processor, qa",
        :order => "processor")
    end
  
    unless reports.nil?
      stream_csv("QA_Monthly_Report_#{@from_date.strftime('%m/%d/%y')}_to_#{@to_date.strftime('%m/%d/%y')}") do |csv|
        csv << ["Date",
          "Processor",
          "QA Staff",
          "Total EOB's QA Checked",
          "Total EOB's QA Rejected",
          "Errors(%)"]
        reports.each do |r|
          report = EobReport.find(r.id)
          qa = User.find_by_userid(report.qa)
          processor =User.find_by_userid(report.processor)
          csv << [report.verify_time,
            report.processor,
            report.qa,
            qa.eobs_qaed(processor),
            qa.rejected_eobs_qaed(processor),
            (qa.rejected_eobs_qaed(processor).to_f / qa.eobs_qaed(processor).to_f) * 100]
        end
      end
    else
      flash[:notice] = "No matching report found."
      redirect_to :action => "qa_monthly_report", :controller => "/admin/qa_report"
    end
  end
  
  def filtering_error(search, comp, field, from_date, to_date)
    case field
    when 'Processor'
      reports = EobReport.find(:all, :conditions => ["processor = '#{search}' and verify_time >= ? and verify_time < ?",from_date.to_time, to_date.to_time],
        :select => "id, sum(incorrect_fields) incorrect_fields, sum(total_fields) total_fields, verify_time, processor, qa",
        :group => "qa, processor")
    when 'Date'
      reports = EobReport.find(:all, :conditions => ["verify_time >= ? and verify_time < ?",from_date.to_time, to_date.to_time],
        :select => "id, sum(incorrect_fields) incorrect_fields, sum(total_fields) total_fields, verify_time, processor, qa",
        :group => "qa, processor")
    when 'Error %'
      reports = EobReport.find(:all, :conditions => ["verify_time >= ? and verify_time < ?",from_date.to_time, to_date.to_time],
        :group => "qa, processor",
        :select => "id, sum(incorrect_fields) incorrect_fields, sum(total_fields) total_fields, verify_time, processor, qa")
      reports = reports.select do |error|
        qa = User.find_by_userid(error.qa)
        processor = User.find_by_userid(error.processor)
        currect_eobs = qa.eobs_qaed(processor)
        incorrect_eobs = qa.rejected_eobs_qaed(processor)
        case comp
        when '='
          (incorrect_eobs.to_f / currect_eobs.to_f) * 100 == search.to_f
        when '>'
          (incorrect_eobs.to_f / currect_eobs.to_f) * 100  > search.to_f
        when '<'
          (incorrect_eobs.to_f / currect_eobs.to_f) * 100  < search.to_f
        end
      end
    when 'Total EOBs QA Checked'
      reports = EobReport.find(:all, :conditions => ["verify_time >= ? and verify_time < ?",from_date.to_time, to_date.to_time],
        :group => "qa, processor",
        :select => "id, sum(incorrect_fields) incorrect_fields, sum(total_fields) total_fields, verify_time, processor, qa")
      reports = reports.select do |error|
        qa = User.find_by_userid(error.qa)
        processor = User.find_by_userid(error.processor)
        currect_eobs = qa.eobs_qaed(processor)
        case comp
        when '='
          currect_eobs.to_f == search.to_f
        when '>'
          currect_eobs.to_f  > search.to_f
        when '<'
          currect_eobs.to_f  < search.to_f
        end
      end
    when 'Total EOBS QA Rejected'
      reports = EobReport.find(:all, :conditions => ["verify_time >= ? and verify_time < ?",from_date.to_time, to_date.to_time],
        :group => "qa, processor",
        :select => "id, sum(incorrect_fields) incorrect_fields, sum(total_fields) total_fields, verify_time, processor, qa")
      reports = reports.select do |error|
        qa = User.find_by_userid(error.qa)
        processor = User.find_by_userid(error.processor)
        incorrect_eobs = qa.rejected_eobs_qaed(processor)
        case comp
        when '='
          incorrect_eobs.to_f == search.to_f
        when '>'
          incorrect_eobs.to_f  > search.to_f
        when '<'
          incorrect_eobs.to_f  < search.to_f
        end
      end
    end
    return reports
  end

  def export_completed_batches_report
    from_date = params[:from_date].to_time
    to_date = params[:to_date].to_time
    search_field2 = params[:to_find2]
    criteria2 = params[:criteria2]
    compare2 = params[:compare2]
    search_field2.strip! unless search_field2.nil?

    conditions = " client_status_histories.status = 'HLSC Verified' and (batches.correspondence = 0 or batches.correspondence is null)"
    if not search_field2.blank?
      case criteria2
      when "Batch ID"
        temp_search = search_field2
        temp_search = temp_search.to_i
        complete_reports = ClientStatusHistory.find(:all,
          :include => :batch,
          :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
          :conditions => [conditions + " and client_status_histories.time > ? and client_status_histories.time < ? and c2.batch_id is null and batches.batchid #{compare2} #{temp_search}",from_date,to_date])
      when "Batch Date"
        begin
          date = Date.strptime(search_field2,"%m/%d/%y")
        rescue ArgumentError
          flash[:notice] = "Invalid date format"
        end
        complete_reports = ClientStatusHistory.find(:all,
          :include => :batch,
          :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
          :conditions => [conditions + " and client_status_histories.time > ? and client_status_histories.time < ? and c2.batch_id is null and batches.date #{compare2} '#{date}'",from_date,to_date])
      end
    else
      complete_reports = ClientStatusHistory.find(:all,
        :include => :batch,
        :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
        :conditions => [conditions + " and client_status_histories.time > ? and client_status_histories.time < ? and c2.batch_id is null",from_date,to_date])
    end

    if complete_reports.size < 1
      flash[:notice] = "No Match Found"
      from_date = (Time.now.to_time).at_beginning_of_day
      to_date = (Time.now.to_time).tomorrow.at_beginning_of_day
      complete_reports = ClientStatusHistory.find(:all,
        :include => :batch,
        :joins => "left join client_status_histories c2 on client_status_histories.batch_id = c2.batch_id and c2.time > client_status_histories.time",
        :conditions => [conditions + " and client_status_histories.time > ? and client_status_histories.time < ? and c2.batch_id is null",from_date,to_date])
    end

    unless complete_reports.nil?
      stream_csv("CompletedBatchesReport_#{from_date.strftime('%m/%d/%y')}_to_#{to_date.strftime('%m/%d/%y')}") do |csv|
        csv << ["User ID",
          "Batch ID",
          "Batch Facility",
          "Batch Date",
          "Batch Completed Time",
          "HLSC Verified Time"]
        complete_reports.each do |report|
          #report = ClientStatusHistory.find(report)
          csv << [report.user,
            report.batch.batchid,
            report.batch.facility.name,
            (report.batch.date).strftime('%m/%d/%y'),
            (report.batch.completion_time).strftime('%m/%d/%y %H:%M'),
            (report.time).strftime('%m/%d/%y %H:%M')]
        end
      end
    else
      flash[:notice] = "No matching report found."
      redirect_to :action => "completed_batches_report", :controller => "hlsc"
    end
  end

  def stream_csv(title)
    filename = title + ".csv"

    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain"
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
      headers['Expires'] = "0"
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end

    render :text => Proc.new { |response, output|
      csv = CSV.new(output, :row_sep => "\r\n")
      yield csv
    }
  end
  
  def export_tat_report
    facilities = params[:facilities]
    query_facilities = params[:query_facilities]
    to_date = params[:to_date]
    from_date = params[:from_date]
    from_time = params[:from_time]
    to_time = params[:to_time]
    time_flag = 0 
    if from_time == "00:00:00" and to_time == "23:59:59"
      time_flag = 1
    end
    if time_flag == 1
      if not facilities.blank? or (not query_facilities.blank?)
        tat_reports = filter_tat_batches(from_date, to_date, facilities, query_facilities)
      else
        tat_reports = Batch.find(:all, :conditions => "status in ('HLSC Verified', 'Complete') and date >= '#{from_date}' and date <= '#{to_date}'", :include => :facility)  
      end
    else
      if not facilities.blank? or (not query_facilities.blank?)
        tat_reports = filter_tat_batches_time(from_date, to_date, facilities, query_facilities,from_time,to_time) 
      else
        filter_from_date = "#{from_date}"+" "+"#{from_time}"
        filter_to_date = "#{to_date}"+" "+"#{to_time}"
        tat_reports = Batch.find(:all, :conditions => "status in ('HLSC Verified', 'Complete') and completion_time >= '#{filter_from_date}' and completion_time <= '#{filter_to_date}'", :include => :facility)
      end
    end
    unless tat_reports.nil?
      stream_csv("TATReport_#{(Time.now).strftime('%m/%d/%y %H:%M')}") do |csv|
        csv << ["Batch ID",
          "Batch Date",
          "Facility",
          "Arrival Time",
          "Completion Time",
          "Contracted Time",
          "Difference",
          "EOB Count"]
        tat_reports.each do |batch|
          csv << [batch.batchid,
            (batch.date).strftime('%m/%d/%y'),
            batch.facility.name,
            (batch.arrival_time).strftime('%m/%d/%y %H:%M'),
            (batch.completion_time).strftime('%m/%d/%y %H:%M'),
            (batch.arrival_time + batch.facility.client.tat.hours).strftime('%m/%d/%y %H:%M'),
            unless batch.completion_time.nil?
              sprintf("%.2f", (batch.completion_time - (batch.arrival_time + batch.facility.client.tat.hours))/3600)
            end,
            batch.get_completed_eobs
          ]
        end
      end
    else
      flash[:notice] = "No matching report found."
      redirect_to :controller => "admin/admin_report", :action => "tat_report"
    end
  end
	
  def filter_tat_batches(from, to, facilities, query_facilities)
    conditions = " and (date >= '#{from}' and date <= '#{to}')"
    if not query_facilities.nil?
      query = " and facilities.name in (#{query_facilities})"
    else
      query = " and facilities.id in (#{facilities})"
    end
			
    batches = Batch.find(:all, :conditions => "status in ('HLSC Verified', 'Complete')" + conditions + query,
      :include => :facility)    
  end
  #FILTERS WITH COMPLETION TIME IF TO & FROM TIME IS GIVEN
  def filter_tat_batches_time(from_date, to_date, facilities, query_facilities,from_time,to_time)
    @filter_from_date = "#{from_date}"+" "+"#{from_time}"
    @filter_to_date = "#{to_date}"+" "+"#{to_time}"
    puts @filter_from_date
    if not query_facilities.nil?
      query =  " and facilities.name in (#{query_facilities})"
    else
      query = " and facilities.id in (#{facilities})"
    end
    batches = Batch.find(:all, :conditions => ["status in ('HLSC Verified', 'Complete') #{query} and (completion_time >= ? and completion_time <= ? )  ", @filter_from_date , @filter_to_date],:include => [{:facility => :client}])
    puts batches
    if !batches.nil? and batches.length > 0
      return batches
    else
      return []
    end
  end
  def export_processor_facility_report
    user = User.find(params[:user])
    unless params[:date_from].nil?
      @date_from = params[:date_from]
      @date_to = params[:date_to]
      time_from = (params[:date_from] + " 00:00:00").to_time
      time_to = (params[:date_to] + " 23:59:59").to_time
    else
      time_to = Time.now
      time_from = time_to - 1.days
      @date_from = Date.strptime(time_from.strftime("%m/%d/%y"), "%m/%d/%y")
      @date_to = Date.strptime(time_to.strftime("%m/%d/%y"), "%m/%d/%y")
    end
        
    facility_jobs = user.facility_jobs(time_from, time_to)
    unless facility_jobs.nil?
      stream_csv("User_Facility_Report(#{@date_from}-#{@date_to})") do |csv|
        csv << ["Facility", "Job Count", "EOB Count"]
        facility_jobs.each do |fj|
          csv << [fj.facility_name,
            fj.job_count,
            fj.eob_count]
        end
      end
    else
      flash[:notice] = "No jobs were found to export"
      redirect_to :controller => 'admin/user', :action => 'processor_facility_jobs', :date_from =>params[:date_from], :date_to => params[:date_to], :id => params[:id], :user => params[:user]
    end
  end
        
  def export_sqa_dailyreport 

    from_date = params[:from_date].to_time
    to_date = params[:to_date].to_time
    criteria = params[:criteria]
    compare = params[:compare]
    search_field = params[:search_field]
    search_field.strip! unless search_field.nil?
    if not search_field.blank?
      filtered_report = filter_for_sqa_daily_report(criteria, compare, search_field, from_date, to_date)
      reports = filtered_report
    else
      reports = EobSqa.find(:all, :conditions => ["sqa_flag_time >= ? and sqa_flag_time <= ?",from_date.to_time, to_date.to_time])
    end
  

    unless from_date.nil? or to_date.nil? or reports.nil?
      stream_csv("SuperQA_Report_#{from_date.strftime('%m/%d/%y')}_to_#{to_date.strftime('%m/%d/%y')}") do |csv|
        csv << ["SuperQA Staffs", "Current Day", "Group", "QA Staffs", "Site Number", "Batch Date", "Batch ID", "Payer ID", "Check Number",
          "Error Severity", "Description of Error", "Total Fields", "Incorrect Fields", "Error Code", "EOB Accuracy", "Field Accuracy"]
        reports.each do |report|
          job = Job.find_by_id(report.job_id)
          user_sqa = User.find_by_id(report.sqa_id)
          user_qa = User.find_by_id(report.qa_id)
          errcode = EobError.find_by_id(report.error_id)
          csv << [user_sqa.name,
            (convert_to_ist_time(report.sqa_flag_time)).strftime('%m/%d/%y %H:%M'),
            "RevMed",
            user_qa.name, 
            job.batch.facility.sitecode, 
            (job.batch.date).strftime('%m/%d/%y'),
            job.batch.batchid,
            job.payer.payid,
            job.check_number,
            errcode.severity,
            errcode.error_type,
            report.total_fields,
            report.total_incorrect_fields,
            errcode.code,
            report.accuracy,
            report.field_accuracy]

                
        end
        
      end
    else
      flash[:notice] = "No matching report found."
      redirect_to :action => "qa_daily_report", :controller => "/admin/qa_report"
    end
  
  end#export_sqa_dailyreport  
  def filter_for_sqa_daily_report(field, comp, search, from_date, to_date)
    puts "inside filter"
    case field
    when 'QA'
      qa = User.find(:first, :conditions => ["name = '#{search}'"])
      if !qa.nil?
        qas_id = qa.id
        reports = EobSqa.find(:all, :conditions => ["qa_id = '#{qas_id}' and sqa_flag_time >= ? and sqa_flag_time <= ?",from_date.to_time, to_date.to_time])
        if !reports.nil? and reports.length > 0
          return reports
        else
          return []
        end  
      else
        return []
      end
    when 'SuperQA'
      sqa = User.find(:first, :conditions => ["name = '#{search}'"])
      if !sqa.nil?
        sqas_id = sqa.id
        reports = EobSqa.find(:all, :conditions => ["sqa_id = '#{sqas_id}' and sqa_flag_time >= ? and sqa_flag_time <= ?",from_date.to_time, to_date.to_time])
        if !reports.nil? and reports.length > 0
          return reports
        else
          return []
        end  
      else
        return []
      end
    when 'Batch ID'
      reports = EobSqa.find(:all, :conditions => ["batch_id #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",from_date.to_time, to_date.to_time])
    when 'Batch Date'
      begin
        date = Date.strptime(search,"%m/%d/%y")
      rescue ArgumentError
        flash[:notice] = "Invalid date format"
      end
      reports = EobSqa.find(:all, :conditions => ["batch_date #{comp} '#{date}' and sqa_flag_time >= ? and sqa_flag_time<= ?",from_date.to_time, to_date.to_time])
    when 'Total Fields'
      reports = EobSqa.find(:all, :conditions => ["total_fields #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",from_date.to_time, to_date.to_time])
    when 'Incorrect Fields'
      reports = EobSqa.find(:all, :conditions => ["total_incorrect_fields #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",from_date.to_time, to_date.to_time])
    when 'Error Code'
      error_name = EobError.find(:first, :conditions => ["code = '#{search}'"])
      if !error_name.nil?
        id = error_name.id
        reports = EobSqa.find(:all, :conditions => ["error_id #{comp} '#{id}' and sqa_flag_time >= ? and sqa_flag_time <= ?",from_date.to_time, to_date.to_time])
        if !reports.nil? and reports.length > 0
          return reports
        else
          return []
        end  
      else
        return []
      end
    when 'EOB Accuracy'
      reports = EobSqa.find(:all, :conditions => ["accuracy #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",from_date.to_time, to_date.to_time])
    when 'Field Accuracy'
      reports = EobSqa.find(:all, :conditions => ["field_accuracy #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",from_date.to_time, to_date.to_time])       
    end#case
  end

  private :stream_csv
end
