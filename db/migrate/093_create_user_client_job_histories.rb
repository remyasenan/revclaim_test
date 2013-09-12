# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateUserClientJobHistories < ActiveRecord::Migration
  def self.up
    create_table :user_client_job_histories do |t|
      t.column :user_id, :integer
      t.foreign_key :user_id,:users,:id
      t.column :client_id, :integer
      t.foreign_key :client_id,:clients,:id
      t.column :job_count, :integer, :default => 0
    end
  end

  def self.down
    drop_table :user_client_job_histories
  end
end
