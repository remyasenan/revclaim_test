class AddFileIdInErrorPopups < ActiveRecord::Migration
  def self.up
    add_column :error_popups,:file_id,:integer 
  end

  def self.down
    remove_column :error_popups,:file_id
  end
end
