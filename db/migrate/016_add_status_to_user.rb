# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddStatusToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :string, :default => 'Offline'
  end

  def self.down
    remove_column :users, :status
  end
end
