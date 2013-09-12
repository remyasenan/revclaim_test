class AddDefaultState < ActiveRecord::Migration
  def self.up
    State.create(:state_name => "DEFAULF",:state_code =>"XX")
  end

  def self.down
    state = State.find_by_state_code("XX")
    state.destroy if state
  end
end
