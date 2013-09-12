# == Schema Information
# Schema version: 69
#
# Table name: clients
#
#  id             :integer(11)   not null, primary key
#  name           :string(255)   
#  tat            :integer(11)   
#  contracted_tat :integer(11)   default(20)
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Client < ActiveRecord::Base
  has_many :facilities, :dependent => :destroy
  has_many :certifications
  has_many :users, :through => :certifications
  has_many :user_client_job_histories
  has_many :users, :through => :user_client_job_histories
  has_many :documents
  validates_presence_of :name
  validates_presence_of :tat
  validates_uniqueness_of :name

  def to_s
    self.name
  end
end
