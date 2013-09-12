class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
       t.column :state_name, :string,:limit=>50
       t.column :state_code, :string,:limit=>3
    end
  end

  def self.down
    drop_table :states
  end
end
