# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateCertifications < ActiveRecord::Migration
  def self.up
    create_table :certifications do |t|
      t.column :user_id, :integer
      t.foreign_key :user_id,:users,:id
      t.column :client_id, :integer
      t.foreign_key :client_id,:clients,:id
      t.column :date, :date
    end
  end

  def self.down
    drop_table :certifications
  end
end
