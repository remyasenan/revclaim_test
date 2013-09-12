# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Admin::SqaJobSettingsController < ApplicationController
  #before_filter :validate_admin

  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  
  def index
    redirect_to :action => 'edit'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    @sqa_job_setting_pages, @sqa_job_settings = paginate :sqa_job_settings, :per_page => 10
  end

  def show
    @sqa_job_setting = SqaJobSetting.find(params[:id])
  end

  def new
    @sqa_job_setting = SqaJobSetting.new
  end

  def create
    @sqa_job_setting = SqaJobSetting.new(params[:sqa_job_setting])
    if @sqa_job_setting.save
      flash[:notice] = 'SqaJobSetting was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sqa_job_setting = SqaJobSetting.find(1)
  end

  def update
    @sqa_job_setting = SqaJobSetting.find(params[:id])
    if @sqa_job_setting.update_attributes(params[:sqa_job_setting])
      flash[:notice] = 'Settings have been updated.'      
      redirect_to :action => 'edit'
    else
      render :action => 'edit'
    end
  end

  def destroy
    SqaJobSetting.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
