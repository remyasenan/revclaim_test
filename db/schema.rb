# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100607051521) do

  create_table "batch_rejection_comments", :force => true do |t|
    t.string "comment"
  end

  create_table "batch_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "batches", :force => true do |t|
    t.string   "batchid"
    t.date     "date"
    t.integer  "facility_id"
    t.datetime "arrival_time"
    t.datetime "target_time"
    t.string   "status",          :default => "New"
    t.integer  "eob"
    t.datetime "completion_time"
    t.integer  "payer_id"
    t.string   "comment"
    t.datetime "contracted_time"
    t.boolean  "manual_override", :default => false
    t.string   "source",          :default => "Manual"
    t.integer  "updated_by"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "hlsc_id"
    t.integer  "correspondence",  :default => 0
    t.integer  "system_issue",    :default => 0
    t.integer  "policy_issue",    :default => 0
  end

  add_index "batches", ["facility_id"], :name => "facility_id"
  add_index "batches", ["status"], :name => "index_batches_on_status"
  add_index "batches", ["batchid"], :name => "index_batches_on_batchid"

  create_table "billing_provider_details", :force => true do |t|
    t.string  "billing_provider_first_name", :limit => 50
    t.string  "billing_provider_last_name",  :limit => 50
    t.string  "billing_provider_address1",   :limit => 50
    t.string  "billing_provider_address2",   :limit => 50
    t.string  "billing_provider_city",       :limit => 50
    t.string  "billing_provider_state",      :limit => 50
    t.integer "billing_provider_zipcode"
    t.string  "billing_provider_telephone",  :limit => 50
    t.integer "billing_provider_tin_or_ein"
    t.string  "billing_provider_npi",        :limit => 50
  end

  create_table "certifications", :force => true do |t|
    t.integer "user_id"
    t.integer "client_id"
    t.date    "date"
  end

  add_index "certifications", ["user_id"], :name => "user_id"
  add_index "certifications", ["client_id"], :name => "client_id"

  create_table "client_status_histories", :force => true do |t|
    t.integer  "batch_id"
    t.datetime "time"
    t.string   "status"
    t.string   "user"
  end

  add_index "client_status_histories", ["batch_id"], :name => "batch_id"

  create_table "clients", :force => true do |t|
    t.string  "name"
    t.integer "tat"
    t.integer "contracted_tat", :default => 20
  end

  create_table "cms1500s", :force => true do |t|
    t.integer  "job_id"
    t.string   "insurance_type",                           :limit => 25
    t.string   "patient_last_name",                        :limit => 40
    t.string   "patient_suffix",                           :limit => 20
    t.string   "patient_first_name",                       :limit => 40
    t.string   "patient_middle_initial",                   :limit => 28
    t.string   "patient_address",                          :limit => 28
    t.string   "patient_city",                             :limit => 24
    t.string   "patient_state",                            :limit => 3
    t.string   "patient_zipcode",                          :limit => 12
    t.string   "patient_telephone",                        :limit => 15
    t.date     "patient_dob"
    t.string   "patient_sex",                              :limit => 2
    t.string   "patient_relationship_to_insured",          :limit => 10
    t.string   "patient_marital_status",                   :limit => 10
    t.string   "patient_employment_status",                :limit => 30
    t.string   "patient_condition_to_employment",          :limit => 4
    t.string   "patient_condition_to_auto_accident",       :limit => 4
    t.string   "patient_condition_to_auto_accident_place", :limit => 20
    t.string   "patient_condition_to_other_accident",      :limit => 4
    t.string   "patient_condition_reserved_for_local_use", :limit => 19
    t.string   "patient_signature_on_file",                :limit => 25
    t.date     "patient_signed_date"
    t.string   "insured_signature_on_file",                :limit => 25
    t.date     "date_of_current_illness"
    t.date     "first_date_similar_illness"
    t.string   "referring_provider_last_name",             :limit => 40
    t.string   "referring_provider_suffix",                :limit => 20
    t.string   "referring_provider_first_name",            :limit => 40
    t.string   "referring_provider_middle_initial",        :limit => 26
    t.string   "referring_provider_other_qualifier",       :limit => 10
    t.string   "referring_provider_other_id",              :limit => 17
    t.integer  "referring_provider_npi_id"
    t.date     "patient_unable_to_work_from_date"
    t.date     "patient_unable_to_work_to_date"
    t.date     "hospitalization_from_date"
    t.date     "hospitalization_to_date"
    t.string   "outside_lab",                              :limit => 4
    t.decimal  "outside_lab_charge",                                     :precision => 8, :scale => 2
    t.string   "medicaid_resubmission_code",               :limit => 11
    t.string   "medicaid_resubmission_ref_number",         :limit => 18
    t.string   "prior_authorization_number",               :limit => 29
    t.string   "reserved_local_use",                       :limit => 83
    t.string   "nature_of_illness_or_injury_1",            :limit => 8
    t.string   "nature_of_illness_or_injury_2",            :limit => 8
    t.string   "nature_of_illness_or_injury_3",            :limit => 8
    t.string   "nature_of_illness_or_injury_4",            :limit => 8
    t.string   "accept_assignment",                        :limit => 4
    t.string   "patient_account_number",                   :limit => 14
    t.string   "federal_tax_id",                           :limit => 15
    t.string   "federal_tax_id_type",                      :limit => 4
    t.string   "physician_last_name",                      :limit => 40
    t.string   "physician_suffix",                         :limit => 20
    t.string   "physician_first_name",                     :limit => 40
    t.string   "physician_middle_initial",                 :limit => 28
    t.string   "physician_signature_on_file",              :limit => 25
    t.date     "physician_sign_date"
    t.string   "service_facility_name",                    :limit => 50
    t.string   "service_facility_address",                 :limit => 50
    t.string   "service_facility_city",                    :limit => 30
    t.string   "service_facility_state",                   :limit => 3
    t.string   "service_facility_zipcode",                 :limit => 15
    t.integer  "service_facility_npi_id"
    t.string   "service_facility_non_npi_id",              :limit => 14
    t.string   "billing_provider_name",                    :limit => 50
    t.string   "billing_provider_last_name",               :limit => 40
    t.string   "billing_provider_suffix",                  :limit => 20
    t.string   "billing_provider_first_name",              :limit => 40
    t.string   "billing_provider_middle_initial",          :limit => 10
    t.string   "billing_provider_address",                 :limit => 50
    t.string   "billing_provider_city",                    :limit => 10
    t.string   "billing_provider_state",                   :limit => 3
    t.string   "billing_provider_phone",                   :limit => 15
    t.string   "billing_provider_zipcode",                 :limit => 15
    t.integer  "billing_provider_npi_id"
    t.string   "billing_provider_non_npi_id",              :limit => 17
    t.decimal  "total_charge",                                           :precision => 7, :scale => 2
    t.decimal  "amount_paid",                                            :precision => 6, :scale => 2
    t.decimal  "balance_due",                                            :precision => 6, :scale => 2
    t.string   "insured_id",                               :limit => 29
    t.string   "insured_last_name",                        :limit => 40
    t.string   "insured_suffix",                           :limit => 10
    t.string   "insured_first_name",                       :limit => 40
    t.string   "insured_middle_initial",                   :limit => 29
    t.string   "insured_address",                          :limit => 29
    t.string   "insured_state",                            :limit => 4
    t.string   "insured_city",                             :limit => 23
    t.string   "insured_zipcode",                          :limit => 12
    t.string   "insured_telephone",                        :limit => 15
    t.string   "insured_policy_group_or_feca_number",      :limit => 29
    t.date     "insured_dob"
    t.string   "insured_sex",                              :limit => 2
    t.string   "insured_employers_or_school_name",         :limit => 29
    t.string   "insured_plan_name",                        :limit => 29
    t.string   "other_health_benefit_plan",                :limit => 5
    t.string   "other_insured_last_name",                  :limit => 40
    t.string   "other_insured_suffix",                     :limit => 20
    t.string   "other_insured_first_name",                 :limit => 40
    t.string   "other_insured_middle_initial",             :limit => 28
    t.string   "other_insured_policy_or_group_number",     :limit => 28
    t.date     "other_insured_dob"
    t.string   "other_insured_sex",                        :limit => 3
    t.string   "other_insured_employers_or_school_name",   :limit => 28
    t.string   "other_insured_insurance_plan_name",        :limit => 28
    t.string   "physician_organisation_name",              :limit => 28
    t.string   "payer_id",                                 :limit => 28
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reffering_provider_organisation_name",     :limit => 40
    t.text     "details"
  end

  add_index "cms1500s", ["job_id"], :name => "job_id"

  create_table "cms1500servicelines", :force => true do |t|
    t.integer "cms1500_id"
    t.date    "service_from_date"
    t.date    "service_to_date"
    t.string  "service_place",                       :limit => 2
    t.string  "emg",                                 :limit => 2
    t.string  "cpt_hcpcts",                          :limit => 6
    t.string  "modifier1",                           :limit => 2
    t.string  "modifier2",                           :limit => 2
    t.string  "modifier3",                           :limit => 2
    t.string  "modifier4",                           :limit => 2
    t.integer "diagnosis_pointer"
    t.decimal "charges",                                           :precision => 10, :scale => 2
    t.decimal "days_units",                                        :precision => 10, :scale => 2
    t.string  "epsdt",                               :limit => 2
    t.string  "family_plan",                         :limit => 5
    t.string  "qual_id",                             :limit => 5
    t.string  "rendering_provider_id",               :limit => 11
    t.integer "rendering_provider_qualifier_npi_id"
    t.text    "details"
  end

  add_index "cms1500servicelines", ["cms1500_id"], :name => "cms1500_id"

  create_table "cpt_codes", :force => true do |t|
    t.string   "code",        :limit => 5, :null => false
    t.string   "description",              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cpt_codes", ["code"], :name => "index_cpt_codes_on_code", :unique => true

  create_table "documents", :force => true do |t|
    t.string   "filename"
    t.binary   "content",    :limit => 16777215
    t.string   "file_type"
    t.integer  "client_id"
    t.datetime "created_at"
  end

  add_index "documents", ["client_id"], :name => "fk_document_client_id"

  create_table "eob_errors", :force => true do |t|
    t.string  "error_type"
    t.integer "severity"
    t.string  "code"
    t.string  "form_type",  :default => "1500"
  end

  create_table "eob_qa_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "eob_qas", :force => true do |t|
    t.integer  "processor_id"
    t.integer  "qa_id"
    t.integer  "job_id"
    t.datetime "time_of_rejection"
    t.string   "account_number"
    t.integer  "total_fields"
    t.integer  "total_incorrect_fields"
    t.string   "status"
    t.integer  "total_qa_checked"
    t.string   "comment"
    t.integer  "eob_error_id"
    t.string   "payer"
    t.string   "prev_status"
    t.integer  "accuracy"
  end

  add_index "eob_qas", ["qa_id"], :name => "qa_id"
  add_index "eob_qas", ["job_id"], :name => "job_id"
  add_index "eob_qas", ["eob_error_id"], :name => "fk_eob_error_id"

  create_table "eob_reports", :force => true do |t|
    t.datetime "verify_time"
    t.string   "account_number"
    t.string   "processor"
    t.integer  "accuracy"
    t.string   "qa"
    t.integer  "batch_id"
    t.datetime "batch_date"
    t.integer  "total_fields"
    t.integer  "incorrect_fields"
    t.string   "error_type"
    t.integer  "error_severity"
    t.string   "error_code"
    t.string   "status"
    t.integer  "payer_id"
    t.string   "payer"
  end

  add_index "eob_reports", ["batch_id"], :name => "batch_id"
  add_index "eob_reports", ["payer_id"], :name => "fk_eob_report_payer_id"
  add_index "eob_reports", ["qa"], :name => "index_eob_reports_on_qa"
  add_index "eob_reports", ["processor"], :name => "index_eob_reports_on_processor"

  create_table "eob_sqas", :force => true do |t|
    t.integer  "job_id"
    t.integer  "processor_id"
    t.integer  "qa_id"
    t.integer  "sqa_id"
    t.datetime "sqa_flag_time"
    t.integer  "total_fields"
    t.integer  "total_incorrect_fields"
    t.integer  "error_id"
    t.string   "comments"
    t.integer  "total_eobs",             :default => 0
    t.integer  "total_incorrect_eobs",   :default => 0
    t.string   "eob_comments"
    t.float    "accuracy"
    t.float    "field_accuracy"
    t.integer  "batch_id"
    t.datetime "batch_date"
  end

  add_index "eob_sqas", ["job_id"], :name => "index_eob_sqas_on_job_id"
  add_index "eob_sqas", ["processor_id"], :name => "index_eob_sqas_on_processor_id"
  add_index "eob_sqas", ["qa_id"], :name => "index_eob_sqas_on_qa_id"
  add_index "eob_sqas", ["sqa_id"], :name => "index_eob_sqas_on_sqa_id"
  add_index "eob_sqas", ["error_id"], :name => "index_eob_sqas_on_error_id"
  add_index "eob_sqas", ["batch_id"], :name => "fk_eob_batch_id"

  create_table "eobrates", :force => true do |t|
    t.integer "high"
    t.integer "medium"
    t.integer "low"
    t.integer "client_id"
  end

  add_index "eobrates", ["client_id"], :name => "fk_eobrate_client_id"

  create_table "error_popups", :force => true do |t|
    t.string  "comment"
    t.integer "payer_id"
    t.integer "facility_id"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "file_id"
  end

  add_index "error_popups", ["facility_id"], :name => "facility_id"

  create_table "facilities", :force => true do |t|
    t.string  "name"
    t.integer "client_id"
    t.string  "sitecode"
  end

  add_index "facilities", ["client_id"], :name => "fk_client_id"

  create_table "hlsc_documents", :force => true do |t|
    t.string   "file_name"
    t.string   "file_location"
    t.string   "file_comments"
    t.datetime "file_created_time"
    t.integer  "payer_id"
    t.integer  "facility_id"
    t.integer  "user_id"
  end

  add_index "hlsc_documents", ["payer_id"], :name => "fk_hlsc_payer_id"
  add_index "hlsc_documents", ["facility_id"], :name => "fk_hlsc_facility_id"
  add_index "hlsc_documents", ["user_id"], :name => "fk_hlsc_user_id"

  create_table "hlsc_qas", :force => true do |t|
    t.integer "batch_id"
    t.integer "user_id"
    t.integer "total_eobs"
    t.integer "rejected_eobs"
  end

  add_index "hlsc_qas", ["batch_id"], :name => "batch_id"
  add_index "hlsc_qas", ["user_id"], :name => "user_id"

  create_table "images_for_jobs", :force => true do |t|
    t.integer "parent_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
  end

  create_table "isa_identifiers", :force => true do |t|
    t.integer "isa_number"
  end

  create_table "job_rejection_comments", :force => true do |t|
    t.string "comment"
  end

  create_table "job_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "jobs", :force => true do |t|
    t.integer  "batch_id"
    t.string   "check_number"
    t.string   "tiff_number"
    t.integer  "count",                 :default => 0
    t.string   "processor_status"
    t.datetime "processor_flag_time"
    t.datetime "processor_target_time"
    t.datetime "qa_flag_time"
    t.datetime "qa_target_time"
    t.integer  "qa_id"
    t.integer  "processor_id"
    t.integer  "payer_id"
    t.integer  "estimated_eob"
    t.integer  "adjusted_eob"
    t.integer  "image_count"
    t.string   "comment"
    t.string   "job_status",            :default => "New"
    t.string   "qa_status",             :default => "New"
    t.integer  "updated_by"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.datetime "created_at"
    t.string   "comment_for_qa"
    t.integer  "rejections",            :default => 0
    t.integer  "incomplete_count",      :default => 0
    t.string   "incomplete_tiff"
    t.boolean  "work_queue",            :default => false
    t.datetime "work_queue_flagtime"
    t.integer  "sqa_id",                :default => 0
    t.string   "sqa_status",            :default => "New"
    t.integer  "hlsc_id"
    t.integer  "images_for_job_id"
    t.string   "processor_comments",    :default => "null"
    t.string   "rejected_comment"
    t.string   "qa_comment"
    t.integer  "time_taken"
    t.integer  "sequence_id",           :default => 0
    t.datetime "processor_start_time"
  end

  add_index "jobs", ["batch_id"], :name => "index_jobs_on_batch_id"
  add_index "jobs", ["processor_id"], :name => "index_jobs_on_processor_id"
  add_index "jobs", ["qa_id"], :name => "index_jobs_on_qa_id"
  add_index "jobs", ["processor_status"], :name => "index_jobs_on_processor_status"
  add_index "jobs", ["qa_status"], :name => "index_jobs_on_qa_status"
  add_index "jobs", ["work_queue"], :name => "index_jobs_on_work_queue"
  add_index "jobs", ["sqa_id"], :name => "index_jobs_on_sqa_id"
  add_index "jobs", ["sqa_status"], :name => "index_jobs_on_sqa_status"
  add_index "jobs", ["images_for_job_id"], :name => "fk_images_for_job_id"
  add_index "jobs", ["processor_id"], :name => "jobs_processor_id_index"

  create_table "occurence_spans", :force => true do |t|
    t.integer  "ub04_claim_information_id"
    t.string   "code1"
    t.string   "code2"
    t.datetime "from_date1"
    t.datetime "from_date2"
    t.datetime "through_date1"
    t.datetime "through_date2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "occurences", :force => true do |t|
    t.integer  "ub04_claim_information_id"
    t.string   "code1"
    t.string   "code2"
    t.string   "code3"
    t.string   "code4"
    t.datetime "date1"
    t.datetime "date2"
    t.datetime "date3"
    t.datetime "date4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payer_details", :force => true do |t|
    t.string  "payer_name",     :limit => 50
    t.string  "payer_address1", :limit => 50
    t.string  "payer_address2", :limit => 50
    t.string  "payer_city",     :limit => 50
    t.string  "payer_state",    :limit => 50
    t.integer "payer_zipcode"
  end

  create_table "payergroups", :force => true do |t|
    t.string "payergroupname"
  end

  create_table "payers", :force => true do |t|
    t.date    "date_added"
    t.string  "initials"
    t.string  "from"
    t.string  "gateway"
    t.string  "payid"
    t.string  "payer"
    t.string  "gr_name"
    t.text    "pay_address_one"
    t.text    "pay_address_two"
    t.text    "pay_address_three"
    t.text    "pay_address_four"
    t.string  "phone"
    t.integer "payer_group_id",    :default => 0
    t.integer "cms1500_id"
    t.string  "zipcode"
    t.string  "state"
    t.string  "city"
    t.text    "details"
  end

  create_table "processor_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "qa_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "qualifier_code_values", :force => true do |t|
    t.integer  "ub04_claim_information_id"
    t.string   "qualifier"
    t.string   "code"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "query_details", :force => true do |t|
    t.string   "criteria"
    t.string   "compare"
    t.date     "from"
    t.date     "to"
    t.datetime "created_at"
    t.string   "from_time"
    t.string   "to_time"
  end

  create_table "remittors", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "is_deleted"
    t.string   "remark"
    t.string   "rating"
    t.integer  "processing_rate_others"
    t.integer  "processing_rate_triad"
    t.integer  "total_fields"
    t.integer  "total_incorrect_fields"
    t.float    "field_accuracy"
    t.integer  "eob_qa_checked"
    t.integer  "total_eobs"
    t.integer  "rejected_eobs"
    t.float    "eob_accuracy"
    t.integer  "shift_id"
    t.string   "status"
    t.string   "name"
  end

  create_table "remittors_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "remittor_id"
  end

  add_index "remittors_roles", ["role_id"], :name => "index_remittors_roles_on_role_id"
  add_index "remittors_roles", ["remittor_id"], :name => "index_remittors_roles_on_remittor_id"

  create_table "rendering_provider_details", :force => true do |t|
    t.string  "rendering_provider_first_name", :limit => 50
    t.string  "rendering_provider_last_name",  :limit => 50
    t.string  "rendering_provider_address1",   :limit => 50
    t.string  "rendering_provider_city",       :limit => 50
    t.string  "rendering_provider_state",      :limit => 50
    t.integer "rendering_provider_zipcode"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "runners", :force => true do |t|
    t.datetime "imported_at"
    t.string   "imported_by"
    t.string   "imported_from"
    t.integer  "batchid"
  end

  create_table "sampling_rates", :force => true do |t|
    t.string  "slab"
    t.integer "value", :default => 5
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "shifts", :force => true do |t|
    t.string "name"
    t.time   "start_time"
    t.float  "duration"
  end

  create_table "site_settings", :force => true do |t|
    t.boolean "show_userid", :default => true
    t.integer "per_page",    :default => 30
  end

  create_table "sqa_job_settings", :force => true do |t|
    t.integer "value", :default => 2
  end

  create_table "states", :force => true do |t|
    t.string "state_name", :limit => 50
    t.string "state_code", :limit => 3
  end

  create_table "statuses", :force => true do |t|
    t.string "value"
  end

  create_table "tats", :force => true do |t|
    t.datetime "expected_time"
    t.string   "comments"
    t.integer  "batch_id"
  end

  add_index "tats", ["batch_id"], :name => "batch_id"

  create_table "team_leader_queues", :force => true do |t|
    t.string   "tlusername"
    t.integer  "payer_group_id"
    t.integer  "workstatus"
    t.datetime "job_allocated_time"
  end

  create_table "typeahead_billing_providers", :force => true do |t|
    t.string  "billing_provider_name"
    t.string  "billing_provider_last_name"
    t.string  "billing_provider_suffix"
    t.string  "billing_provider_first_name"
    t.string  "billing_provider_middle_initial"
    t.string  "billing_provider_address"
    t.string  "billing_provider_city"
    t.string  "billing_provider_state"
    t.string  "billing_provider_zipcode"
    t.integer "billing_provider_npi_id"
    t.string  "billing_provider_non_npi_id"
  end

  create_table "typeahead_payers", :force => true do |t|
    t.string "payer"
    t.text   "pay_address_one"
    t.text   "pay_address_two"
    t.string "city"
    t.string "state"
    t.string "zipcode"
  end

  create_table "typeahead_service_facilities", :force => true do |t|
    t.string  "service_facility_name"
    t.string  "service_facility_address"
    t.string  "service_facility_city"
    t.string  "service_facility_state"
    t.string  "service_facility_zipcode"
    t.integer "service_facility_npi_id"
    t.string  "service_facility_non_npi_id"
  end

  create_table "ub04_claim_informations", :force => true do |t|
    t.integer  "job_id"
    t.integer  "claimid"
    t.datetime "claim_date"
    t.string   "claim_status",                  :limit => 50
    t.string   "claim_message",                 :limit => 50
    t.string   "billing_provider_first_name",   :limit => 50
    t.string   "billing_provider_last_name",    :limit => 50
    t.string   "billing_provider_address1",     :limit => 50
    t.string   "billing_provider_address2",     :limit => 50
    t.string   "billing_provider_city",         :limit => 50
    t.string   "billing_provider_state",        :limit => 50
    t.string   "billing_provider_zipcode"
    t.string   "billing_provider_telephone",    :limit => 50
    t.string   "billing_provider_tin_or_ein"
    t.integer  "billing_provider_npi"
    t.string   "billing_providerid1",           :limit => 50
    t.string   "billing_providerid2",           :limit => 50
    t.string   "billing_providerid3",           :limit => 50
    t.string   "rendering_provider_first_name", :limit => 50
    t.string   "rendering_provider_last_name",  :limit => 50
    t.string   "rendering_provider_address1",   :limit => 50
    t.string   "rendering_provider_city",       :limit => 50
    t.string   "rendering_provider_state",      :limit => 50
    t.string   "rendering_provider_zipcode"
    t.string   "rendering_providerid"
    t.string   "patient_account_number",        :limit => 50
    t.string   "patient_med_rec_number",        :limit => 50
    t.string   "patient_bill_type",             :limit => 50
    t.string   "federal_tax_number",            :limit => 50
    t.datetime "statement_cover_from"
    t.datetime "statement_cover_to"
    t.string   "patient_first_name",            :limit => 50
    t.string   "patient_last_name",             :limit => 50
    t.string   "patientid",                     :limit => 50
    t.string   "patient_address1",              :limit => 50
    t.string   "patient_address2",              :limit => 50
    t.string   "patient_city",                  :limit => 50
    t.string   "patient_state",                 :limit => 50
    t.string   "patient_zipcode"
    t.string   "patient_country_code",          :limit => 50
    t.datetime "patient_dob"
    t.string   "patient_gender",                :limit => 50
    t.datetime "admission_date"
    t.string   "admission_hour",                :limit => 50
    t.string   "admission_type",                :limit => 50
    t.string   "admission_source",              :limit => 50
    t.string   "discharge_hour",                :limit => 50
    t.string   "patient_status_code",           :limit => 50
    t.string   "condition_code1",               :limit => 50
    t.string   "condition_code2",               :limit => 50
    t.string   "condition_code3",               :limit => 50
    t.string   "condition_code4",               :limit => 50
    t.string   "condition_code5",               :limit => 50
    t.string   "condition_code6",               :limit => 50
    t.string   "condition_code7",               :limit => 50
    t.string   "condition_code8",               :limit => 50
    t.string   "condition_code9",               :limit => 50
    t.string   "condition_code10",              :limit => 50
    t.string   "condition_code11",              :limit => 50
    t.string   "acdt_state",                    :limit => 50
    t.string   "subscriber_first_name",         :limit => 50
    t.string   "subscriber_last_name",          :limit => 50
    t.string   "subscriber_address1",           :limit => 50
    t.string   "subscriber_address2",           :limit => 50
    t.string   "occurence_spanid",              :limit => 50
    t.string   "subscriber_city",               :limit => 50
    t.string   "subscriber_state",              :limit => 50
    t.string   "subscriber_zipcode",            :limit => 50
    t.integer  "page_number"
    t.integer  "page_total"
    t.datetime "creation_date"
    t.decimal  "total_charges",                               :precision => 10, :scale => 2
    t.decimal  "total_non_covered_charges",                   :precision => 10, :scale => 2
    t.string   "dx_version_qualifier",          :limit => 50
    t.string   "principal_diag",                :limit => 50
    t.string   "other_diag1",                   :limit => 50
    t.string   "other_diag2",                   :limit => 50
    t.string   "other_diag3",                   :limit => 50
    t.string   "other_diag4",                   :limit => 50
    t.string   "other_diag5",                   :limit => 50
    t.string   "other_diag6",                   :limit => 50
    t.string   "other_diag7",                   :limit => 50
    t.string   "other_diag8",                   :limit => 50
    t.string   "other_diag9",                   :limit => 50
    t.string   "other_diag10",                  :limit => 50
    t.string   "other_diag11",                  :limit => 50
    t.string   "other_diag12",                  :limit => 50
    t.string   "other_diag13",                  :limit => 50
    t.string   "other_diag14",                  :limit => 50
    t.string   "other_diag15",                  :limit => 50
    t.string   "other_diag16",                  :limit => 50
    t.string   "other_diag17",                  :limit => 50
    t.string   "admit_diag",                    :limit => 50
    t.string   "patient_reason_visit_code1",    :limit => 50
    t.string   "patient_reason_visit_code2",    :limit => 50
    t.string   "patient_reason_visit_code3",    :limit => 50
    t.string   "pps_code",                      :limit => 50
    t.string   "eci_code1",                     :limit => 50
    t.string   "eci_code2",                     :limit => 50
    t.string   "eci_code3",                     :limit => 50
    t.integer  "principal_proc_code"
    t.datetime "principal_proc_date"
    t.integer  "other_proc_code1"
    t.integer  "other_proc_code2"
    t.integer  "other_proc_code3"
    t.integer  "other_proc_code4"
    t.integer  "other_proc_code5"
    t.datetime "other_proc_date1"
    t.datetime "other_proc_date2"
    t.datetime "other_proc_date3"
    t.datetime "other_proc_date4"
    t.datetime "other_proc_date5"
    t.string   "attending_npi",                 :limit => 50
    t.string   "attending_qual",                :limit => 50
    t.string   "attendingid",                   :limit => 50
    t.string   "attending_provider_first_name", :limit => 50
    t.string   "attending_provider_last_name",  :limit => 50
    t.string   "operating_npi",                 :limit => 50
    t.string   "operating_qual",                :limit => 50
    t.string   "operatingid",                   :limit => 50
    t.string   "operating_provider_first_name", :limit => 50
    t.string   "operating_provider_last_name",  :limit => 50
    t.string   "other_npi1",                    :limit => 50
    t.string   "other_npi2",                    :limit => 50
    t.string   "other_qual1",                   :limit => 50
    t.string   "other_qual2",                   :limit => 50
    t.string   "otherid1",                      :limit => 50
    t.string   "otherid2",                      :limit => 50
    t.string   "other_provider_first_name1",    :limit => 50
    t.string   "other_provider_first_name2",    :limit => 50
    t.string   "other_provider_last_name1",     :limit => 50
    t.string   "other_provider_last_name2",     :limit => 50
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "billing_provider_telephone2",   :limit => 20
    t.string   "patient_middle_initial",        :limit => 5
    t.string   "subscriber_middle_initial",     :limit => 5
    t.string   "unlabel_7_1",                   :limit => 10
    t.string   "unlabel_7_2",                   :limit => 10
    t.string   "unlabel_30_1",                  :limit => 15
    t.string   "unlabel_30_2",                  :limit => 15
    t.string   "unlabel_37_1",                  :limit => 10
    t.string   "unlabel_37_2",                  :limit => 10
    t.string   "unlabel_42_23",                 :limit => 5
    t.string   "unlabel_68_1",                  :limit => 10
    t.string   "unlabel_68_2",                  :limit => 10
    t.string   "unlabel_73",                    :limit => 10
    t.string   "unlabel_75_1",                  :limit => 5
    t.string   "unlabel_75_2",                  :limit => 5
    t.string   "unlabel_75_3",                  :limit => 5
    t.string   "unlabel_75_4",                  :limit => 5
  end

  create_table "ub04_serviceline_informations", :force => true do |t|
    t.integer  "ub04_claim_information_id"
    t.string   "description"
    t.string   "hcpcs"
    t.integer  "rates"
    t.string   "hipps_codes"
    t.datetime "service_date"
    t.datetime "creation_date"
    t.integer  "service_units"
    t.decimal  "charges",                                 :precision => 10, :scale => 2
    t.decimal  "non_covered_charges",                     :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unlabel_49",                :limit => 5
    t.string   "rev_code",                  :limit => 50
  end

  create_table "ub04payers", :force => true do |t|
    t.integer  "ub04_claim_information_id"
    t.string   "name"
    t.string   "health_planid"
    t.string   "release_info"
    t.string   "assign_benefits"
    t.string   "prior_payments"
    t.string   "est_amounts"
    t.string   "insured_first_name"
    t.string   "insured_last_name"
    t.string   "patient_relationship"
    t.string   "insured_id"
    t.string   "group_name"
    t.string   "group_no"
    t.string   "treatment_authorisation"
    t.string   "document_control_no"
    t.string   "employer_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "insured_middle_initial",    :limit => 5
  end

  create_table "user_client_job_histories", :force => true do |t|
    t.integer "user_id"
    t.integer "client_id"
    t.integer "job_count", :default => 0
  end

  add_index "user_client_job_histories", ["user_id"], :name => "user_id"
  add_index "user_client_job_histories", ["client_id"], :name => "client_id"

  create_table "user_payer_job_histories", :force => true do |t|
    t.integer "user_id"
    t.integer "payer_id"
    t.integer "job_count", :default => 0
  end

  add_index "user_payer_job_histories", ["user_id"], :name => "user_id"
  add_index "user_payer_job_histories", ["payer_id"], :name => "payer_id"

  create_table "users", :force => true do |t|
    t.string  "name"
    t.string  "userid"
    t.string  "password"
    t.string  "remark"
    t.string  "role"
    t.string  "status",                 :default => "Offline"
    t.string  "session"
    t.string  "rating"
    t.integer "processing_rate_triad",  :default => 5
    t.integer "processing_rate_others", :default => 8
    t.boolean "is_deleted",             :default => false
    t.integer "total_fields",           :default => 0
    t.integer "total_incorrect_fields", :default => 0
    t.float   "field_accuracy",         :default => 100.0
    t.integer "eob_qa_checked",         :default => 0
    t.integer "total_eobs",             :default => 0
    t.integer "rejected_eobs",          :default => 0
    t.float   "eob_accuracy",           :default => 100.0
    t.integer "shift_id"
    t.integer "teamleader_id"
  end

  add_index "users", ["status"], :name => "index_users_on_status"
  add_index "users", ["role"], :name => "index_users_on_role"
  add_index "users", ["shift_id"], :name => "fk_shift_id"

  create_table "value_codes", :force => true do |t|
    t.integer  "ub04_claim_information_id"
    t.string   "code1"
    t.string   "code2"
    t.string   "code3"
    t.decimal  "amount1",                   :precision => 10, :scale => 2
    t.decimal  "amount2",                   :precision => 10, :scale => 2
    t.decimal  "amount3",                   :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "batches", ["facility_id"], "facilities", ["id"], :name => "batches_ibfk_1"

  add_foreign_key "certifications", ["client_id"], "clients", ["id"], :name => "certifications_ibfk_2"

  add_foreign_key "client_status_histories", ["batch_id"], "batches", ["id"], :name => "client_status_histories_ibfk_1"

  add_foreign_key "cms1500s", ["job_id"], "jobs", ["id"], :name => "cms1500s_ibfk_1"

  add_foreign_key "cms1500servicelines", ["cms1500_id"], "cms1500s", ["id"], :name => "cms1500servicelines_ibfk_1"

  add_foreign_key "documents", ["client_id"], "clients", ["id"], :name => "fk_document_client_id"

  add_foreign_key "eob_qas", ["job_id"], "jobs", ["id"], :name => "eob_qas_ibfk_2"
  add_foreign_key "eob_qas", ["eob_error_id"], "eob_errors", ["id"], :name => "fk_eob_error_id"

  add_foreign_key "eob_reports", ["payer_id"], "payers", ["id"], :name => "fk_eob_report_payer_id"

  add_foreign_key "eob_sqas", ["batch_id"], "batches", ["id"], :name => "fk_eob_batch_id"

  add_foreign_key "eobrates", ["client_id"], "clients", ["id"], :name => "fk_eobrate_client_id"

  add_foreign_key "error_popups", ["facility_id"], "facilities", ["id"], :name => "error_popups_ibfk_1"

  add_foreign_key "facilities", ["client_id"], "clients", ["id"], :name => "fk_client_id"

  add_foreign_key "hlsc_documents", ["facility_id"], "facilities", ["id"], :name => "fk_hlsc_facility_id"
  add_foreign_key "hlsc_documents", ["payer_id"], "payers", ["id"], :name => "fk_hlsc_payer_id"
  add_foreign_key "hlsc_documents", ["user_id"], "users", ["id"], :name => "fk_hlsc_user_id"

  add_foreign_key "hlsc_qas", ["batch_id"], "batches", ["id"], :name => "hlsc_qas_ibfk_1"
  add_foreign_key "hlsc_qas", ["user_id"], "users", ["id"], :name => "hlsc_qas_ibfk_2"

  add_foreign_key "jobs", ["images_for_job_id"], "images_for_jobs", ["id"], :name => "fk_images_for_job_id"
  add_foreign_key "jobs", ["batch_id"], "batches", ["id"], :name => "jobs_ibfk_1"

  add_foreign_key "tats", ["batch_id"], "batches", ["id"], :name => "tats_ibfk_1"

  add_foreign_key "user_client_job_histories", ["client_id"], "clients", ["id"], :name => "user_client_job_histories_ibfk_2"

  add_foreign_key "user_payer_job_histories", ["payer_id"], "payers", ["id"], :name => "user_payer_job_histories_ibfk_2"

  add_foreign_key "users", ["shift_id"], "shifts", ["id"], :name => "fk_shift_id"

end
