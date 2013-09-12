# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddFiletypeColumnToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :file_type, :string
  end

  def self.down
    remove_column :documents, :file_type
  end
end
