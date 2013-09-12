##################################################################################################################################
#   Description: Ruby Script to validate Medistreams XML output file. The Scripts picks up all xml file from a source folder,
#   conducts validations and log info and error type messages to output log file.
#
#   Created   : 2011-07-13 by Remya Senan @ Revenuemed
#
##################################################################################################################################
require 'rubygems'
require 'nokogiri'
require 'logger'
require 'yaml'

# Reading the input folder path and output folder path from YML config file
cnf = YAML::load(File.open("837I_Validation.yml"))
input_dir = cnf ["PATH"]["INPUT"]
output_dir = cnf ["PATH"]["OUTPUT"]
# Defining output log file
log = Logger.new("#{output_dir}/ValidationResult.log", "daily")

log.info "######################################################################################################################"
log.info "Validation Begins"

Dir.glob("#{input_dir}/*.xml").each do |filename|

  log.info "File Name - " + filename.to_s
  xml_output = File.open(filename)
  doc = Nokogiri::XML(xml_output)
  log.info "Opened XML document for processing"

  # initializing variableS
  total_claim_charge = 0.0
  total_line_item_payment = 0.0
  total_adjustment_amount = 0.0

  # Iterating through /<MediStreams.Remittance>/<Batch>/<Transaction> tags
  #Totalcharge = 0.0
  
   log.info "*********************************************"
      batchdate = doc.xpath("/SecureEDI_UBCLAIM_XML/BatchDate").text.strip.to_i
      batchfilename = doc.xpath("/SecureEDI_UBCLAIM_XML/BatchFileName").text.strip.to_s
      batchid = doc.xpath("/SecureEDI_UBCLAIM_XML/BatchID").text.strip.to_s
      
      log.info "BatchDate = " + batchdate.to_s
      log.info "BatchFileName = " + batchfilename.to_s
      log.info "BatchID = " + batchid.to_s
      log.info "*********************************************"
  
  doc.xpath("/SecureEDI_UBCLAIM_XML/ClaimData").each do |claim|
	 charge_sum = 0.0
         paperclaimid = claim.xpath("PaperClaimID").text.strip.to_s
	 paperclaimdate = claim.xpath("PaperClaimDate").text.strip.to_s
	 claim.xpath("ServiceLines/ServiceLine").each do |serviceline|
	 serviceline_charge = serviceline.xpath("Charge").text.strip.to_f 
	  charge_sum = charge_sum + serviceline_charge
   end
          Totalcharge =claim.xpath("TotalCharges").text.strip.to_f 

     if Totalcharge.to_s == charge_sum.to_s
      log.info "******************************************************************************************************************"
      log.info "Paper Claim id                         : "+paperclaimid.to_s
      log.info "Paper Claim date                       : "+paperclaimdate.to_s
      log.info "Value entered in Total charge field    = "+Totalcharge.to_s
      log.info "Sum of charges entered in servicelines = "+charge_sum.to_s
      log.error "Status                                :  Matching"
      log.info "******************************************************************************************************************"
      
      elsif Totalcharge != charge_sum
      log.info "******************************************************************************************************************"
      log.info "Paper Claim id                         : "+paperclaimid.to_s
      log.info "Paper Claim date                       : "+paperclaimdate.to_s
      log.info "Value entered in Total charge field    = "+Totalcharge.to_s
      log.info "Sum of charges entered in servicelines = "+charge_sum.to_s
      log.error "Status                                :  Not matching"
      log.info "******************************************************************************************************************"
      
      end
     end
    end
   
   
log.info "Validation Completed"
log.info "######################################################################################################################\n\n"

