class BatchUpload < ActiveRecord::Base
  has_attached_file :zip,
    :path => ":rails_root/public/batchload/",
    :url => "/batchload/"
#   validates_presence_of :file_name
#   validates_uniqueness_of :file_name
   alias_attribute :zip_file_name,:filename
   alias_attribute :zip_content_type,:content_type
   alias_attribute :zip_file_size,:size

  def self.save(upload)
    if upload.present? && upload['datafile'].present?
      name =  upload['datafile'].original_filename
      directory = "public/documents"
      # create the file path
      path = File.join(directory, name)
      # write the file
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
      file = DataFile.new
      file.file_name = name
      file.save
    else
      0
    end
  end

  def self.upload_batch(user_login_name,upload,facility)
    if upload.present? && upload['file'].present?
      begin
        
        name =  upload['file'].original_filename
        time_stamp = "#{Time.now.strftime("%Y%m%d%H%M%S")}".delete(" ").delete(":").delete("+").delete("+").delete("-")
        new_name = "#{time_stamp}_#{user_login_name}_#{name}"
        directory = "batchupload/#{facility}/"
        # create the file path
        path = File.join(directory, new_name)
        # write the file
        File.open(path, "wb") { |f| f.write(upload['file'].read) }
        return true
      rescue => e
        logger.info "..check for files..................#{e}"
        return false
      end
    else
      return 0
    end
  end
end
