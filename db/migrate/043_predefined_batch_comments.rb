# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class PredefinedBatchComments < ActiveRecord::Migration
  def self.up
    comments_list = 
      [
      "Did not change unwanted EOB to OTH",
      "Incorrect default date",
      "Incorrectly indexed partial date",
      "Incorrect retention amount"
    ]

    comments_list.each do |comment|
      batch_comment = BatchRejectionComment.new
      batch_comment.comment = comment
      batch_comment.save
    end
  end

  def self.down
    BatchRejectionComment.delete_all
  end
end
