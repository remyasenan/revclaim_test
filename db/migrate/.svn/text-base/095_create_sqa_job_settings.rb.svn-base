# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateSqaJobSettings < ActiveRecord::Migration
  def self.up
    create_table :sqa_job_settings do |t|
      t.column :value, :integer, :default => 2      
    end
    SqaJobSetting.create!(:value => 2)
  end

  def self.down
    drop_table :sqa_job_settings
  end
end
