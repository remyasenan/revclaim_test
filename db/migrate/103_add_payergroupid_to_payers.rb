class AddPayergroupidToPayers < ActiveRecord::Migration
  def self.up
    add_column :payers, :payer_group_id, :integer, :default => 0
    add_column :payers,:cms1500_id ,:integer
    add_column :payers,:zipcode ,:string
    add_column :payers,:state ,:string
    add_column :payers,:city ,:string
    add_column :payers, :details, :text
    #add_foreign_key(:payers, :payer_group_id, :payergroups,:id ,:name => :fk_payer_group_id)
  end

  def self.down
    #remove_foreign_key(:payers,:fk_payer_group_id )
    remove_column :payers, :payer_group_id
    remove_column :payers,:cms1500_id
    remove_column :payers,:zipcode
    remove_column :payers,:state
    remove_column :payers,:city
    remove_column :payers, :details
  end
end
