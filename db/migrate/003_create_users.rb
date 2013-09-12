# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :name, :string
      t.column :userid, :string
      t.column :password, :string
      t.column :shift, :string
      t.column :remark, :string
      t.column :role, :string
    end
  end

  def self.down
    drop_table :users
  end
end
