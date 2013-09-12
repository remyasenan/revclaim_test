# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateBatches < ActiveRecord::Migration
  def self.up
    create_table :batches do |t|
      t.column :batchid, :integer
      t.column :date, :date
      t.column :facility_id, :integer
      t.foreign_key :facility_id, :facilities, :id
      t.column :check_volume, :integer
      t.column :arrival_time, :datetime
      t.column :target_time, :datetime
      t.column :status, :string, :default => 'New'
      t.column :eob, :integer
    end
  end

  def self.down
    drop_table :batches
  end
end
