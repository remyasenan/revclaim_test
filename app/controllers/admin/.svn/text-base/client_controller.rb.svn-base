# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Admin::ClientController < ApplicationController
  layout 'standard'
  before_filter :validate_supervisor
  
  def index
    @clients = Client.where("status = 'ACTIVATE'")
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }
  
  def list
    search_field = params[:to_find] 
    compare = params[:compare]
    criteria = params[:criteria]

    search_field.strip! unless search_field.nil?

    if search_field.blank?
      universal_client = Client.find_by_name('UNIVERSAL').to_a
      clients = Client.find(:all)
      clients = clients - universal_client
		else
			clients = filter_clients(criteria, compare, search_field)
		end
      @client_pages, @clients = Client.paginate(:page => params[:page], :per_page => 30)
  end

  def filter_clients(field, comp, search)
    flash[:notice] = nil
    case field
      when 'Name'
        flash[:notice] = "String search, '#{comp}' ignored."
        clients = Client.find(:all, :conditions => "name like '%#{search}%'")
      when 'TAT'
        clients = Client.find(:all, :conditions => "tat #{comp} #{search}")      
    end
    if clients.size == 0
      flash[:notice] = " Search for \"#{search}\" did not return any results. Try another keyword!"
      redirect_to :action => 'list'
    end 
    clients
  end
  

  def delete_clients
    clients = params[:clients_to_delete]
    clients.delete_if do |key, value|
      value == "0"
    end
    clients.keys.each do |id|
      Client.find(id).destroy
    end
    if clients.size != 0
      flash[:notice] = "Deleted #{clients.keys.size} client(s)."
    else
      flash[:notice]="Please select atleast one client to delete ."
    end
    
    redirect_to :action => 'list'
  end

  def show
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      flash[:notice] = 'Client was successfully created.'
      @clients = Client.all
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      flash[:notice] = 'Client was successfully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Client.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
    
end
