class AddAllocationStatusToRemittor < ActiveRecord::Migration
  def self.up
    add_column :remittors, :allocation_status,  :boolean,   :default => 1    
  end

  def self.down
    remove_column :remittors, :allocation_status,  :boolean
  end
end
