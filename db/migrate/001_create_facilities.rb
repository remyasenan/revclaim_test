# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateFacilities < ActiveRecord::Migration
  def self.up
    create_table :facilities do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :facilities
  end
end
