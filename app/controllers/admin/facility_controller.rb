# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Admin::FacilityController < ApplicationController
 # before_filter :validate_supervisor

  include AuthenticatedSystem
  include RoleRequirementSystem
  require_role ["admin","Supervisor"]
  layout 'standard'
  def index
   @facilities = Facility.where("status = 'ACTIVATE'")
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    search_field = params[:to_find] 
    criteria = params[:criteria]

    search_field.strip! unless search_field.nil?

    if search_field.blank?
      facilities = Facility.find(:all)
    else
      facilities = filter_facilities(criteria, search_field)
    end
    @facility_pages, @facilities = Facility.paginate(:page => params[:page], :per_page => 30)
  end

  def filter_facilities(field, search)
    case field
      when 'Name'
        facilities = Facility.find(:all, :conditions => "name like '%#{search}%'")
      when 'Code'
        facilities = Facility.find(:all, :conditions => "sitecode like '%#{search}%'")      
      when 'Client'
        facilities = Facility.find(:all, :conditions => "clients.name like '%#{search}%'",
                                         :include => :client)
    end
    if facilities.size == 0
      flash[:notice] = " Search for \"#{search}\" did not return any results."
      redirect_to :action => 'list'
    end 
    return facilities
  end
  
  def show
    @facility = Facility.find(params[:id])
  end

  def new
    @facility = Facility.new
    @clients = Client.find(:all)
  end

  def create
    @clients = Client.find(:all)
    @facility = Facility.new(params[:facility])
    @facility.client_id = params[:facility][:client_id]
    if @facility.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def delete_facilities
    facilities = params[:facility_to_delete]
    facilities.delete_if do |key, value|
      value == "0"
    end
    facilities.keys.each do |id|
      Facility.find(id).destroy
    end

    #flash[:notice] = "Deleted #{facilities.keys.size} facilitie(s)."
    
    if facilities.size != 0
    flash[:notice] = "Deleted #{facilities.keys.size} facilitie(s)."
    else
    flash[:notice]="Please select atleast one facility to delete ."
    end
    
    redirect_to :action => 'list'
  end


  def edit
    @facility = Facility.find(params[:id])
    @clients = Client.find(:all)
  end

  def update
    @facility = Facility.find(params[:id])
    if @facility.update_attributes(params[:facility])
      flash[:notice] = 'Client was successfully updated'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Facility.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

end
