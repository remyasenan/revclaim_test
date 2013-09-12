# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddPayerToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :payer_id, :integer
    
  end

  def self.down
    
    remove_column :jobs, :payer_id
  end
end