# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddTeamleaderToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :teamleader_id, :integer
  end

  def self.down
    remove_column :users, :teamleader_id
  end
end
