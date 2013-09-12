class AddProcessorCommentsToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs,:processor_comments,:string,:default =>'null'
  end

  def self.down
    remove_column :jobs,:processor_comments
  end
end
