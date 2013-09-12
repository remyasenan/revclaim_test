# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddCommentFieldInBatches < ActiveRecord::Migration
  def self.up
    add_column :batches, :comment, :string
  end
  def self.down
    remove_column :batches, :comment
  end
end
