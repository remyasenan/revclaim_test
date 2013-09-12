# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.column :batch_id, :integer
      t.foreign_key :batch_id,:batches,:id
      t.column :check_number, :string
      t.column :tiff_number, :string
      t.column :count, :integer
      t.column :status, :string, :default => 'New'
      t.column :user_id, :integer
#      t.foreign_key :user_id,:users,:id
      t.column :processor_flag_time, :datetime
      t.column :processor_target_time, :datetime
      t.column :qa_flag_time, :datetime
      t.column :qa_target_time, :datetime
    end
  end

  def self.down
    drop_table :jobs
  end
end
