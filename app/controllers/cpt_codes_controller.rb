class CptCodesController < ApplicationController
  # GET /cpt_codes
  # GET /cpt_codes.xml
  def index
    @cpt_codes = CptCode.find_by_code(params[:code]).description

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cpt_codes }
    end
  end

  # GET /cpt_codes/1
  # GET /cpt_codes/1.xml
  def show
    cpt_code_desc = CptCode.find_by_code(params[:code]).description
    render :text => cpt_code_desc
  end

  # GET /cpt_codes/new
  # GET /cpt_codes/new.xml
  def new
    @cpt_code = CptCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cpt_code }
    end
  end

  # GET /cpt_codes/1/edit
  def edit
    @cpt_code = CptCode.find(params[:id])
  end

  # POST /cpt_codes
  # POST /cpt_codes.xml
  def create
    @cpt_code = CptCode.new(params[:cpt_code])

    respond_to do |format|
      if @cpt_code.save
        flash[:notice] = 'CptCode was successfully created.'
        format.html { redirect_to(@cpt_code) }
        format.xml  { render :xml => @cpt_code, :status => :created, :location => @cpt_code }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cpt_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cpt_codes/1
  # PUT /cpt_codes/1.xml
  def update
    @cpt_code = CptCode.find(params[:id])

    respond_to do |format|
      if @cpt_code.update_attributes(params[:cpt_code])
        flash[:notice] = 'CptCode was successfully updated.'
        format.html { redirect_to(@cpt_code) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cpt_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cpt_codes/1
  # DELETE /cpt_codes/1.xml
  def destroy
    @cpt_code = CptCode.find(params[:id])
    @cpt_code.destroy

    respond_to do |format|
      format.html { redirect_to(cpt_codes_url) }
      format.xml  { head :ok }
    end
  end
end
