class AddColumnInEobsqasForReports < ActiveRecord::Migration
  def self.up
    add_column :eob_sqas, :accuracy, :float
    add_column :eob_sqas, :field_accuracy, :float
    add_column :eob_sqas, :batch_id  , :integer , :references => :batches
    add_foreign_key(:eob_sqas, :batch_id, :batches,:id,:name => :fk_eob_batch_id )
    add_column :eob_sqas, :batch_date , :datetime
  end

  def self.down
    remove_column :eob_sqas, :accuracy
    remove_column :eob_sqas, :field_accuracy
    remove_foreign_key(:eob_sqas, :fk_eob_batch_id )
    remove_column :eob_sqas, :batch_id 
    remove_column :eob_sqas, :batch_date
  end
end
