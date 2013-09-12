class AddRejectedCommentsOnJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :rejected_comment, :string
    add_column :jobs, :qa_comment, :string
  end

  def self.down
    remove_column :jobs, :rejected_comment
    remove_column :jobs, :qa_comment
    
  end
end
