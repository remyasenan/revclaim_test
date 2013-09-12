# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateEobQa < ActiveRecord::Migration
  def self.up
    create_table :eob_qas do |t|
      t.column :processor_id, :integer
      t.column :qa_id, :integer
      t.foreign_key :qa_id,:users,:id
      t.column :job_id, :integer
      t.foreign_key :job_id,:jobs,:id
      t.column :time_of_rejection, :datetime
      t.column :account_number, :string
      t.column :total_fields, :integer
      t.column :total_incorrect_fields, :integer
      t.column :status, :string
      t.column :total_qa_checked, :integer
      t.column :comment, :string
    end
  end

  def self.down
    drop_table :eob_qas
  end
end
