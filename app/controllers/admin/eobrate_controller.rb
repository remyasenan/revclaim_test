# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Admin::EobrateController < ApplicationController
  #before_filter :validate_supervisor

  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    @eobrate_pages, @eobrates = paginate :eobrates, :per_page => 10
  end

  def show
    @eobrate = Eobrate.find(params[:id])
  end

  def new
    @clients = Client.find(:all).map do |cl|
      cl.name
    end
    @eobrate = Eobrate.new
  end

  def create
#    @clients = Client.find(:all).map do |cl|
#      cl.name
#    end
    @eobrate = Eobrate.new(params[:eobrate])
    client_name = params[:form][:client] unless params[:form].nil?
    @eobrate.client = Client.find_by_name(client_name)
    
    if @eobrate.save
      flash[:notice] = 'Eobrate was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @clients = Client.find(:all).map do |cl|
      cl.name
    end
    @eobrate = Eobrate.find(params[:id])
  end

  def update
    @eobrate = Eobrate.find(params[:id])
    client_name = params[:form][:client] unless params[:form].nil?
    @eobrate.client = Client.find_by_name(client_name)
    @eobrate.update
    if @eobrate.update_attributes(params[:eobrate])
      flash[:notice] = 'EOB Rate was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Eobrate.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
