namespace :eob_errors  do
  desc "sss"
  task :populate => :environment do
   
    error_list = [
      {:severity => 0, :error_type => "Correct", :code => "C0R", :form_type => "UB04" },
      {:severity => 6, :error_type => "Billing Provider Incorrect", :code => "BPI", :form_type => "UB04" },
      {:severity => 6, :error_type => "Pay To Provider Incorrect", :code => "PPI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Control Number Incorrect", :code => "PCMI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Medical Record Number Incorrect", :code => "MRNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Type of Bill Incorrect", :code => "TBI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Control Number Incorrect", :code => "PCNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Federal Tax Number Incorrect", :code => "FTNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Statement Covers Period From Incorrect ", :code => "SCFI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Statement Covers Period To Incorrect", :code => "SCTI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Name ID Incorrect", :code => "PNII",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Name Incorrect", :code => "PNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Address Street Incorrect ", :code => "PASI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Address City Incorrect", :code => "PACI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Address State Incorrect", :code => "PASI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Address Zip Incorrect", :code => "PAZI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Address Country Code Incorrect", :code => "PACCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Birthdate Incorrect", :code => "PBI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Sex Incorrect", :code => "PSI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Admission Date Incorrect", :code => "ADI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Admission Hour Incorrect", :code => "AHI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Type of Admission/Visit Incorrect", :code => "TAI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Source of Admission Incorrect", :code => "SAI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Discharge Hour Incorrect", :code => "DHI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Discharge Status Incorrect", :code => "PDSI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 1 Incorrect", :code => "CC1I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 2 Incorrect", :code => "CC2I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 3 Incorrect", :code => "CC3I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 4 Incorrect", :code => "CC4I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 5 Incorrect", :code => "CC5I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 6 Incorrect", :code => "CC6I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 7 Incorrect", :code => "CC7I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 8 Incorrect", :code => "CC8I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 9 Incorrect", :code => "CC9I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 10 Incorrect", :code => "CC10I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Condition Code 11 Incorrect", :code => "CC11I",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Accident Status Incorrect", :code => "ASI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Occurrence Code Incorrect", :code => "OCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Occurrence Date Incorrect", :code => "ODI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Occurrence Span Code Incorrect", :code => "OSCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Occurrence Span From Incorrect", :code => "OSFI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Occurrence Span Through Incorrect", :code => "OSTI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Subscriber Incorrect", :code => "SI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Value Code Code Incorrect", :code => "VCCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Value Code Amount Incorrect", :code => "VCAI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Revenue Code Incorrect", :code => "RCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Revenue Code Description Incorrect", :code => "RCDI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "HCPCS/Rates/HIPPS Rate Codes Incorrect ", :code => "HRHI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patient Control Number Incorrect", :code => "PCNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Service Date Incorrect", :code => "SDI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Creation Date Incorrect", :code => "CDI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Units of Service Incorrect", :code => "USI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Total Charges Incorrect", :code => "TCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Non-Covered Charges Incorrect", :code => "NCCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Payer Name Incorrect", :code => "PNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Health Plan ID Incorrect", :code => "HPID",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Release of Information Incorrect", :code => "RII",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Assignment of Benefits Incorrect", :code => "ABI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Prior Payments Incorrect", :code => "PPI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "NPI Incorrect", :code => "NPPI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Other Provider ID Incorrect", :code => "OPII", :form_type =>"UB04"},
      {:severity => 6, :error_type => "Insureds Name Incorrect", :code => "INI", :form_type =>"UB04"},
      {:severity => 6, :error_type => "Patients Relationship Incorrect", :code => "PRI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Insureds Unique ID Incorrect", :code => "IUIC",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Insurance Group Name Incorrect", :code => "IGNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Insurance Group Number Incorrect", :code => "IGNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Treatment Authorization Code Incorrect", :code => "TACI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Employer Name Incorrect", :code => "ENI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Diagnosis Version Qualifier Incorrect", :code => "DVQI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Principal Diagnosis Incorrect", :code => "PDI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Other Diagnosis Incorrect", :code => "ODI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Admitting Diagnosis Code Incorrect", :code => "ADCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Patients Reason for Visit Incorrect", :code => "PRVI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "PPS Code Incorrect", :code => "PCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "External Cause of Injury Code Incorrect", :code => "ICC",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Principal Procedure Code Incorrect", :code => "PPCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Principal Procedure Date Incorrect", :code => "PPDI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Other Procedure Code Incorrect", :code => "OPCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Other Procedure Date Incorrect", :code => "OPDI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Attending NPI Incorrect", :code => "ANI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Attending Qual Incorrect", :code => "AQI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Attending ID Incorrect", :code => "AII",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Attending Last Name Incorrect", :code => "ALNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Attending First Name Incorrect", :code => "ALFI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Operating NPI Incorrect", :code => "ONI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Operating Qual Incorrect", :code => "OQI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Operating ID Incorrect", :code => "OII",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Operating Last Name Incorrect", :code => "OLNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Operating First Name Incorrect", :code => "OFNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Other NPI Incorrect", :code => "ONI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Other Qual Incorrect", :code => "OQI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Other ID Incorrect", :code => "OII",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Other Last Name Incorrect", :code => "OLNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Other First Name Incorrect", :code => "OFNI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Remarks Incorrect", :code => "RI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Qualifier Qual Incorrect", :code => "QQI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Qualifier Code Incorrect", :code => "QCI",:form_type =>"UB04"},
      {:severity => 6, :error_type => "Qualifier Value Incorrect", :code => "QVI",:form_type =>"UB04"},
      
    ]
     error_list.each do |e|
      EobError.create(e)
    end
    
  end
end
