# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateProcessorStatuses < ActiveRecord::Migration
  def self.up
    create_table :processor_statuses do |t|
      t.column :name, :string
    end
    
    ProcessorStatus.enumeration_model_updates_permitted = true
    
    processor_statuses = [{:name => 'New'}, {:name => 'Processor Allocated'}, {:name => 'Processor Complete'}]
    processor_statuses.each do |processor_status|
      new_processor_status = ProcessorStatus.new(processor_status)
      new_processor_status.save
    end
    
    ProcessorStatus.enumeration_model_updates_permitted = false
  end

  def self.down
    drop_table :processor_statuses
  end
end
