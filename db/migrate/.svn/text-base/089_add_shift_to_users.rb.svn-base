# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddShiftToUsers < ActiveRecord::Migration
  def self.up
    #    add_column :users, :shift_id, :integer
    remove_column :users, :shift
    add_column :users, :shift_id, :integer,:references => :shifts
    add_foreign_key(:users, :shift_id, :shifts,:id ,:name => :fk_shift_id)
    # Need to reset column information because ActiveRecord cached info. 
    # before we made the changes above.
    #    NEED TO UNCOMMENT FOLLOWING LINES
       User.reset_column_information
      User.find(:all).each {|u|
         u.shift = Shift.find(1)
         u.save
       }
  end

  def self.down
    #    remove_column :users, :shift_id
    add_column :users, :shift, :integer
    remove_foreign_key(:users, :fk_shift_id )   
    remove_column :users, :shift_id
   
  end
end
