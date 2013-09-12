# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class ChangeContentFieldSizeForDocuments < ActiveRecord::Migration
  def self.up
    change_column :documents, :content, :binary, :limit => 10.megabyte
  end

  def self.down
    change_column :documents, :content, :binary
  end
end
