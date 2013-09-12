# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddEobPerHourRateTable < ActiveRecord::Migration
  def self.up
    create_table :eobrates do |t|
      t.column :high, :integer
      t.column :medium, :integer
      t.column :low, :integer
      t.column :client_id, :integer
      t.foreign_key :client_id,:clients,:id,:name => :fk_eobrate_client_id
    end 
  end

  def self.down
    drop_table :eobrates	
  end
end
