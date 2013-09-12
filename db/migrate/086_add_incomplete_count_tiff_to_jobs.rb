# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddIncompleteCountTiffToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :incomplete_count, :integer, :default => 0
    add_column :jobs, :incomplete_tiff, :string
  end

  def self.down
    remove_column :jobs, :incomplete_count
    remove_column :jobs, :incomplete_tiff
  end
end
