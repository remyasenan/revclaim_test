class CreateTeamLeaderQueue < ActiveRecord::Migration
  def self.up
    create_table :team_leader_queues do |t|
      t.column :tlusername, :string
      t.column :payer_group_id, :integer
      t.column :workstatus, :integer
      t.column :job_allocated_time, :timestamp
    end
  end

  def self.down
    drop_table :team_leader_queues
  end
end
