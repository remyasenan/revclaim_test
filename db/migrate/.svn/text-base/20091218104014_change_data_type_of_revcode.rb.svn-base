class ChangeDataTypeOfRevcode < ActiveRecord::Migration
  def self.up
    change_column :ub04_serviceline_informations, :rev_code,  :string,   :limit => 50
  end

  def self.down
    change_column :ub04_serviceline_informations, :rev_code,  :integer
  end
end
