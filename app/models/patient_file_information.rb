class PatientFileInformation < ActiveRecord::Base
  has_many :patient_information
end
