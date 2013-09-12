# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateUserPayerJobHistories < ActiveRecord::Migration
  def self.up
    create_table :user_payer_job_histories do |t|
      t.column :user_id, :integer
      t.foreign_key :user_id,:users,:id
      t.column :payer_id, :integer
      t.foreign_key :payer_id,:payers,:id
      t.column :job_count, :integer, :default => 0
    end
  end

  def self.down
    drop_table :user_payer_job_histories
  end
end
