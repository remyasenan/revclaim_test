# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateEobReports < ActiveRecord::Migration
  def self.up
    create_table :eob_reports do |t|
      t.column :verify_time, :datetime
      t.column :account_number, :integer
      t.column :processor, :string
      t.column :accuracy, :integer
      t.column :qa, :string
      t.column :batch_id, :integer
      t.foreign_key :batch_id,:batches,:id
      t.column :batch_date, :datetime
      t.column :total_fields, :integer
      t.column :incorrect_fields, :integer
      t.column :error_type, :string
      t.column :error_severity, :integer
      t.column :error_code, :string
      t.column :status, :string
    end
  end

  def self.down
    drop_table :eob_reports
  end
end
