# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateShifts < ActiveRecord::Migration
  def self.up
    create_table :shifts do |t|
      t.column :name, :string
      t.column :start_time, :time
      t.column :duration, :float
    end
    shift = {:name => 'General', :start_time => '2000-01-01 00:00:00', :duration => 23}
    new_shift = Shift.new(shift)
    new_shift.save!
    shifts = ['Morning', 'Afternoon', 'Night']
    shifts.each {|s| new_shift = Shift.new(:name => s); new_shift.save!}
  end

  def self.down
    drop_table :shifts
  end
end
