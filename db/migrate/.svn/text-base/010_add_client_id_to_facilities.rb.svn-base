# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddClientIdToFacilities < ActiveRecord::Migration
  def self.up
    add_column "facilities", "client_id", :integer 
    add_foreign_key(:facilities, :client_id, :clients, :id ,:name => :fk_client_id)
  end

  def self.down
     remove_foreign_key :facilities, :fk_client_id
    remove_column "facilities", "client_id"
  end
end
