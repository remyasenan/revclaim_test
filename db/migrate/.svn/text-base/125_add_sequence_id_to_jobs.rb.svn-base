class AddSequenceIdToJobs < ActiveRecord::Migration
  def self.up
     add_column :jobs,:sequence_id,:integer,:default => 0  
  end

  def self.down
     remove_column :jobs,:sequence_id,:integer
  end
end
