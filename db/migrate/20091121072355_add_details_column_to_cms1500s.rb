class AddDetailsColumnToCms1500s < ActiveRecord::Migration
  def self.up
    add_column :cms1500s, :details, :text
  end

  def self.down
    remove_column :cms1500s, :details
  end
end
