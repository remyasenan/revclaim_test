# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddJobStatusAndQaStatusToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :job_status, :string, :default => 'New'
    add_column :jobs, :qa_status, :string, :default => 'New'
  end

  def self.down
    remove_column :jobs, :job_status
    remove_column :jobs, :qa_status
  end
end
