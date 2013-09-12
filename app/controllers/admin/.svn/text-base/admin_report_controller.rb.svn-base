# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Admin::AdminReportController < ApplicationController
  layout 'standard'

  def index
    redirect_to :action => 'tat_report'
  end

  def tat_report
   
    sort_field = params[:sort] || "date"
    @all_facilities = {}
    Facility.find(:all).each do |f|
      @all_facilities[f.name] = f.id
    end

    @all_facilities = @all_facilities.sort_by {|name, id| name}

    @selected_facilities = []
    
    unless params[:facilities].nil?
       
        # selected = facility id
        @selected = params[:facilities]
        # TODO: Review this. I don't think it is producing the right output (HCR)
          @selected.each do |sf|
            @selected_facilities << sf.to_i
             end
        @selected = @selected.join(", ")
        #not joining 
        
      query = " and facilities.id in (#{@selected})"
    else
      query = "".to_s
    end

    
    #these two are used to retain date range after search
    #if no date selected date = (todays date-7) to tomoroow
    @date_to = params[:date_to]
    @date_from = params[:date_from]
    from = params[:date_from].strip unless params[:date_from].nil?
    to = params[:date_to].strip unless params[:date_to].nil?
    if from =~ /\d{4}\-\d{1,2}\-\d{1,2}/
      @from_date = from
      @to_date = to
    else  
      if not from.blank?
        @from_date = Date.strptime(from, "%m/%d/%y")
        if not to.blank?
          @to_date = Date.strptime(to, "%m/%d/%y")	
        else
          # if from time is there and to is not there then to = tomorows time
          to = from.to_time.tomorrow.strftime("%m/%d/%y")
          @to_date = Date.strptime(to, "%m/%d/%y")
        end
      else
        
        from = (Time.now - 7.days).strftime("%m/%d/%y")
        @from_date = Date.strptime(from, "%m/%d/%y")
        to = Time.now.tomorrow.strftime("%m/%d/%y")
        @to_date = Date.strptime(to, "%m/%d/%y")
      end
    end
    
 
    
    
