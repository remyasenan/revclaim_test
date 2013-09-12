# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateBatchStatuses < ActiveRecord::Migration
  def self.up
    create_table :batch_statuses do |t|
      t.column :name, :string
    end
    
    BatchStatus.enumeration_model_updates_permitted = true
    
    statuses = [{:name => 'New'},{:name => 'Processing'},{:name => 'Complete'},{:name => 'HLSC Rejected'},{:name => 'HLSC Verified'}]
    statuses.each do |status|
      new_status = BatchStatus.new(status)
      new_status.save
    end
    
    BatchStatus.enumeration_model_updates_permitted = false   
  end

  def self.down
    drop_table :batch_statuses
  end
end
