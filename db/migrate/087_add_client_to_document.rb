# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class AddClientToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :client_id, :integer,:references => :clients
    add_foreign_key(:documents, :client_id, :clients, :id,:name => :fk_document_client_id )
    add_column :documents, :created_at, :datetime
  end

  def self.down
    remove_foreign_key(:documents, :fk_document_client_id)
    remove_column :documents, :client_id
    remove_column :documents, :created_at
  end
end
