class AddMinutesToCms1500Servicelines < ActiveRecord::Migration
  def self.up
    add_column :cms1500servicelines, :minutes, :string
  end

  def self.down
    remove_column :cms1500servicelines, :minutes, :string
  end
end
