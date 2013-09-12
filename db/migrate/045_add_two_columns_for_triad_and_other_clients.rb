# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddTwoColumnsForTriadAndOtherClients < ActiveRecord::Migration
  def self.up
    add_column :users, :processing_rate_triad, :integer
    add_column :users, :processing_rate_others, :integer
  end

  def self.down
    remove_column :users, :processing_rate_triad
    remove_column :users, :processing_rate_others
  end
end
