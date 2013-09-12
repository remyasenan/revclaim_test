# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Admin::SamplingRateController < ApplicationController
  
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
    @sampling_rate_pages, @sampling_rates = paginate :sampling_rates, :per_page => 10
  end

  def show
    @sampling_rate = SamplingRate.find(params[:id])
  end

  def new
    @sampling_rate = SamplingRate.new
  end

  def create
    @sampling_rate = SamplingRate.new(params[:sampling_rate])
    if @sampling_rate.save
      flash[:notice] = 'SamplingRate was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sampling_rate = SamplingRate.find(params[:id])
  end

  def update
    @sampling_rate = SamplingRate.find(params[:id])
    if @sampling_rate.update_attributes(params[:sampling_rate])
      flash[:notice] = 'SamplingRate was successfully updated.'
      redirect_to :action => 'list', :id => @sampling_rate
    else
      render :action => 'edit'
    end
  end

  def destroy
    SamplingRate.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
