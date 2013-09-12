# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.
require 'will_paginate/array'
class Admin::DocumentController < ApplicationController
  #before_filter :validate_user  # Check credentials before allowing access
#
  include AuthenticatedSystem
 include RoleRequirementSystem
  layout 'standard'
 require_role ["admin","Processor","QA"]


  def add
    client = Client.find_by_name(params[:client])
    if params[:upload][:file].size == 0
      flash[:notice] = "No File selected / File does not exist!"
      redirect_to :action => 'add_view_docs'
    else
      if request.post?
        data = params[:upload][:file]
      end
      doc = Document.new
      doc.filename = data.original_filename
      doc.content = data.read
      doc.client = client
      doc.file_type = params[:radio_choice][:attribute]
      if doc.save
        flash[:notice] = "File was successfully uploaded"
      else
        flash[:notice] = "Problem encountered during file upload!"
      end
      redirect_to :action => 'add_view_docs'
    end
  end

  def add_view_docs


   
    @rol=@user.roles
    common_client = 'UNIVERSAL'
    @clients = Client.find(:all).map{ |c| c.name }
    @selected = params[:client] unless params[:client].nil?
    @criteria = params[:criteria] unless params[:criteria].nil?
    if params[:criteria].nil? || params[:client].nil?
      docs = Document.find_without_content(:all, :order => 'created_at DESC')
    else
      if params[:criteria] == 'All'
        condition = ""
      else
        condition = " and file_type = '#{params[:criteria]}'"
      end
     #universal_docs = Client.find_by_name(common_client).documents
      docs = Document.find(:all, :conditions => "clients.name = '#{params[:client]}'" + condition,
                           :include => :client,
                           :order => 'created_at DESC')
    end
     
    #@doc_pages, @docs = paginate_collection docs, :per_page => 30, :page => params[:page]
     @docs =docs.paginate( :page => params[:page], :per_page =>1)

  end
  
  def paginate_collection(collection, options = {})
    default_options = {:per_page => 30, :page => 1}
    options = default_options.merge options
    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end

  def show_list
    criteria = params[:doc][:criteria].blank? ? params[:doc]: params[:doc][:criteria]
    @docs = Document.find_without_content(:all, :conditions => "file_type = '#{criteria}'")
  end

  def update
    @doc = Document.find_without_content(params[:id])
    @doc.file_type = params[:type]
    @doc.update_attributes(params[:doc])
    @doc.client = Client.find_by_name(params[:client])
    if @doc.save!
      flash[:notice] = "Document was successfully updated"
    end
    redirect_to :action => 'add_view_docs', :client => params[:client], :criteria => 'All'
  end

  def show
    @doc = Document.find(params[:id])
      path = "/" + @doc.filename
      root = "#{Rails.root}/tmp"
      File.open(root+path, 'wb') do |f|
        f.write(@doc.content)
      end
    file_to_send = root+path
    send_file(file_to_send, :disposition => "attachment")
  end
  
  def edit
    @clients = Client.all.map {|c| c.name}
    @doc = Document.find_without_content(params[:id])
    @document =@doc
  end

  def destroy
    Document.find_without_content(params[:id]).destroy
    redirect_to :action => 'add_view_docs'
  end

end
