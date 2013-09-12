# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateSiteSettings < ActiveRecord::Migration
  def self.up
    create_table :site_settings do |t|
      t.column :show_userid, :boolean, :default => true
      t.column :per_page, :integer, :default => 30
    end
    settings = SiteSetting.create!(:show_userid => 1, :per_page => 30)
  end

  def self.down
    drop_table :site_settings
  end
end
