# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateQaStatuses < ActiveRecord::Migration
  def self.up
    create_table :qa_statuses do |t|
      t.column :name, :string
    end
    
    QaStatus.enumeration_model_updates_permitted = true
    
    qa_statuses = [{:name => 'New'}, {:name => 'QA Allocated'}, {:name => 'QA Complete'}, {:name => 'QA Rejected'},{:name => 'QA InComplete'}]
    qa_statuses.each do |qa_status|
      new_qa_status = QaStatus.new(qa_status)
      new_qa_status.save
    end
    
    QaStatus.enumeration_model_updates_permitted = false
  end

  def self.down
    drop_table :qa_statuses
  end
end
