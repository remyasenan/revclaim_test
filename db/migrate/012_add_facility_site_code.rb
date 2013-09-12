# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddFacilitySiteCode < ActiveRecord::Migration
  def self.up
    add_column :facilities, :sitecode, :string
  end

  def self.down
    remove_column :facilities, :sitecode
  end
end
