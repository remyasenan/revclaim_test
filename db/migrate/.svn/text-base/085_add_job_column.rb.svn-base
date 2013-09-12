# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddJobColumn < ActiveRecord::Migration
  def self.up
    add_column :jobs, :rejections, :integer, :default => 0
  end

  def self.down
    remove_column :jobs, :rejections
  end
end
