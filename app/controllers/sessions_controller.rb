# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
 # include AuthenticatedSystem
  layout 'standard'

  def new

    #logout_keeping_session!
    flash[:notice] = "Please login to continue."
  end

def version
      @version_settings = YAML.load_file("#{Rails.root}/config/version.yml")
      @config   = []
      rails_config = Rails::Configuration.new
      @config << ["RevClaim version",@version_settings['application']['version']]
      @config << ["Ruby version",VERSION]
      @config << ["Rails version",RAILS_GEM_VERSION]
      @config << ["Application root",Rails.root]
      @config << ["Environment",RAILS_ENV]
      @config << ["Database",rails_config.database_configuration[RAILS_ENV]["database"]]
      @config << ["Database Server",rails_config.database_configuration[RAILS_ENV]["host"]]
      @config << ["Migration version",ActiveRecord::Migrator.current_version]
      @config << ["Release date",@version_settings['application']['release_date']]
      svn_path = `svn info|grep URL:`
      svn_path = svn_path.gsub('URL:', '')
      svn_path = ' -   ' if svn_path.empty?
      @config << ["SVN URL",svn_path]
      svn_ver = `svn info|grep Revision:`
      svn_ver = svn_ver.gsub('Revision:', '')
      svn_ver = ' -   ' if svn_ver.empty?
      @config << ["SVN Revision",svn_ver]
  end
  
  def eob_count
    
    @rol=@user.roles
    respond_to do |format|
      format.js
      #format.xml  { head :ok }
    end
  end

  
  def logout
   # @user=self.current_remittor
    @user.status="offline"
    @user.save!
    session[:user] = nil
    flash[:notice] = "#{@user.name} has logged out"
    redirect_to :action=> "new"
  end

  def dashboard

     @user
    @user.status="online"
    @user.save!
    @rol=@user.roles
    
  end
  
  def create
    @user= Remittor.authenticate(params[:login],params[:password])
    session[:user] = @user.id if @user
    #@user=self.current_remittor
     puts @user
     puts session[:user]
     puts "--------------------"
    if @user
      if params[:remember_me] == "1"
        current_remittor.remember_me unless current_remittor.remember_token?
        cookies[:auth_token] = { :value => self.current_remittor.remember_token , :expires => self.current_remittor.remember_token_expires_at }
      end
      #redirect_back_or_default('/')
      flash[:notice] = "You have successfully logged in"
    
      rem_rol=RemittorsRole.find(:first,:conditions=>{:remittor_id=>@user.id})
 
       @rol=@user.roles

      redirect_to :action=>'dashboard'
    else
      render :action=>'new'
      flash[:notice] = "You have not Logged in properly"
    end
  end

  def change_password

    unless params[:commit].nil?

      unless (params[:password].nil? or params[:password][:new].size < 4)
        new_password = params[:password][:new]
        retyped_password = params[:password][:retyped]
        if new_password == retyped_password
user = @user

 user.crypted_password = user.encrypt(new_password)
 user.save
          if user.save
            flash[:notice] = "Password changed successfully."
             redirect_to :action=>'dashboard'
          else
            flash[:notice] = "Password could not be changed."
          end
        else
          flash[:notice] = "Passwords do not match."
        end
      else
        flash[:notice] = "Password length should be greater than 4 characters."
      end
    end
  end

end