# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddEobAccuracyAttributes < ActiveRecord::Migration
  def self.up
    add_column :users, :total_eobs, :integer, :default => 0
    add_column :users, :rejected_eobs, :integer, :default => 0
    add_column :users, :eob_accuracy, :float, :default => 100
    rename_column :users, :accuracy, :field_accuracy
    change_column :users, :field_accuracy, :float, :default => 100
  end

  def self.down
    remove_column :users, :total_eobs
    remove_column :users, :rejected_eobs
    remove_column :users, :eob_accuracy
    rename_column :users, :field_accuracy, :accuracy
    change_column :users, :accuracy, :integer, :default => nil
  end
end
