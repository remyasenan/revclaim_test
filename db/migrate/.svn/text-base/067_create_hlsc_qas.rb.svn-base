# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateHlscQas < ActiveRecord::Migration
  def self.up
    create_table :hlsc_qas do |t|
      t.column :batch_id, :integer
      t.foreign_key :batch_id,:batches,:id
      t.column :user_id, :integer
      t.foreign_key :user_id,:users,:id
      t.column :total_eobs, :integer
      t.column :rejected_eobs, :integer
    end
  end

  def self.down
    drop_table :hlsc_qas
  end
end
