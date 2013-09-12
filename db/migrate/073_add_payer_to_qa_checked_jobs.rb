# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddPayerToQaCheckedJobs < ActiveRecord::Migration
  def self.up
    add_column :eob_reports, :payer_id, :integer
    add_foreign_key(:eob_reports, :payer_id, :payers, :id,:name => :fk_eob_report_payer_id )
  end
  def self.down
    remove_foreign_key(:eob_reports, :fk_eob_report_payer_id )   
    remove_column :eob_reports, :payer_id
  end
end
