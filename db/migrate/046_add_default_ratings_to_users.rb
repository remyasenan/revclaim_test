# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddDefaultRatingsToUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :processing_rate_triad, :integer, :default => 5
    change_column :users, :processing_rate_others, :integer, :default => 8
  end

  def self.down
    change_column :users, :processing_rate_triad, :integer
    change_column :users, :processing_rate_others, :integer
  end
end
