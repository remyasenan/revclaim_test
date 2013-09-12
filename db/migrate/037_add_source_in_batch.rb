# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddSourceInBatch < ActiveRecord::Migration
  def self.up
    add_column :batches, :source, :string, :default => 'Manual'
  end

  def self.down
    remove_column :batches, :source
  end
end
