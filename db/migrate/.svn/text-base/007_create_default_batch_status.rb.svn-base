# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateDefaultBatchStatus < ActiveRecord::Migration
  def self.up
    @status = Status.new
    @status.value = 'New'
    @status.save
    @status = Status.new
    @status.value = 'Processing'
    @status.save
    @status = Status.new
    @status.value = 'Completed'
    @status.save
  end

  def self.down
    Status.delete_all
  end
end
