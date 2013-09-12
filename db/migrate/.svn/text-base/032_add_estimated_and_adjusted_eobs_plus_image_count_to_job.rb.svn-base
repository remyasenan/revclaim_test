# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddEstimatedAndAdjustedEobsPlusImageCountToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :estimated_eob, :integer
    add_column :jobs, :adjusted_eob, :integer
    add_column :jobs, :image_count, :integer
  end

  def self.down
    remove_column :jobs, :estimated_eob
    remove_column :jobs, :adjusted_eob
    remove_column :jobs, :image_count
  end
end
