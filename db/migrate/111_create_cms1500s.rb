class CreateCms1500s < ActiveRecord::Migration
  def self.up
    create_table :cms1500s do |t|
       t.column :job_id, :integer,:references=>:jobs
      t.foreign_key :job_id,:jobs,:id
      t.column :insurance_type,:string,:limit => 25
      t.column :patient_last_name,:string,:limit => 28
      t.column :patient_suffix,:string,:limit =>20
      t.column :patient_first_name,:string,:limit =>28
      t.column :patient_middle_initial,:string,:limit =>28
      t.column :patient_address,:string,:limit =>50
      t.column :patient_city,:string,:limit =>24
      t.column :patient_state,:string,:limit =>3
      t.column :patient_zipcode,:string,:limit =>12
      t.column :patient_telephone,:string,:limit =>15
      t.column :patient_dob,:date
      t.column :patient_sex,:string,:limit =>2
      t.column :patient_relationship_to_insured,:string,:limit =>10
      t.column :patient_marital_status ,:string,:limit =>10
      t.column :patient_employment_status ,:string,:limit =>30
      t.column :patient_condition_to_employment,:string,:limit =>4
      t.column :patient_condition_to_auto_accident,:string,:limit =>4
      t.column :patient_condition_to_auto_accident_place,:string,:limit =>20
      t.column :patient_condition_to_other_accident,:string,:limit =>4
      t.column :patient_condition_reserved_for_local_use,:string,:limit =>30
      t.column :patient_signature_on_file,:string,:limit =>25
      t.column :patient_signed_date,:date
      t.column :insured_signature_on_file,:string,:limit =>25
      t.column :date_of_current_illness ,:date
      t.column :first_date_similar_illness,:date
      t.column :referring_provider_last_name,:string,:limit =>26
      t.column :referring_provider_suffix,:string,:limit =>20
      t.column :referring_provider_first_name,:string,:limit =>26
      t.column :referring_provider_middle_initial,:string,:limit =>26
      t.column :referring_provider_other_qualifier,:string,:limit =>10
      t.column :referring_provider_other_id,:string,:limit =>17
      t.column :referring_provider_npi_id,:integer,:limit =>10
      t.column :patient_unable_to_work_from_date,:date
      t.column :patient_unable_to_work_to_date,:date
      t.column :hospitalization_from_date,:date
      t.column :hospitalization_to_date,:date
      t.column :outside_lab,:string,:limit =>4
      t.column :outside_lab_charge,:decimal,:precision => 8, :scale => 2
      t.column :medicaid_resubmission_code,:string,:limit =>11
      t.column :medicaid_resubmission_ref_number,:string,:limit =>18
      t.column :prior_authorization_number,:string,:limit =>29
      t.column :reserved_local_use,:string,:limit =>83
      t.column :nature_of_illness_or_injury_1,:string,:limit =>8
      t.column :nature_of_illness_or_injury_2,:string,:limit =>8
      t.column :nature_of_illness_or_injury_3,:string,:limit =>8
      t.column :nature_of_illness_or_injury_4,:string,:limit =>8
      t.column :accept_assignment,:string,:limit =>4
      t.column :patient_account_number,:string,:limit =>14
      t.column :federal_tax_id,:string,:limit =>15
      t.column :federal_tax_id_type,:string,:limit =>4
      t.column :physician_last_name,:string,:limit =>28
      t.column :physician_suffix,:string,:limit =>20
      t.column :physician_first_name,:string,:limit =>28
      t.column :physician_middle_initial,:string,:limit =>28
      t.column :physician_signature_on_file,:string,:limit =>25
      t.column :physician_sign_date,:date
      t.column :service_facility_name,:string,:limit =>50
      t.column :service_facility_address,:string,:limit =>50
      t.column :service_facility_city,:string,:limit =>30
      t.column :service_facility_state,:string,:limit =>3
      t.column :service_facility_zipcode,:string,:limit =>15
      t.column :service_facility_npi_id,:integer,:limit =>10
      t.column :service_facility_non_npi_id,:string,:limit =>14
      t.column :billing_provider_name,:string,:limit =>50
      t.column :billing_provider_last_name,:string,:limit =>30
      t.column :billing_provider_suffix,:integer,:string =>20
      t.column :billing_provider_first_name,:string,:limit =>20
      t.column :billing_provider_middle_initial,:string,:limit =>10
      t.column :billing_provider_address,:string,:limit =>50
      t.column :billing_provider_city,:string,:limit =>10
      t.column :billing_provider_state,:string,:limit =>3
      t.column :billing_provider_phone,:string,:limit =>15
      t.column :billing_provider_zipcode,:string,:limit =>15
      t.column :billing_provider_npi_id,:integer,:limit =>10
      t.column :billing_provider_non_npi_id,:string,:limit =>17
      t.column :total_charge,:decimal,:precision => 7, :scale => 2
      t.column :amount_paid,:decimal,:precision => 6, :scale => 2
      t.column :balance_due,:decimal,:precision => 6, :scale => 2
      t.column :insured_id,:string,:limit =>29
      t.column :insured_last_name,:string,:limit =>29
      t.column :insured_suffix,:string,:limit =>10
      t.column :insured_first_name,:string,:limit =>29
      t.column :insured_middle_initial,:string,:limit =>29
      t.column :insured_address,:string,:limit =>50
      t.column :insured_state,:string,:limit =>4
      t.column :insured_city,:string,:limit =>23
      t.column :insured_zipcode,:string,:limit =>12
      t.column :insured_telephone,:string,:limit =>15
      t.column :insured_policy_group_or_feca_number,:string,:limit =>29
      t.column :insured_dob,:date
      t.column :insured_sex,:string,:limit =>2
      t.column :insured_employers_or_school_name,:string,:limit =>29
      t.column :insured_plan_name,:string,:limit =>29
      t.column :other_health_benefit_plan,:string,:limit =>5
      t.column :other_insured_last_name,:string,:limit =>28
      t.column :other_insured_suffix,:string,:limit =>20
      t.column :other_insured_first_name,:string,:limit =>28
      t.column :other_insured_middle_initial,:string,:limit =>28
      t.column :other_insured_policy_or_group_number,:string,:limit =>28
      t.column :other_insured_dob,:date
      t.column :other_insured_sex,:string,:limit =>3
      t.column :other_insured_employers_or_school_name,:string,:limit =>28
      t.column :other_insured_insurance_plan_name,:string,:limit =>28
      t.column :payer_id,:string,:limit =>28
      t.column :created_at,:datetime
      t.column :updated_at,:datetime
    end
  end

  def self.down
    drop_table :cms1500s
  end
end
