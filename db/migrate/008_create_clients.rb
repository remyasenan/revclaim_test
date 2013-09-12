# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.column :name, :string
      t.column :tat, :integer
    end
  end

  def self.down
    drop_table :clients
  end
end
