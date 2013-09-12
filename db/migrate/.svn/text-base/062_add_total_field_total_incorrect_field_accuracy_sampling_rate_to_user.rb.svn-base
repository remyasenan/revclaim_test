# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddTotalFieldTotalIncorrectFieldAccuracySamplingRateToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :total_fields, :integer, :default => 0
    add_column :users, :total_incorrect_fields, :integer, :default => 0
    add_column :users, :accuracy, :integer, :default => 100
    add_column :users, :eob_qa_checked, :integer, :default => 0
  end

  def self.down
    remove_column :users, :total_fields
    remove_column :users, :total_incorrect_fields
    remove_column :users, :accuracy
    remove_column :users, :eob_qa_checked
  end
end
