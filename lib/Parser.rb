require 'zip/zipfilesystem'
require 'fileutils'

RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(Rails.root)
UNZIP_PATH ="#{Rails.root}/public/patient_information_zip/unzipped_files"
MOVED_FILES = "#{Rails.root}/public/patient_information_zip/moved_files/"
FILE_PATH = "#{Rails.root}/public/patient_information_zip/"
module Parser
  class Parsedata

def self.unzip(zip,unzip_path)
  Zip::ZipFile.open(zip) do |zip_file|
    zip_file.each do |f|
      f_path = File.join(unzip_path, f.name)
      FileUtils.mkdir_p(File.dirname(f_path))
      zip_file.extract(f, f_path) unless
      File.exist?(f_path)
    end
  end
end

def self.new_file(val,name,type,zipname)

  @patient_file_information = PatientFileInformation.new
  @patient_file_information.name = name
  @patient_file_information.filetype = type
  @patient_file_information.zipname = zipname
  @patient_file_information.patient_information.build({:insured_id => val[0].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),:relationship =>val[1].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),
  :lastname =>val[2].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),:firstname =>val[3].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),
  :dob =>val[4].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),:address =>val[7].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),
  :state =>val[8].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),:zipcode =>val[9].sub(/^[\"\s]/,'').sub(/[\"\s]$/,'')})
  @patient_file_information.save!

end

def self.existing_file(val)

  @patient_information=@patient_file_zip_info.patient_information.build({:insured_id => val[0].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),:relationship =>val[1].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),
  :lastname =>val[2].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),:firstname =>val[3].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),
  :dob =>val[4].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),:address =>val[7].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),
  :state =>val[8].sub(/^[\"\s]/,'').sub(/[\"\s]$/,''),:zipcode =>val[9].sub(/^[\"\s]/,'').sub(/[\"\s]$/,'')})
  @patient_information.save!

end

def self.temp
  return true
end

def self.parse(args)

  Dir.glob("#{args.file_path}/*.[Z,z][I,i][P,p]").each do |zip| # used to Find the Zip file name
  unzip_path = "#{UNZIP_PATH}/#{Time.now.strftime("%Y%m%d_%H%M%S")}/#{File.basename(zip,File.extname(zip))}" # temporay location to where zip file is unzipped
  FileUtils.mkdir_p(unzip_path)
  zip_name = File.basename(zip)
  puts "\nExtracting : #{zip_name}...."
  unzip(zip,unzip_path)

    p "Read the file from Temp Location "

  file_name = File.basename(unzip_path)
  Dir.glob("#{unzip_path}/**/*").each do |file|

      puts "Parsing start"

    name = File.basename(file,File.extname(file))
    type = File.basename(file).split(".")[1]

    index = File.read(file)

    index.each do |row|
        val = row.split(",").to_a
        zipname = File.basename(zip,File.extname(zip)).to_s
        @patient_file_zip_info = PatientFileInformation.find_by_zipname(zipname)

          if @patient_file_zip_info.blank?
                new_file(val,name,type,zipname)
          else
                existing_file(val)
          end
        end
              puts "Parsing end"
    end
            puts "Extraction complete"
            puts "Deleting the temp Folder"

            FileUtils.rm_rf(unzip_path)
            FileUtils.mv("#{FILE_PATH}#{zip_name}", "#{MOVED_FILES}",:force => true)
  end
end



  end
end