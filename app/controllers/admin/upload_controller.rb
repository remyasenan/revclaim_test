#################################################################
# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.
#Product:Revlogic
#Version:
#Author :
#Modified by Anoop
#Modified date 27/11/2007
#####################################################################
class Admin::UploadController < ApplicationController
  layout 'standard'
  
  #before_filter :validate_supervisor
  include AuthenticatedSystem
  include RoleRequirementSystem
  
  def upload
    @type = params[:type]
    @batch = params[:batch]
  end
  #Using a gem for upload string with commas
  #Modified by anoop
  require 'csv'  #Using CSV for parsing
  def create
    logger.debug "In UploadController#create"
    @batch = params[:batch]
    @type = params[:type]
    
    #variables for printing suitable flash messages
    r  = 0
    l  = 0
    # modification starts here
    
    if @type=='payer'
      j = 0
      @parsed_file=CSV::Reader.parse(params[:upload][:file])
      n = 0
      @parsed_file.each  do |row|
  
        c = Payer.new
        c.gateway = row[0]
        c.payid = row[2]
        c.payer = row[1]
        # TODO: Find out why below isn't row[3]
        c.gr_name = ""
        c.pay_address_one = row[4]
        c.pay_address_two = row[5]
        c.pay_address_three = row[6]
        c.pay_address_four = row[7]
        c.phone = row[8]
        id = row[2]
      
        person = Payer.find_by_payid(id)  
        if person.blank?
          # for skipping first line from csv
          if (j>=1)
            if   c.save
              r  = r + 1
              n = n + 1
            end
          end
        
          GC.start if n%50 == 0
         
        else
          t = person.payid 
          @p1 = Payer.find_by_payid(t)
          @p1.gateway = row[0]
          @p1.payid = row[2]
          @p1.payer = row[1]
          # TODO: Find out why below isn't row[3]
          @p1.gr_name = ""
          @p1.pay_address_one = row[4]
          @p1.pay_address_two = row[5]
          @p1.pay_address_three = row[6]
          @p1.pay_address_four = row[7]
          if  !row[1].blank?
            @p1.save
            l = l + 1
          end              
        end

        #flash.now[:message]="CSV Import Successful,  #{n} new records added to data base"
        # end 
        j = j + 1
 
      end 
      if r>0 and l==0
        flash[:notice]  = "CSV Import Successful,  #{n} New Records Added to Data Base"
      elsif r>0 and l>0
        flash[:notice]  = " #{n} New Records Added to Data Base and Remaining are Updated"
      elsif r==0 and l>0
        flash[:notice]  = "Updated"
      end
      redirect_to :controller => '/admin/upload', :action => 'upload' , :batch => @batch, :type => @type
  
  
      #modification ends here
  
      # from these 'else' working same as with switch case
    else
  
      if request.post?
        data = params[:upload][:file].read
        logger.debug "Read data  from #{params[:upload][:file]}"
      end
    
      file = params[:upload][:file]
      i = 0
      bad_record_count = 0
      flash[:notice] = " "
      begin
      
        data.each do |line|
        
   
          i = i + 1
          unless i == 1 # TODO: Dirty hack to skip the first line (HEADER).
            case params[:type]
              # Parse the user CSV file.
            when 'user'
              # Expected column order for user CSV file
              # Name, Userid, Password, Role, Shift
              user = User.new
              name,userid,password,role,shift,triad_client,other_client = line.split(',')
            
              user.name = strip(name,'"')
              puts strip(name,'"')
              user.userid = strip(userid,'"')
              user.password = strip(password,'"')
              user.role = strip(role,'"')
              user.shift = strip(shift,'"')
              user.processing_rate_triad = strip(triad_client,'"')
              user.processing_rate_others = strip(other_client,'"')
              if user.processing_rate_triad == nil
                user.processing_rate_triad = 5
              end
              if user.processing_rate_others == nil
                user.processing_rate_others = 8
              end
              if user.role != 'Processor'
                user.rating = 'NA'
              end
              user.save
            
              if user.errors.entries.size > 0
                bad_record_count = bad_record_count + 1
                user.errors.entries.each do |error|
                  flash[:notice] = flash[:notice] + " User #{user.name}  has an error : #{error}<br/>"
                end
              end
          
              # Parse the batch CSV file.
            when 'batch'
              # Expected column order for batch CSV file
              # Batchid, Date, Facility Code, Expected EOB, Arrival Time
              logger.debug "In batch upload case"
              batch = Batch.new
              batch.batchid, batch_date, facility, batch.eob, arrival_time,batch.correspondence = line.split(',')
              puts facility
              batch.facility = Facility.find_by_sitecode(facility)
              batch.date = batch_date
              batch.source = file.original_filename
              batch.arrival_time = Time.parse(arrival_time)
              # Target Time = Arrival Time + TAT count
              batch.target_time = batch.arrival_time +  batch.facility.client.tat.hours unless batch.facility.nil?
              batch.contracted_time = batch.arrival_time +  batch.facility.client.contracted_tat.hours unless batch.facility.nil?
              success = batch.save
              logger.debug "Result of batch.save was #{success}"
              tat = Tat.new
              batch.tat = tat
              batch.update
  
              if batch.errors.entries.size > 0
                bad_record_count = bad_record_count + 1
                batch.errors.entries.each do |error|
                  flash[:notice] = flash[:notice] + " Batch #{batch.batchid} has an error : #{error}<br/>"
                  logger.debug "Batch #{batch.batchid} has an error : #{error}"
                end
              end
  
              # Parse the Job CSV file.
            when 'job'
              # Expected column order for job CSV file
              # Check number, Tiff number, Estimated EOB
              batch = Batch.find(params[:batch])
              job = Job.new
              job.check_number, job.tiff_number, job.estimated_eob, payid = line.split(',')
              job_payer = Payer.find_by_payer('DEFAULT PAYER')
              job.payer = job_payer
              job.batch = batch
              job.save
              if job.errors.entries.size > 0
                bad_record_count = bad_record_count + 1
                job.errors.entries.each do |error|
                  flash[:notice] = flash[:notice] + " Job with check number #{job.check_number} has an error : #{error}<br/>"
                end
              end
  
              # Parse the Payer CSV file.
              # when 'payer'
              # Expected column order for payer CSV file
              # Date Added  Initials  From? GATEWAY PAY_ID  PAYOR GR NAME// SUPPORT PAYORS
              # PAY_ADD1  PAY_ADD2  PAY_ADD3  PAY_ADD4  Phone
              # payer = Payer.new
              #gate_way_no, payer_name, pay_no, var_ge, add1, add2, add3, add4 = line.split(',')
              # payer.gateway = strip(gate_way_no,'"')
              # payer.gr_name = strip(var_ge,'"')
              # payer.payid = strip(pay_no,'"')
              # payer.payer = strip(payer_name,'"')
              # payer.pay_address_one = strip(add1,'"')
              #  payer.pay_address_two = strip(add2,'"')
              #  payer.pay_address_three = strip(add3,'"')
              #  payer.pay_address_four = strip(add4,'"')
              #payer.save
              #if payer.errors.entries.size > 0
              # bad_record_count = bad_record_count + 1
              #payer.errors.entries.each do |error|
              # flash[:notice] = flash[:notice] + " payer #{payer.payid} has an error : #{error}<br/>"
              #end  
              #end 
       
            
            end #case
         
          end
        end
        if @type == 'job'
          flash[:notice] = flash[:notice] + "<BR> Total records : #{i-1}  Imported Successfuly : #{i- bad_record_count-1} Import Failed : #{bad_record_count} "
          redirect_to :controller => '/admin/batch', :action => 'add_job', :id => params[:batch]
        
          #else
          #flash[:notice] = flash[:notice] + "<BR> Total records : #{i-1}  Imported Successfuly : #{i- bad_record_count-1} Import Failed : #{bad_record_count} "
          #redirect_to :controller => '/admin/upload', :action => 'upload' , :batch => @batch, :type => @type
          #this the code before,anoop modified else with elsif
        elsif @type == 'user'
          flash[:notice] = flash[:notice] + "<BR> Total records : #{i-1}  Imported Successfuly : #{i- bad_record_count-1} Import Failed : #{bad_record_count} "
          redirect_to :controller => '/admin/upload', :action => 'upload' , :batch => @batch, :type => @type
        elsif @type == 'batch'
          flash[:notice] = flash[:notice] + "<BR> Total records : #{i-1}  Imported Successfuly : #{i- bad_record_count-1} Import Failed : #{bad_record_count} "
          redirect_to :controller => '/admin/upload', :action => 'upload' , :batch => @batch, :type => @type
       
        end
      
      rescue
        flash[:notice] = "A problem occured while uploading the records. Please check the file format!"
        flash[:notice] = flash[:notice] + "<BR> Total records : #{i-1}  Imported Successfuly : #{i- bad_record_count-1} Import Failed : #{bad_record_count} "
        redirect_to :controller => '/admin/upload', :action => 'upload' , :batch => @batch, :type => @type
      end
    end
  end
  # Strip a particular character from string
  def strip(str,char)
    new_str = ""
    unless str.nil?
      str.each_byte do |byte|
        new_str << byte.chr unless byte.chr == char
      end
    end
    new_str.chomp
  end
end

