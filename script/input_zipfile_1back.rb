#!/usr/bin/env ruby
require "logger"
require 'net/smtp'

#RAILS_PATH = "/var/www/apps/current/"
RAILS_PATH = "/var/www/apps/releases/20080211122330/"
ZIP_PATH = "#{RAILS_PATH}zip_new/"
LOG_FILE_PATH = "#{RAILS_PATH}"
MAILHOST = "mail.revenuemed.com"
MAIL_FROM = "zip_importer@revenuemed.com"
MAIL_TO = "zip_empty_files@revenuemed.com"

BACKUP_PATH = "/home/revlogic/revsync/back_zip/"
ARCHIVE_PATH = "#{ZIP_PATH}zip_archive/"

file_to_write = Time.now.strftime("%d%m%Y-%H%M").to_s + ".log"
log_file = File.open("#{RAILS_PATH}zip_import/#{file_to_write}", "w")
log = Logger.new(log_file)

log.info "Getting list of files @ backup location:"
backup_files = Dir.glob(BACKUP_PATH+"*.zip")
log.info "backup files"
log.info backup_files
unless backup_files
  log.info "No files found."
  exit
end
backup =[]
backup_files.each do |bf|
#  if bf =~ /([0-9]{4}[A-Z][0-9]{3}\.[0-9]{3}\.A20)/ 
log.info "inside backup"
    backup << $1
#  end
end

log.info "Getting list of files @ archive location:"
archive_files = Dir.glob(ARCHIVE_PATH+"*.zip")
unless archive_files
  log.info "No files found."
  exit
end
archived = []
archive_files.each do |af|
#  if af =~ /([0-9]{4}[A-Z][0-9]{3}\.[0-9]{3}\.A20)/ 
    log.info "archive"
    
    archived << $1
#  end
end
archived = archive_files
    log.info "archivedhhhh"
    log.info "archived"
    log.info backup_files
    backup = backup_files
#    log.info archived
log.info "Copying files from backup directory to data directory..."
log.info "Total files to copy: #{(backup - archived).size}"

files_to_copy = backup - archived

files_to_copy.each do |ftc| 
  result = `cp #{ftc} #{ZIP_PATH}`
  unless result
    log.error "File #{ftc} could not be copied"
  end
end
log.info "Starting zip transfer"

files_to_copy.each do |ftc|
  file_size = File.size("#{ftc}") rescue 0
  if file_size > 0
#    system "unzip #{DATA_PATH}#{ftc} -d #{DATA_PATH}"
#    system "mv #{DATA_PATH}UB*.DBF #{DATA_PATH}a20_import.dbf"
    system "#{RAILS_PATH}script/runner \"Runner.input_zipfile('#{ftc}','#{Time.now}')\""
    log.info "#{RAILS_PATH}ruby script/runner \"Runner.input_zipfile('#{ftc}','#{Time.now}')\""
      system "mv #{ftc} #{ZIP_PATH}zip_archive/"
  else
     log.error "File #{ftc} had 0 bytes"
#       myMessage = <<END_OF_MESSAGE
#   From: A20 Importer <a20_importer@revenuemed.com>
#To: A20 Null Files <a20_empty_files@revenumed.com>
#Subject: File #{ftc} was empty (0 bytes)
#END_OF_MESSAGE
#
#    Net::SMTP.start(MAILHOST) do |smtp|
#      smtp.send_message myMessage, MAIL_FROM, MAIL_TO
#    end
    system "mv #{ftc} #{ZIP_PATH}zip_archive/"
  end
end

log.info "Zip transfer complete"