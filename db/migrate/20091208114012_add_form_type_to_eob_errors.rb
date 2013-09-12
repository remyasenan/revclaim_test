class AddFormTypeToEobErrors < ActiveRecord::Migration
  def self.up
    add_column :eob_errors, :form_type, :string , :default => "1500"
  end
 
  def self.down
    remove_column :eob_errors,:form_type
  end
end
