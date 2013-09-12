require "logger"
require 'net/smtp'
require 'rake'

namespace :input_batch do
  desc "rake task for input module which takes in zip file path ,facility name and arrival time as parameters"

  task :load, [:zip_path, :facility, :arrival_time] => [:environment] do |t, args|
    begin
      RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(Rails.root)
      RAILS_PATH = "#{Rails.root}/"
      ZIP_PATH = "#{RAILS_PATH}zip_new/"
      LOG_FILE_PATH = "#{RAILS_PATH}"
      BACKUP_PATH = args.zip_path
      ARCHIVE_PATH = "#{ZIP_PATH}zip_archive/"

      file_to_write = Time.now.strftime("%d%m%Y-%H%M").to_s + ".log"
      log_file = File.open("#{RAILS_PATH}zip_import/#{file_to_write}", "w")
      log = Logger.new(log_file)
      log.info "Getting list of files @ backup location:"
      backup_files = Dir.glob(BACKUP_PATH+"*.zip")
      text_files = Dir.glob(BACKUP_PATH+"*.zip.txt")
      log.info "backup files"
      log.info backup_files
      unless backup_files
        log.info "No files found."
        exit
      end
      log.info "Getting list of files @ archive location:"
      archive_files = Dir.glob(ARCHIVE_PATH+"*.zip")
      unless archive_files
        log.info "No files found."
        exit
      end
      log.info "Copying files from backup directory to data directory..."
      #log.info "Total files to copy: #{(backup_files - archive_files).size}"
      #files_to_copy = backup_files - archive_files
      log.info "Total text files to copy: #{(text_files).size}"
      text_files_to_copy = text_files
      log.info "Starting text file transfer"
      text_files_to_copy.each do |txt_file|
        text_file_size = File.size("#{txt_file}")rescue 0
        if text_file_size >0
          system "mv #{txt_file} #{ZIP_PATH}"
        else
          log.error "File #{txt_file} has 0 bytes"
          system "mv #{txt_file} #{ZIP_PATH}zip_archive/"
        end
      end
      log.info "Total zip files to copy: #{(backup_files).size}"
      files_to_copy = backup_files
      log.info "Starting zip transfer"
      files_to_copy.each do |ftc|
        file_size = File.size("#{ftc}") rescue 0
        if file_size > 0
          Runner.input_zipfile(ftc,args.facility,args.arrival_time)
          log.info "Runner.input_zipfile('#{ftc}','#{args.facility}','#{args.arrival_time}')\"
          #system "#{RAILS_PATH}script/runner \"Runner.input_zipfile('#{ftc}','#{args.facility}','#{args.arrival_time}')\""
          #log.info "#{RAILS_PATH}script/runner \"Runner.input_zipfile('#{ftc}','#{args.facility}','#{args.arrival_time}')\""
          system "mv #{ftc} #{ZIP_PATH}zip_archive/"
        else
          log.error "File #{ftc} had 0 bytes"
          system "mv #{ftc} #{ZIP_PATH}zip_archive/"
        end
      end
      log.info "Zip transfer complete"

    rescue Exception => e

      p "Batch loading failed-Check LOG"
      p e.message
    ensure
    end
  end
end