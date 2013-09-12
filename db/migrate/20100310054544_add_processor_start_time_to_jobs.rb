class AddProcessorStartTimeToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :processor_start_time,  :datetime
  end

  def self.down
    remove_column :jobs, :processor_start_time
  end
end
