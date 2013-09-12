# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateTat < ActiveRecord::Migration
  def self.up
    create_table :tats do |t|
      t.column :expected_time, :datetime
      t.column :comments, :string
      t.column :batch_id, :integer
      t.foreign_key :batch_id,:batches,:id
    end
  end

  def self.down
    drop_table :tats
  end
end
