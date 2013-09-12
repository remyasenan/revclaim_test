# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateClientStatusHistories < ActiveRecord::Migration
  def self.up
    create_table :client_status_histories do |t|
      t.column :batch_id, :integer
      t.foreign_key :batch_id,:batches,:id
      t.column :time, :datetime
      t.column :status, :string
      t.column :user, :string
    end
  end

  def self.down
    drop_table :client_status_histories
  end
end
