# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateJobStatuses < ActiveRecord::Migration
  def self.up
    create_table :job_statuses do |t|
      t.column :name, :string
    end
    
    JobStatus.enumeration_model_updates_permitted = true
    
    job_statuses = [{:name => 'New'}, {:name => 'Processing'}, {:name => 'Complete'}, {:name => 'HLSC Rejected'}, {:name => 'HLSC Verified'}, {:name => 'QA Rejected'},{:name => 'Incomplete'}]
    job_statuses.each do |job_status|
      new_job_status = JobStatus.new(job_status)
      new_job_status.save
    end
    
    JobStatus.enumeration_model_updates_permitted = false
  end

  def self.down
    drop_table :job_statuses
  end
end
