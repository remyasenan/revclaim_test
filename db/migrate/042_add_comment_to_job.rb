# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddCommentToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :comment, :string
  end

  def self.down
    remove_column :jobs, :comment
  end
end
