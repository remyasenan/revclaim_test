# == Schema Information
# Schema version:  
#
# Table name: eob_sqas
#
#  id                     :integer(11)   not null, primary key
#  job_id                 :integer(11)
#  processor_id           :integer(11)
#  qa_id                  :integer(11)
#  sqa_id                 :integer(11)
#  sqa_flag_time          :datetime
#  total_fields           :integer(11)
#  total_incorrect_fields :integer(11)
#  error_id               :integer(11)
#  comment                :string(255)
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class EobSqa < ActiveRecord::Base
  validates_presence_of :total_fields, :total_incorrect_fields, :message => " is required."
  validates_numericality_of :total_fields, :total_incorrect_fields, :message => " is not a number"
  validates_presence_of :total_eobs, :total_incorrect_eobs, :message => " is required."
  validates_numericality_of :total_eobs, :total_incorrect_eobs, :message => " is not a number"
  belongs_to :processor, :class_name => "User", :foreign_key => :processor_id
  belongs_to :qa, :class_name => "User", :foreign_key => :qa_id
  belongs_to :sqa, :class_name => "User", :foreign_key => :sqa_id
  #belongs_to :job
  #belongs_to :eob_error

  def validate
    #errors.add("'Total incorrect fields' count greater than 'Total fields' count\n") if self.total_incorrect_fields > self.total_fields
  end
  protected :validate
end
