class Admin::PopUpController < ApplicationController
 
  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  require_role ["admin","Supervisor"]
  

#  verify :method => :post, :only => [:destroy], :redirect_to => {:action => :add_message}

  def add_message
    relation_include = [ {:remittors_roles => :role}]
    @user_new = Remittor.find(:all,:conditions => "roles.name = 'Processor'",
      :include => relation_include)
    @rol=current_remittor.roles
    @rol[0].name
    messages = ErrorPopup.find(:all)
    session[:payer_name]=params[:payer_name]
    session[:facility_name]=params[:job]
   

    @facility_new = Facility.find(:all)
    @messages =  messages.paginate :per_page => 15 ,:page => params[:page]
  end#list

  def edit
     
    @error_popups = ErrorPopup.find(params[:id])
  end
  
  def update
    @errorpopups = ErrorPopup.find(params[:id])
    @errorpopups.end_date = params[:end_date]
    @errorpopups.comment = params[:comment]
    @errorpopups.update
    if @errorpopups.update_attributes(params[:error_popup])
      flash[:notice] = 'Popup updated.'
      redirect_to :action => 'add_message'
    else
      render :action => 'edit'
    end
  end
  
  def submit
    pop_up_payer = params[:payer]
    if( params[:popup])
      @payeridval = params[:popup][:payerid].to_i
    end
    #if not pop_up_payer.blank?
    if not params[:pro_error_type_facility].blank?
      if not  params[:comment].blank?
        facility_list = params[:pro_error_type_facility][:id]
        pop_up_payer = params[:payer]
        duration_pop = params[:duration]
        message = params[:comment].strip
        payer_selected = Payer.find_by_payer(pop_up_payer)
        file_list = params[:doc_list]
        all_message = ErrorPopup.find(:all)
        case duration_pop
        when '1 week'
          end_time = Time.now + 7.days
        when '2 week'
          end_time = Time.now + 14.days
        when '4 week'
          end_time = Time.now + 30.days
        end
        all_payer = Payer.find(:all)
        all_payer.each do |p|
          if p.id == @payeridval
            @selected_payer = p.id
          end
        end
          
        if params[:pro_error_type].blank?
          facility_list.each do |facility_items|
            facility_id = Facility.find_by_name(facility_items).id
            if not file_list.blank?
              file_id = HlscDocument.find_by_file_location(file_list).id
              ErrorPopup.create(:payer_id => @selected_payer,:facility_id => facility_id,:start_date => Time.now , :end_date => end_time ,:comment => message,:file_id => file_id)
            else
              ErrorPopup.create(:payer_id => @selected_payer,:facility_id => facility_id,:start_date => Time.now , :end_date => end_time ,:comment => message)
            end
          end
        else
          user_id_list = params[:pro_error_type][:id]
          user_id_list.each do |users|
            user_id = Remittor.find_by_login(users).id
            facility_list.each do |facility_items|
              facility_id = Facility.find_by_name(facility_items).id
              if not file_list.blank?
                file_id = HlscDocument.find_by_file_location(file_list).id
                ErrorPopup.create(:payer_id => @selected_payer,:facility_id => facility_id,:start_date => Time.now , :end_date => end_time ,:comment => message,:file_id => file_id,:processor_id  => user_id)
              else
                ErrorPopup.create(:payer_id => @selected_payer,:facility_id => facility_id,:start_date => Time.now , :end_date => end_time ,:comment => message,:processor_id => user_id)
              end
            end
          end
        end
        flash[:notice]='Popup Set Sucessfully'
        redirect_to :action=>'add_message'
      else
        flash[:notice]='Please Enter Comments!'
        redirect_to :action => 'add_message',:job=>params[:payer]
      end # if comments not enter
    else
      flash[:notice]='Please Select a facility!'
      redirect_to :action => 'add_message',:job=>params[:payer]
    end# if no facility selected

  end 

  def select_payer
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]
    if search_field.blank?
      payers = Payer.find(:all,:conditions=>"client='PEMA'")
    else
      payers = filter_payers(criteria, compare, search_field, action = 'select')
    end
    @payers =  payers.paginate :per_page => 30 ,:page => params[:page]
  end
  
 
  def filter_payers(field, comp, search, act)
    flash[:notice] = nil
    case field
    when 'Date Added'
      if search !~ /\d{4}-\d{2}-\d{2}/ then @flag_incorect_date = 0; end
      payers = Payer.find(:all, :conditions => "date_added #{comp} '#{search}'")
    when 'Initials'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "initials like '%#{search}%'")
    when 'From Date'
      if search !~ /\d{4}-\d{2}-\d{2}/ then @flag_incorect_date = 0; end
      payers = Payer.find(:all, :conditions => "from_date #{comp} '#{search}'")
    when 'Gateway'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "gateway like '%#{search}%'")
    when 'Payer Id'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "payid like '%#{search}%'")
    when 'Payer'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "payer like '%#{search}%'")
    when 'Address-1'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "pay_address_one like '%#{search}%'")
    when 'Address-2'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "pay_address_two like '%#{search}%'")
    when 'Address-3'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "pay_address_three like '%#{search}%'")
    when 'Address-4'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "pay_address_four like '%#{search}%'")
    when 'Phone'
      flash[:notice] = "String search, '#{comp}' ignored."
      payers = Payer.find(:all, :conditions => "phone like '%#{search}%'")
    end
    if @flag_incorect_date == 0
      flash[:notice] = "Invalid Date format. Please re-enter! Format - DATE : yyyy-mm-dd"
      if act == 'select'
        redirect_to :action => 'select_payer'
      else
        redirect_to :action => 'add_message'
      end
    elsif payers.size == 0
      flash[:notice] = "Search for \"#{search}\" did not return any results. Try another keyword!"
      if act == 'select'
        redirect_to :action => 'select_payer'
      else
        redirect_to :action => 'add_message'
      end
    end
    return payers

  end

  def delete_messages
    mes = params[:message_to_delete]
    mes.delete_if do |key, value|
      value == "0"
    end
    mes.keys.each do |id|
      ErrorPopup.find(id).destroy
    end
    if mes.size != 0
      flash[:notice] = "Deleted #{mes.size} Message(s)."
    else
      flash[:notice]="Please select atleast one "
    end
    redirect_to :action => 'add_message'
  end#delete 

  def document_list
    @facilityid=params[:facility]
    @payer1=params[:payer1]
    @userid =params[:userid]
    docs = HlscDocument.find(:all)
    @doc_pages, @docs = paginate_collection docs, :per_page => 20, :page => params[:page]
  end
  
  def uploadfile
    upload = params[:upload]
    hlsc_file_comments = params[:hlsc_file_comment]
    if params[:upload][:datafile].size == 0
      flash[:notice] = "No File selected / File does not exist!"
      redirect_to :action => 'add_message'
    else
      name =  upload['datafile'].original_filename
      directory = "public/data/"
      location ="public/data/"+name
      # create the file path
      path = File.join(directory, name)
      # write the file
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
      new_hlsc_document_entry = HlscDocument.new
      new_hlsc_document_entry.file_name = name
      new_hlsc_document_entry.file_location = location
      new_hlsc_document_entry.file_comments = hlsc_file_comments
      new_hlsc_document_entry.file_created_time = Time.now
      new_hlsc_document_entry.user_id = session[:user]
      if new_hlsc_document_entry.save
        flash[:notice] = "File was successfully uploaded"
      else
        flash[:notice] = "Problem encountered during file upload!"
      end
      redirect_to :action =>'add_message'
    end
  end


  def destroy
    hlsc_file_list = HlscDocument.find_by_id(params[:id])
    pop_file_list = ErrorPopup.find_by_file_id(hlsc_file_list)
    if not pop_file_list.blank? 
      if pop_file_list.file_id==hlsc_file_list.id 
        flash[:notice] = "File is already in use!"
      end
    else
      hlsc_file_list = HlscDocument.find_by_id(params[:id]).destroy
      @file_location = hlsc_file_list.file_location
      File.delete("#{@file_location}") 
      if File.exist?("#{@file_location}")
      end
    end
    redirect_to :action => 'document_list'
  end   

end

