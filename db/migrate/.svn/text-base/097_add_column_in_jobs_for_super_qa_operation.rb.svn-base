class AddColumnInJobsForSuperQaOperation < ActiveRecord::Migration
  def self.up    
    # add_column :jobs, :work_queue, :boolean, :default => false
    # add_column :jobs, :work_queue_flagtime, :datetime
    # add_column :jobs, :sqa_id, :integer, :default => 0
    # add_column :jobs, :sqa_status, :string, :default => 'New'    
    execute "alter table jobs add column work_queue boolean default false, add column work_queue_flagtime datetime, add column sqa_id integer default 0, add column sqa_status varchar(255) default 'New'"
  end

  def self.down
    # remove_column :jobs, :work_queue
    # remove_column :jobs, :work_queue_flagtime
    # remove_column :jobs, :sqa_id
    # remove_column :jobs, :sqa_status 
    execute "alter table jobs drop column work_queue, drop column work_queue_flagtime, drop column sqa_id, drop column sqa_status"
  end
end
