# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddHlscIdToBatches < ActiveRecord::Migration
  def self.up
    add_column :batches, :hlsc_id, :integer
    
  end

  def self.down
    
    remove_column :batches, :hlsc_id
  end
end
