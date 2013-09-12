class Notifier < ActionMailer::Base
  def report_generation(file_name_new)
    @subject =  "837 Report Generated "
    @recipients = 'ans837@revenuemed.com'
    @from = 'revclaim-support@revenuemed.com'
    @sent_on = Time.now()
    body :file_name_new=> file_name_new
  end
end
