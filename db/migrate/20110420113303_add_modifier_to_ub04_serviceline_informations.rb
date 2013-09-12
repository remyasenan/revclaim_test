class AddModifierToUb04ServicelineInformations < ActiveRecord::Migration
  def self.up
    add_column :ub04_serviceline_informations, :modifier, :string
  end

  def self.down
    remove_column :ub04_serviceline_informations, :modifier
  end
end
