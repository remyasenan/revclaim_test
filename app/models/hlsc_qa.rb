# == Schema Information
# Schema version: 69
#
# Table name: hlsc_qas
#
#  id            :integer(11)   not null, primary key
#  batch_id      :integer(11)   
#  user_id       :integer(11)   
#  total_eobs    :integer(11)   
#  rejected_eobs :integer(11)   
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class HlscQa < ActiveRecord::Base
  belongs_to :user
  belongs_to :batch
  #belongs_to :job
end
