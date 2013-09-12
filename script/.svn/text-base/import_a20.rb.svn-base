#!/usr/bin/env ruby

# Author		: 	Ganesh Gunasegaran
# Modified  :   Gaurav Sohoni
# Email			:		ganesh.gunasegaran@gmail.com
# Modified	: 	19-08-2007

# Naive implementation without error checking...

require "logger"
require 'net/smtp'

RAILS_PATH = "/var/www/apps/current/"
DATA_PATH = "#{RAILS_PATH}data_new/"
LOG_FILE_PATH = "#{RAILS_PATH}"
MAILHOST = "mail.revenuemed.com"
MAIL_FROM = "a20_importer@revenuemed.com"
MAIL_TO = "a20_empty_files@revenuemed.com"

BACKUP_PATH = "/home/revlogic/revsync/backup/"
ARCHIVE_PATH = "#{DATA_PATH}archive/"

file_to_write = Time.now.strftime("%d%m%Y-%H%M").to_s + ".log"
log_file = File.open("#{RAILS_PATH}a20_import/#{file_to_write}", "w")
log = Logger.new(log_file)

log.info "Getting list of files @ backup location:"
backup_files = Dir.glob(BACKUP_PATH+"*A20")
unless backup_files
  log.info "No files found."
  exit
end
backup =[]
backup_files.each do |bf|
  if bf =~ /([0-9]{4}[A-Z][0-9]{3}\.[0-9]{3}\.A20)/ 
    backup << $1
  end
end

log.info "Getting list of files @ archive location:"
archive_files = Dir.glob(ARCHIVE_PATH+"*A20")
unless archive_files
  log.info "No files found."
  exit
end
archived = []
archive_files.each do |af|
  if af =~ /([0-9]{4}[A-Z][0-9]{3}\.[0-9]{3}\.A20)/ 
    archived << $1
  end
end

log.info "Copying files from backup directory to data directory..."
log.info "Total files to copy: #{(backup - archived).size}"

files_to_copy = backup - archived

files_to_copy.each do |ftc| 
  result = `cp #{BACKUP_PATH}#{ftc} #{DATA_PATH}`
  unless result
    log.error "File #{ftc} could not be copied"
  end
end
log.info "Starting A20 import"

files_to_copy.each do |ftc|
  file_size = File.size("#{DATA_PATH}#{ftc}") rescue 0
  if file_size > 0
    system "unzip #{DATA_PATH}#{ftc} -d #{DATA_PATH}"
    system "mv #{DATA_PATH}UB*.DBF #{DATA_PATH}a20_import.dbf"
    system "#{RAILS_PATH}script/runner -e production \"Runner.import_a20('#{ftc}', '#{DATA_PATH}a20_import.dbf')\""
    log.info "#{RAILS_PATH}script/runner -e production \"Runner.import_a20('#{ftc}', '#{DATA_PATH}a20_import.dbf')\""
    system "rm #{DATA_PATH}a20_import.dbf"
    system "mv #{DATA_PATH}#{ftc} #{DATA_PATH}archive/"
  else
    log.error "File #{DATA_PATH}#{ftc} had 0 bytes"
    myMessage = <<END_OF_MESSAGE
From: A20 Importer <a20_importer@revenuemed.com>
To: A20 Null Files <a20_empty_files@revenumed.com>
Subject: File #{ftc} was empty (0 bytes)
END_OF_MESSAGE

    Net::SMTP.start(MAILHOST) do |smtp|
      smtp.send_message myMessage, MAIL_FROM, MAIL_TO
    end
    system "mv #{DATA_PATH}#{ftc} #{DATA_PATH}archive/"
  end
end

log.info "A20 import complete"