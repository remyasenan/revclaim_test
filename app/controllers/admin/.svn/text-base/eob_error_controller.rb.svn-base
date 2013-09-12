# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Admin::EobErrorController < ApplicationController
#  before_filter :validate_supervisor

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
    @eob_error_pages, @eob_errors = paginate :eob_errors, :per_page => 30
  end

  def show
    @eob_error = EobError.find(params[:id])
  end

  def new
    @eob_error = EobError.new
  end

  def create
    @eob_error = EobError.new(params[:eob_error])
    if @eob_error.save
      flash[:notice] = 'EobError was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @eob_error = EobError.find(params[:id])
  end

  def update
    @eob_error = EobError.find(params[:id])
    if @eob_error.update_attributes(params[:eob_error])
      flash[:notice] = 'EobError was successfully updated.'
      redirect_to :action => 'list', :id => @eob_error
    else
      render :action => 'edit'
    end
  end

  def destroy
    EobError.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
