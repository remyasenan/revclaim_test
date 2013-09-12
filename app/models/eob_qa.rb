# == Schema Information
# Schema version: 69
#
# Table name: eob_qas
#
#  id                     :integer(11)   not null, primary key
#  processor_id           :integer(11)
#  qa_id                  :integer(11)
#  job_id                 :integer(11)
#  time_of_rejection      :datetime
#  account_number         :string(255)
#  total_fields           :integer(11)
#  total_incorrect_fields :integer(11)
#  status                 :string(255)
#  total_qa_checked       :integer(11)
#  comment                :string(255)
#

# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class EobQa < ActiveRecord::Base
#  validates_presence_of :payer, :account_number, :total_fields, :total_incorrect_fields, :message => " is required."
#  validates_numericality_of :total_fields, :total_incorrect_fields, :message => " is not a number"
  belongs_to :job, :class_name => "Remittor", :foreign_key => :processor_id
  belongs_to :job, :class_name => "Remittor", :foreign_key => :qa_id
  belongs_to :job
  belongs_to :eob_error

  def validate
    #errors.add("'Total incorrect fields' count greater than 'Total fields' count\n") if self.total_incorrect_fields > self.total_fields
  end
  protected :validate
end
