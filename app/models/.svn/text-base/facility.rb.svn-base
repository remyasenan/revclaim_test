# == Schema Information
# Schema version: 69
#
# Table name: facilities
#
#  id        :integer(11)   not null, primary key
#  name      :string(255)   
#  client_id :integer(11)   
#  sitecode  :string(255)   
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class Facility < ActiveRecord::Base
  belongs_to :client
  has_many :batches, :dependent => :destroy
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :sitecode
  validates_presence_of :client
  validates_uniqueness_of :sitecode
  validates :internal_tat, :numericality => true,  :length => { :maximum => 2 }
  
  def to_s
    self.name
  end
end
