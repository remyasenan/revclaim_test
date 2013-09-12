# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class BatchStatusDefaultValue < ActiveRecord::Migration
  def self.up
    change_column "batches", "status", :string, :default => 'New'
  end

  def self.down
    # TODO: Figure out how to do this in a database independent fashion
    execute 'alter table batches alter status drop default'
  end
end