# initialises the from_time and to_time if no time is given
   @from_time = params[:from_find]
   @to_time = params[:to_find]
   time_from = params[:from_find].strip unless params[:from_find].nil?
   time_to = params[:to_find].strip unless params[:to_find].nil?
  
     
   if not time_from.blank? or (not time_to.blank?)
    if time_from.blank? 
      @from_time = "00:00:00"
    end 
    if time_to.blank?
      @to_time ="23:59:59"
    end 
   else
      @from_time = "00:00:00"
      @to_time ="23:59:59"
   end    
   
    #filters if from_time and to_time is given

    #if not params[:facilities].blank? or (not params[:query].nil?) or (not search_from.blank? or not search_to.blank?)
    if not params[:facilities].blank? or (not params[:query].nil?) or (not params[:from_find].blank? or not params[:to_find].blank?)
   
    if params[:query].nil? 
        batches = filter_batches(@from_date, @to_date, query)
        
    else
        @query = params[:query]
        actual_query = " and facilities.name in (#{@query})"
        batches = filter_batches(@from_date, @to_date, actual_query)
      end
    if not params[:to_find].blank? or (not params[:from_find].blank?)
      #if (not search_from.blank? or not search_to.blank?) 
        batches = filtering_batch(@from_time,@to_time,query,@from_date,@to_date)
    end
      
    else
      #batches = Batch.find(:all, :conditions => "status in ('HLSC Verified', 'Complete')", :include => [{:facility => :client}])
      batches = Batch.find(:all, :conditions => "status in ('HLSC Verified', 'Complete') and (date >= '#{@from_date}' and date <= '#{@to_date}')", :include => [{:facility => :client}])
    
    end


    
    unless params[:facilities].blank?
      query_detail = QueryDetail.new
      query_detail.from = @from_date
      query_detail.to = @to_date
      # inserts the from time and to time in to table for previous queries
      query_detail.from_time = @from_time
      query_detail.to_time = @to_time
      names = []
      unless params[:facilities].blank?
        params[:facilities].select do |f|
          names << Facility.find(f).name
        end
        names = names.join(", ")
      else
        names = "all facilities"
      end
      query_detail.criteria = names
      query_detail.save
    end
 
 
    if batches.length > 0
      flash[:notice] = nil
      @com_time, @con_time, @sum_of_diff = 0, 0, 0

      batches.each do |b|
        batch_completion = b.completion_time.to_f 
        batch_contracted = b.contracted_time('Supervisor').to_f 
        diff = batch_completion - batch_contracted

        if b.completion_time.nil? then
          logger.error "Batch with batchid = #{b.batchid} and id = #{b.id} is #{b.status} but has NULL completion_time!"
          b['mean'] = 0
        else
          # TODO: Not a big thing, but I'd compute the difference once and then add that to the sum.
          @sum_of_diff += (batch_completion - batch_contracted)
          b['mean'] = diff
        end
      end

      mean_difference = @sum_of_diff / batches.length
      #mean_difference is the mean completion time difference of all batches
      delta = 0
      #delta is the sum of the difference between mean_difference and actual
      #difference for the batch. Used for calculating variance and STD.
      batches.each do |batch|
        delta += ((batch.mean - mean_difference)/3600).round.power!(2)
      end
      @std_dev = Math.sqrt(delta / batches.length)

      @batches_sorted = batches.sort_by do |b|
        b.mean
      end

      batches = batches.sort_by do |b|
        if sort_field =~ /date/
          b.date
        elsif sort_field =~ /batchid/
          b.batchid
        elsif sort_field =~ /facility/
          b.facility.name
        else
          b.completion_time
        end
      end

      if sort_field =~ /_reverse/
        batches = batches.reverse
      end
    else
   
     flash[:notice] = "No reports found."
    end

    @batch_pages, @batches = paginate_collection batches, :per_page => 30 ,:page => params[:page]
  end

  def filter_batches(from, to, query)
    conditions = " and (date >= '#{from}' and date <= '#{to}')"
    batches = Batch.find(:all, :conditions => "status in ('HLSC Verified', 'Complete') #{query}" + conditions, :include => [{:facility => :client}])
    if !batches.nil? and batches.length > 0
      return batches
    else
      return []
    end  	
  end

  def show_query
    flash[:notice] = nil
    queries = QueryDetail.find(:all)
    @query_pages, @queries = paginate_collection queries, :per_page => 15, :page => params[:page]
  end

  def execute_query
    query = QueryDetail.find(params[:id])
    facilities = query.criteria.split(', ')
    facilities = facilities.map {|f| '"'+f+'"'}
    facility = facilities.join(', ')
    redirect_to :action => 'tat_report', :date_from => query.from, :date_to => query.to, :query => facility , :search_from => query.from_time , :search_to => query.to_time
  end

  def distribution
    criteria = params[:criteria]
    compare = params[:compare]
    to_find = params[:to_find]
    date_from = params[:date_from]
    date_to = params[:date_to]
    created_at = params[:created_at]
    unless date_from.blank?	
      begin
        date_from = Date.strptime(date_from,"%m/%d/%y")
      rescue
        flash[:notice] = 'Invalid date format'
      end
      if date_to.blank?
        date_to = date_from.to_time.tomorrow
      else
        begin
          date_from = Date.strptime(date_from,"%m/%d/%y")
        rescue
          flash[:notice] = 'Invalid date format'
        end
      end
    end	

    if not to_find.blank?
      batches = filter_batches_distribution(criteria, compare, to_find, date_from, date_to)
    else
      batches = Batch.find(:all, :conditions => "status = 'HLSC Verified'",
        :joins => "left join facilities on batches.facility_id = facilities.id",
        :group => "facilities.id",
        :select => "count(batches.batchid) batch_count, facilities.name facility_name, facilities.sitecode sitecode")
    end													 
    @batch_pages, @batches = paginate_collection batches, :per_page => 30 ,:page => params[:page]  														 
  end

  def filter_batches_distribution(criteria, compare, to_find, date_from, date_to)
    if !date_from.blank?
      conditions = " and batches.date >= '#{date_from}' and batches.date <= '#{date_to}'"
    else
      conditions = " ".to_s
    end

    case criteria
    when 'Lockbox'
      batches = Batch.find(:all, :conditions => "status = 'HLSC Verified' and facilities.name like '#{to_find}'" + conditions,
        :joins => "left join facilities on batches.facility_id = facilities.id",
        :group => "facilities.id",
        :select => "count(batches.batchid) batch_count, facilities.name facility_name, facilities.sitecode sitecode")
    when 'Shift'
      #TODO:add shift
    end 
  end

  def tat_compliance
  end

  def next_shift
  end
#filters the batch with the selected time
def filtering_batch(search_from,search_to,query,from_date,to_date)
 @filter_from_date = "#{from_date}"+" "+"#{search_from}"
 @filter_to_date = "#{to_date}"+" "+"#{search_to}"
 batches = Batch.find(:all, :conditions => ["status in ('HLSC Verified', 'Complete') #{query} and (completion_time >= ? and completion_time <= ? )  ", @filter_from_date , @filter_to_date],:include => [{:facility => :client}])
 if !batches.nil? and batches.length > 0
      return batches
    else
      return []
    end  
  end
end
