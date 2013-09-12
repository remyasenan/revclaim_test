# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateEobQaStatuses < ActiveRecord::Migration
  def self.up
    create_table :eob_qa_statuses do |t|
      t.column :name, :string
    end
    EobQaStatus.enumeration_model_updates_permitted = true
    statuses = [{:name => 'Accepted'},{:name => 'Rejected'}]
    statuses.each do |s|
      new_status = EobQaStatus.new(s)
      new_status.save
    end
    EobQaStatus.enumeration_model_updates_permitted = false
  end

  def self.down
    drop_table :eob_qa_statuses
  end
end
