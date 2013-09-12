class DropForeignKeyUserId < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE certifications DROP FOREIGN KEY certifications_ibfk_1"
    execute "ALTER TABLE eob_qas DROP FOREIGN KEY eob_qas_ibfk_1"
    execute "ALTER TABLE hlsc_documents DROP FOREIGN KEY fk_hlsc_user_id"
    execute "ALTER TABLE hlsc_qas DROP FOREIGN KEY hlsc_qas_ibfk_2"
    execute "ALTER TABLE user_client_job_histories DROP FOREIGN KEY user_client_job_histories_ibfk_1"
    execute "ALTER TABLE user_payer_job_histories DROP FOREIGN KEY user_payer_job_histories_ibfk_1"
  end

  def self.down
  end
end
