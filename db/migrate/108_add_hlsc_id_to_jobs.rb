class AddHlscIdToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :hlsc_id, :integer,:references => :users
   
  end

  def self.down
   
    remove_column :jobs, :hlsc_id
  end
end
