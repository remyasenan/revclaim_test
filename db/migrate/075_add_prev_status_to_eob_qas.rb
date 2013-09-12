# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddPrevStatusToEobQas < ActiveRecord::Migration
  def self.up
    add_column :eob_qas, :prev_status, :string
  end

  def self.down
    remove_column :eob_qas, :prev_status
  end
end
