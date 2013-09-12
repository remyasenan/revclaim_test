class ApplicationController < ActionController::Base
 require 'xchar'
 require 'tzinfo'
 helper_method :form_resubmission_encrypt,:current_remittor
 include TZInfo
 protect_from_forgery
 before_filter :load_user
# before_filter do |c|
#    Remittor.current_remittor = @user unless @user.nil?
#  end
 def paginate_collection(collection, options = {})
    if collection.nil?
      return [nil, nil]
    else
      default_options = {:per_page => 10, :page => 1}
      options = default_options.merge options
      pages = Paginator.new self, collection.size, options[:per_page], options[:page]
      first = pages.current.offset
      last = [first + options[:per_page], collection.size].min
      slice = collection[first...last]
      return [pages, slice]
    end
  end

  def split_decimal_amount(total_amount)
     total_amount_array=total_amount.split(".")
     if total_amount_array[1].size<=1
       total_amount_array[1]="."+total_amount_array[1]+"0"
     else
       total_amount_array[1]="."+total_amount_array[1]
     end
       total_amount=total_amount_array[0]+total_amount_array[1]
     return total_amount
  end

   def form_resubmission_encrypt
      ActiveSupport::SecureRandom.base64(32).scan(/[a-zA-Z]/).to_s
   end

   def csrf_token
     ActiveSupport::SecureRandom.base64(32).scan(/[a-zA-Z]/).to_s
   end

  # @overrides Action_controller::Rescue.local_request?
  def local_request?
    user_ip = request.env['REMOTE_ADDR']
    # Treat only RMI internal IPs and localhost as local requests
    if (user_ip =~ /192\.168\.*\.*/) or (user_ip == "127.0.0.1")
      return true
    else
      return false
    end
  end

  def validate_admin
    unless @user and @user.roles.first.name == 'admin'
      flash_message
    end
  end

  def validate_supervisor
    unless @user and (@user.roles.first.name == 'Supervisor' or @user.roles.first.name == 'admin'  or @user.roles.first.name == 'TL')
      flash_message
    end
  end

  def validate_qa
    unless @user and @user.role == 'QA'
      flash_message
    end
  end

   def validate_TL
    unless @user and  @user.role == 'TL'
        flash_message
    end
  end

  def validate_processor
    unless @user and @user.role == 'Processor'
        flash_message
    end
  end

  def validate_hlsc_supervisor
    unless @user and (['Supervisor', 'HLSC', 'admin'].include?(@user.roles.first.name))
      flash_message
    end
  end

  def validate_hlsc_supervisor_tl
    unless @user and (['Supervisor', 'HLSC', 'admin', 'TL'].include?(@user.roles.first.name))
      flash_message
    end
  end

  def validate_user
    unless @user
      flash_message
    end
  end

  def flash_message
    flash[:notice] = 'You don\'t have necessary permission.'
    redirect_to :controller => '/dashboard', :action => 'index'
  end

  def flash_shift_message
    flash[:notice] = 'You are not allowed to work in this shift.'
    #redirect_to :controller => '/dashboard', :action => 'index'
  end


  def list_sort (items, sort)
    sorted = items.sort_by do
      sort
    end
    if sort =~ /reverse/
      sorted = items.reverse
    end
    return sorted
  end

  #Converting given EST time into IST time
  def convert_to_ist_time(time)
    tz_est = Timezone.get('US/Eastern')
    utc_time = tz_est.local_to_utc(time, false)
    tz_ist = Timezone.get('Asia/Calcutta')
    ist_time = tz_ist.utc_to_local(utc_time)
    return ist_time
  end

  #Converting given IST time into EST time
  def convert_to_est_time(time)
    tz_ist = Timezone.get('Asia/Calcutta')
    utc_time = tz_ist.local_to_utc(time, false)
    tz_est = Timezone.get('US/Eastern')
    est_time = tz_est.utc_to_local(utc_time)
    return est_time
  end

  def current_remittor
    @current_remittor = @user unless @user == false
    return @current_remittor
  end

  private
  def load_user
    @user = Remittor.find(session[:user]) unless session[:user].nil?
    @site_settings = SiteSetting.find(1)
    #User.current_user = @user unless @user.nil?
  end
end
