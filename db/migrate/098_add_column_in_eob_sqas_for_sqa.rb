class AddColumnInEobSqasForSqa < ActiveRecord::Migration
  def self.up
    add_column :eob_sqas, :total_eobs, :integer, :default => 0
    add_column :eob_sqas, :total_incorrect_eobs, :integer, :default => 0
    add_column :eob_sqas, :eob_comments, :string
  end

  def self.down
    remove_column :eob_sqas, :total_eobs
    remove_column :eob_sqas, :total_incorrect_eobs
    remove_column :eob_sqas, :eob_comments
  end
end
