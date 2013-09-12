# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.
require "will_paginate/array"
class Admin::PayerController < ApplicationController

  include AuthenticatedSystem
  include RoleRequirementSystem
  layout 'standard'
  require_role ["admin","Processor","QA"]
  #before_filter :validate_user
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
 # verify :method => :post, :only => [ :destroy, :create, :update ],
  #  :redirect_to => { :action => :list }

  def list
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]

    if search_field.blank?
      payers = Payer.find(:all)
    else
      payers = filter_payers(criteria, compare, search_field, action = 'list')
    end
   
    @payers =payers.paginate(:page => params[:page], :per_page =>30)
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
        redirect_to :action => 'payer_selection'
      else
        redirect_to :action => 'list'
      end
    elsif payers.size == 0
      flash[:notice] = "Search for \"#{search}\" did not return any results. Try another keyword!"
      if act == 'select'
        redirect_to :action => 'payer_selection'
      else
        redirect_to :action => 'list'
      end
    end

    return payers
  end

  def list_payers_processor

    @payers =Payer.paginate(:all, :page => params[:page], :per_page =>40)
  end

  def show
    @payer = Payer.find(params[:id])
  end

  def new
    @payer = Payer.new
  end

  def create

    @payer = Payer.new
    @payer.gateway = params[:payer][:gateway]
    @payer.payid = params[:payer][:payid]
    @payer.payer = params[:payer][:payer]
    @payer.gr_name = params[:payer][:gr_name]
    @payer.pay_address_one = params[:payer][:pay_address_one]
    @payer.pay_address_two = params[:payer][:pay_address_two]
    @payer.pay_address_three = params[:payer][:pay_address_three]
    @payer.pay_address_four = params[:payer][:pay_address_four]
    #      @payer.phone = params[:payer][:phone]
    if @payer.save
      
      if @user.roles.first.name == 'admin'
        flash[:notice] = 'Payer Successfully inserted'
        redirect_to :action => 'list'
      elsif @user.roles.first.name== 'Processor'

        flash[:notice] = 'Payer Successfully inserted . Newly Inserted  PayerID is : ' + @payer.payid
        redirect_to :controller => 'processor/my_job'
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @payer = Payer.find(params[:id])
    @flag = params[:flag]
  end

  def update
    @payer = Payer.find(params[:id])
    if @payer.update_attributes(params[:payer])
      if params[:flag].nil? == true
        flash[:notice] = 'Payer was successfully updated.'
        redirect_to :action => 'list'
      elsif params[:flag] == 'new'
        flash[:notice] = 'Payer was successfully updated.'
        redirect_to :action => 'new_payers'
      end
    else
      render :action => 'edit'
    end
  end

  def delete_payers
    # TODO: Messy way to handle multiple checkboxes from the view
    payers = params[:payers_to_delete]
    payers.delete_if do |key, value|
      value == "0"
    end
    payers.keys.each do |id|
      Payer.find(id).destroy
    end
    if payers.size != 0
      flash[:notice] = "Deleted #{payers.size} payer(s)."
    else
      flash[:notice]="Please select atleast one payer to delete"
    end
    redirect_to :action => 'list'
  end

  def destroy
    Payer.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  #for editing the job
  def payer_selection
    @job = Job.find(params[:id])
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]

    if search_field.blank?
      payers = Payer.find(:all)
    else
      payers = filter_payers(criteria, compare, search_field, action = 'select')
    end
   
    @payers =Payer.paginate(:all, :page => params[:page], :per_page =>40)
  end

  #for creating new job
  def select_payer
    @batch = Batch.find(params[:id])
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]

    if search_field.blank?
      payers = Payer.find(:all)
    else
      payers = filter_payers(criteria, compare, search_field, action = 'select')
    end
   
    @payers =Payer.paginate(:all, :page => params[:page], :per_page =>40)
  end

  def assign_payer
    @payer = Payer.find(params[:id])
    @job = Job.find_by_id(params[:job])
    @job.payer = @payer
    @job.update
    redirect_to :controller => 'job' ,:action => 'edit_payer', :id => @job.id
  end

  def remove_payer
    @job = Job.find_by_id(params[:id])
    @job.payer = nil
    @job.update
    redirect_to :controller => '../qa', :action => 'verify', :job => @job
  end

  def allocate_payer
    search_field = params[:to_find]
    compare = params[:compare]
    criteria = params[:criteria]

    if search_field.blank?
      payers = Payer.find(:all)
    else
      payers = filter_payers(criteria, compare, search_field, action = 'list')
    end

    @payers =Payer.paginate(:all, :page => params[:page], :per_page =>40)
  end
    
  def new_payers
    @payers = Payer.find(:all, :conditions => "payer = 'Unknown'")
    if @payers.size == 0
      if flash[:notice].nil?
        flash[:notice] =  "No newly added Payer found" 
        redirect_to :action => 'list'
      else
        flash[:notice] = flash[:notice] + "<br/>" + "No newly added Payer found" 
        redirect_to :action => 'list'
      end
    end
  end

end
