class RevclaimMailer < ActionMailer::Base

#default :from => "admin@revenuemed.com"
  
  def notify_batch_upload(recipient, subject, filename,facility_name,machine_name,file_size,ip_adder,user_name,bool_ok)
    logger.info "working fine in email...model"
    @filename = filename
    @facility_name = facility_name
    @machine_name = machine_name
    @ip_adder = ip_adder
    @file_size = file_size
    @user_name = user_name
    @bool_ok = bool_ok
    @recipients = recipient
    @subject =subject
    @from ="revclaim_notification@revenuemed.com"
  end

end
