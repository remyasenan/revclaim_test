# == Schema Information
# Schema version: 69
#
# Table name: tats
#
#  id            :integer(11)   not null, primary key
#  expected_time :datetime      
#  comments      :string(255)   
#  batch_id      :integer(11)   
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Tat < ActiveRecord::Base
	belongs_to :batch
	validates_presence_of :batch_id
	#validates_presence_of :expected_time,:batch_id

  def expected_time_for_comparison
    if expected_time.nil?
      return Time.now + 1000.days
    else
      return expected_time
    end
  end
end
