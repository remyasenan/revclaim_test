class AddTimeTakenToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs,:time_taken,:integer 
  end

  def self.down
    remove_column :jobs,:time_taken,:integer 
  end
end
