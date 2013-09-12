# == Schema Information
# Schema version: 69
#
# Table name: job_statuses
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class JobStatus < ActiveRecord::Base
  #acts_as_enumerated
  
  def to_s
    self.name
  end
end
