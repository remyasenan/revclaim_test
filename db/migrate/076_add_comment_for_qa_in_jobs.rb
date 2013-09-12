# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddCommentForQaInJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :comment_for_qa, :string
  end

  def self.down
    remove_column :jobs, :comment_for_qa
  end
end
