# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddPayableToBatch < ActiveRecord::Migration
  def self.up
    add_column :batches, :correspondence, :integer, :default => 0
  end
  def self.down
    remove_column :batches, :correspondence
  end
end
