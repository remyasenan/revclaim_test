# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateDefaultClients < ActiveRecord::Migration
  def self.up
    client_list = [{:name => "Apria", :tat => 12}, {:name => "Liberty", :tat => 12}, {:name => "Partners", :tat => 12}, {:name => "Triad", :tat => 6}, {:name => "Austin", :tat => 12}, {:name => "MSC", :tat => 10}, {:name => "WorkingRX", :tat => 12},{:name => "ANS", :tat => 42 , :contracted_tat => 48}]
    client_list.each do |c|
      client = Client.new(c)
      client.save
    end
  end

  def self.down
    Client.delete_all
  end
end
