# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddDefaultContractedTat < ActiveRecord::Migration
  def self.up
    change_column :clients, :contracted_tat, :integer, :default => 20
  end

  def self.down
    change_column :clients, :contracted_tat, :integer
  end
end
