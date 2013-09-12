class CreateDefaultUser < ActiveRecord::Migration
  def self.up
    User.create!(:name => 'Default Supervisor', :userid => 'super', :password => 'super', :role => 'Supervisor')
    User.create!(:name => 'Default Administrator', :userid => 'admin', :password => 'admin', :role => 'Admin')
    User.create!(:name => 'Default Processor', :userid => 'proc', :password => 'proc', :role => 'Processor')
    User.create!(:name => 'Default QA', :userid => 'qa', :password => 'qa', :role => 'QA')
    User.create!(:name => 'Default HLSC', :userid => 'hlsc', :password => 'hlsc', :role => 'HLSC')
  end

  def self.down
    # Don't think there is an automated down that would be terribly helpful.
    # User.delete_all
  end
end
