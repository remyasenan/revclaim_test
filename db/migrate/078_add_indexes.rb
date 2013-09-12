# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :status
    add_index :users, :role
    add_index :batches, :batchid
    add_index :jobs, :processor_status
    add_index :jobs, :qa_status
    add_index :eob_reports, :qa
    add_index :eob_reports, :processor
  end

  def self.down
    remove_index :users, :status
    remove_index :users, :role
    remove_index :batches, :batchid
    remove_index :jobs, :processor_status
    remove_index :jobs, :qa_status
    remove_index :eob_reports, :qa
    remove_index :eob_reports, :processor
  end
end
