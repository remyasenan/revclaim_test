class CreateUb04ClaimInformations < ActiveRecord::Migration
  def self.up
    create_table :ub04_claim_informations do |t|
      
      t.column :job_id, :integer
      t.foreign_key :job_id, :jobs, :id
      t.column :claimid,  :integer
      t.column :claim_date, :datetime
      t.column :claim_status, :string, :limit  => 50
      t.column :claim_message,  :string, :limit   => 50
      t.column :billing_provider_first_name,  :string, :limit   => 50
      t.column :billing_provider_last_name, :string, :limit   => 50
      t.column :billing_provider_address1,  :string, :limit   => 50
      t.column :billing_provider_address2,  :string, :limit   => 50
      t.column :billing_provider_city,  :string, :limit   => 50
      t.column :billing_provider_state, :string, :limit   => 50
      t.column :billing_provider_zipcode, :integer
      t.column :billing_provider_telephone, :string, :limit  => 50
      t.column :billing_provider_tin_or_ein,  :integer
      t.column :billing_provider_npi, :string, :limit   => 50
      t.column :billing_providerid1,  :string, :limit   => 50
      t.column :billing_providerid2,  :string, :limit   => 50
      t.column :billing_providerid3,  :string, :limit   => 50
      t.column :rendering_provider_first_name,  :string, :limit   => 50
      t.column :rendering_provider_last_name, :string, :limit   => 50
      t.column :rendering_provider_address1,  :string, :limit   => 50
      t.column :rendering_provider_city,  :string, :limit   => 50
      t.column :rendering_provider_state, :string, :limit   => 50
      t.column :rendering_provider_zipcode, :integer
      t.column :rendering_providerid, :integer
      t.column :patient_account_number, :string, :limit   => 50
      t.column :patient_med_rec_number, :string, :limit   => 50
      t.column :patient_bill_type,  :string, :limit   => 50
      t.column :federal_tax_number, :string, :limit   => 50
      t.column :statement_cover_from, :datetime
      t.column :statement_cover_to, :datetime
      t.column :patient_first_name, :string, :limit   => 50
      t.column :patient_last_name,  :string, :limit   => 50
      t.column :patientid,  :string, :limit   => 50
      t.column :patient_address1, :string, :limit   => 50
      t.column :patient_address2, :string, :limit   => 50
      t.column :patient_city, :string, :limit   => 50
      t.column :patient_state,  :string, :limit   => 50
      t.column :patient_zipcode,  :integer
      t.column :patient_country_code, :string, :limit   => 50
      t.column :patient_dob,  :datetime
      t.column :patient_gender, :string, :limit   => 50
      t.column :admission_date, :datetime
      t.column :admission_hour, :string, :limit   => 50
      t.column :admission_type, :string, :limit   => 50
      t.column :admission_source, :string, :limit   => 50
      t.column :discharge_hour, :string, :limit   => 50
      t.column :patient_status_code,  :string, :limit   => 50
      t.column :condition_code1,  :string, :limit   => 50
      t.column :condition_code2,  :string, :limit   => 50
      t.column :condition_code3,  :string, :limit   => 50
      t.column :condition_code4,  :string, :limit   => 50
      t.column :condition_code5,  :string, :limit   => 50
      t.column :condition_code6,  :string, :limit   => 50
      t.column :condition_code7,  :string, :limit   => 50
      t.column :condition_code8,  :string, :limit   => 50
      t.column :condition_code9,  :string, :limit   => 50
      t.column :condition_code10,  :string, :limit   => 50
      t.column :condition_code11,  :string, :limit   => 50
      t.column :acdt_state, :string, :limit   => 50
      t.column :subscriber_first_name,  :string, :limit   => 50
      t.column :subscriber_last_name,  :string, :limit   => 50
      t.column :subscriber_address1,  :string, :limit   => 50
      t.column :subscriber_address2,  :string, :limit   => 50
      t.column :occurence_spanid,  :string, :limit   => 50
      t.column :subscriber_city,  :string, :limit   => 50
      t.column :subscriber_state,  :string, :limit   => 50
      t.column :subscriber_zipcode,  :string, :limit   => 50
      t.column :page_number,   :integer
      t.column :page_total,   :integer
      t.column :creation_date,  :datetime
      t.column :total_charges, :decimal, :precision => 8, :scale => 2
      t.column :total_non_covered_charges, :decimal, :precision => 8, :scale => 2
      t.column :dx_version_qualifier,  :string, :limit   => 50
      t.column :principal_diag,  :string, :limit   => 50
      t.column:other_diag1, :string, :limit   => 50
      t.column:other_diag2, :string, :limit   => 50
      t.column:other_diag3, :string, :limit   => 50
      t.column:other_diag4, :string, :limit   => 50
      t.column:other_diag5, :string, :limit   => 50
      t.column:other_diag6, :string, :limit   => 50
      t.column:other_diag7, :string, :limit   => 50
      t.column:other_diag8, :string, :limit   => 50
      t.column:other_diag9, :string, :limit   => 50
      t.column:other_diag10, :string, :limit   => 50
      t.column:other_diag11, :string, :limit   => 50
      t.column:other_diag12, :string, :limit   => 50
      t.column:other_diag13, :string, :limit   => 50
      t.column:other_diag14, :string, :limit   => 50
      t.column:other_diag15, :string, :limit   => 50
      t.column:other_diag16, :string, :limit   => 50
      t.column:other_diag17, :string, :limit   => 50
      t.column:admit_diag, :string, :limit   => 50
      t.column:patient_reason_visit_code1, :string, :limit   => 50
      t.column:patient_reason_visit_code2, :string, :limit   => 50
      t.column:patient_reason_visit_code3, :string, :limit   => 50
      t.column:pps_code, :string, :limit   => 50
      t.column:eci_code1, :string, :limit   => 50
      t.column:eci_code2, :string, :limit   => 50
      t.column:eci_code3, :string, :limit   => 50
      t.column:principal_proc_code, :integer
      t.column:principal_proc_date, :datetime
      t.column:other_proc_code1, :integer
      t.column:other_proc_code2, :integer
      t.column:other_proc_code3, :integer
      t.column:other_proc_code4, :integer
      t.column:other_proc_code5, :integer
      t.column:other_proc_date1, :datetime
      t.column:other_proc_date2, :datetime
      t.column:other_proc_date3, :datetime
      t.column:other_proc_date4, :datetime
      t.column:other_proc_date5, :datetime
      t.column:attending_npi, :string, :limit   => 50
      t.column:attending_qual, :string, :limit   => 50
      t.column:attendingid, :string, :limit   => 50
      t.column:attending_provider_first_name, :string, :limit   => 50
      t.column:attending_provider_last_name, :string, :limit   => 50
      t.column:operating_npi, :string, :limit   => 50
      t.column:operating_qual, :string, :limit   => 50
      t.column:operatingid, :string, :limit   => 50
      t.column:operating_provider_first_name, :string, :limit   => 50
      t.column:operating_provider_last_name, :string, :limit   => 50
      t.column:other_npi1, :string, :limit   => 50
      t.column:other_npi2, :string, :limit   => 50
      t.column:other_qual1, :string, :limit   => 50
      t.column:other_qual2, :string, :limit   => 50
      t.column:otherid1, :string, :limit   => 50
      t.column:otherid2, :string, :limit   => 50
      t.column:other_provider_first_name1, :string, :limit   => 50
      t.column:other_provider_first_name2, :string, :limit   => 50
      t.column:other_provider_last_name1, :string, :limit   => 50
      t.column:other_provider_last_name2, :string, :limit   => 50
      t.column:remarks, :text


      t.timestamps
    end
  end

  def self.down
    drop_table :ub04_claim_informations
  end
end
