class Admin::SqaReportController < ApplicationController
 # before_filter :validate_supervisor


  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'

  def sqa_daily_report
    search_field_from_date = params[:to_find1] #Text field for from date
    @search_field2 = params[:to_find2] #text field for 2nd criteria like A/c No., Processor
    search_field_to_date = params[:to_find3] #Text field for to date
       
    @criteria1 = params[:criteria1] #
    @criteria2 = params[:criteria2] #Combo box for selecting criteria (A/c No., Processor)
    @compare2 = params[:compare2] #Combobox for <,=,>
    search_field_from_date.strip! unless search_field_from_date.nil?
    search_field_to_date.strip! unless search_field_to_date.nil?
    @search_field2.strip! unless @search_field2.nil?

   
    if not search_field_from_date.blank?
      if search_field_to_date.blank?
        begin
          Date.strptime(search_field_from_date,"%m/%d/%y")
          @from_date = convert_to_est_time((search_field_from_date.to_time) + 7.hours)
          @to_date = convert_to_est_time(((search_field_from_date.to_time).tomorrow) + 7.hours)
        rescue ArgumentError
          flash[:notice] = "Invalid date format (mm/dd/yy)"
          @from_date = convert_to_est_time(((convert_to_ist_time(Time.now)).at_beginning_of_day) + 7.hours)
          @to_date = convert_to_est_time((((convert_to_ist_time(Time.now)).tomorrow).at_beginning_of_day) + 7.hours)
        end
      else
        begin
          Date.strptime(search_field_from_date,"%m/%d/%y")
          Date.strptime(search_field_to_date,"%m/%d/%y")
          @from_date = convert_to_est_time((search_field_from_date.to_time) + 7.hours)
          @to_date = convert_to_est_time(((search_field_to_date.to_time).tomorrow) + 7.hours)
        rescue ArgumentError
          flash[:notice] = "Invalid date format (mm/dd/yy)"
          @from_date = convert_to_est_time(((convert_to_ist_time(Time.now)).at_beginning_of_day) + 7.hours)
          @to_date = convert_to_est_time((((convert_to_ist_time(Time.now)).tomorrow).at_beginning_of_day) + 7.hours)
        end
      end
    else
      if not search_field_to_date.blank?
        begin
          Date.strptime(search_field_to_date,"%m/%d/%y")
          @from_date = convert_to_est_time((search_field_to_date.to_time) + 7.hours)
          @to_date = convert_to_est_time(((search_field_to_date.to_time).tomorrow) + 7.hours)
        rescue ArgumentError
          flash[:notice] = "Invalid date format (mm/dd/yy)"
          @from_date = convert_to_est_time(((convert_to_ist_time(Time.now)).at_beginning_of_day) + 7.hours)
          @to_date = convert_to_est_time((((convert_to_ist_time(Time.now)).tomorrow).at_beginning_of_day) + 7.hours)
        end
      else
         @from_date = convert_to_est_time(((convert_to_ist_time(Time.now)).at_beginning_of_day) + 7.hours)
	 @to_date = convert_to_est_time((((convert_to_ist_time(Time.now)).tomorrow).at_beginning_of_day) + 7.hours)
      end
    end
    if not @search_field2.blank?
      filtered_report = filter_for_daily_report(@criteria2, @compare2, @search_field2, @from_date, @to_date)
      puts "testttt"
      puts filtered_report
      if filtered_report.size == 0
       
        flash[:notice] = " No record found for <i>#{@criteria2} #{@compare2} \"#{@search_field2}\"</i>"
        redirect_to :action => 'sqa_daily_report'
      else
        puts "else offf size"
        reports = filtered_report
      end
    else  
    reports = EobSqa.find(:all, :conditions => ["sqa_flag_time >= ? and sqa_flag_time <= ?",@from_date.to_time, @to_date.to_time])
    end
    @report_pages, @reports = paginate_collection reports, :per_page => 30 ,:page => params[:page]
  end

  def filter_for_daily_report(field, comp, search, from_date, to_date)
    case field
    when 'QA'
     
    qa = User.find(:first, :conditions => ["name = '#{search}'"])
    if !qa.nil?
    qas_id = qa.id
    reports = EobSqa.find(:all, :conditions => ["qa_id = '#{qas_id}' and sqa_flag_time >= ? and sqa_flag_time <= ?",@from_date.to_time, @to_date.to_time])
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
    reports = EobSqa.find(:all, :conditions => ["sqa_id = '#{sqas_id}' and sqa_flag_time >= ? and sqa_flag_time <= ?",@from_date.to_time, @to_date.to_time])
          if !reports.nil? and reports.length > 0
             return reports
          else
             return []
          end  
    else
    return []
    end
    when 'Batch ID'
      puts comp
      puts search
     #reports = EobSqa.find(:all, :conditions => ["batch_id #{comp} '#{search}' and verify_time >= ? and verify_time <= ?",@from_date.to_time, @to_date.to_time])
      reports = EobSqa.find(:all, :conditions => ["batch_id #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",@from_date.to_time, @to_date.to_time])
      if !reports.nil? and reports.length > 0
             return reports
          else
             return []
          end  
    when 'Batch Date'
        begin
          	date = Date.strptime(search,"%m/%d/%y")
        rescue ArgumentError
            flash[:notice] = "Invalid date format"
        end
        reports = EobSqa.find(:all, :conditions => ["batch_date #{comp} '#{date}' and sqa_flag_time >= ? and sqa_flag_time<= ?",@from_date.to_time, @to_date.to_time])
     when 'Total Fields'
        reports = EobSqa.find(:all, :conditions => ["total_fields #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",@from_date.to_time, @to_date.to_time])
     when 'Incorrect Fields'
        reports = EobSqa.find(:all, :conditions => ["total_incorrect_fields #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",@from_date.to_time, @to_date.to_time])
     when 'Error Code'
         error_name = EobError.find(:first, :conditions => ["code = '#{search}'"])
         if !error_name.nil?
         id = error_name.id
         reports = EobSqa.find(:all, :conditions => ["error_id #{comp} '#{id}' and sqa_flag_time >= ? and sqa_flag_time <= ?",@from_date.to_time, @to_date.to_time])
              if !reports.nil? and reports.length > 0
                return reports
               else
                return []
              end  
         else
         return []
         end
      when 'EOB Accuracy'
        reports = EobSqa.find(:all, :conditions => ["accuracy #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",@from_date.to_time, @to_date.to_time])
      when 'Field Accuracy'
        reports = EobSqa.find(:all, :conditions => ["field_accuracy #{comp} '#{search}' and sqa_flag_time >= ? and sqa_flag_time <= ?",@from_date.to_time, @to_date.to_time])       
    end#case
  end

end
