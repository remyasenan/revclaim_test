# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AlterJobCount < ActiveRecord::Migration
  def self.up
    change_column :jobs, :count, :integer, :default => 0
  end
  def self.down
    change_column :jobs, :count, :integer
  end
end
