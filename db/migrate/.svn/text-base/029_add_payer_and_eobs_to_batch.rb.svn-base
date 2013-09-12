# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddPayerAndEobsToBatch < ActiveRecord::Migration
  def self.up
    add_column :batches, :payer_id, :integer
    
    remove_column :batches, :check_volume
  end

  def self.down
    
    remove_column :batches, :payer_id
    add_column :batches, :check_volume, :integer
  end
end
