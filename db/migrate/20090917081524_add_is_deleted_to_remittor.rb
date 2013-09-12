class AddIsDeletedToRemittor < ActiveRecord::Migration
  def self.up
    add_column :remittors, :is_deleted, :integer
    add_column :remittors, :remark, :string
    add_column :remittors, :rating, :string
    add_column :remittors, :processing_rate_others, :integer
    add_column :remittors, :processing_rate_triad, :integer
    add_column :remittors,:total_fields, :integer
    add_column :remittors, :total_incorrect_fields, :integer
    add_column :remittors, :field_accuracy, :float
    add_column :remittors, :eob_qa_checked, :integer
    add_column :remittors, :total_eobs, :integer
    add_column :remittors, :rejected_eobs, :integer
    add_column :remittors, :eob_accuracy, :float
    add_column :remittors, :shift_id, :integer
  end

  def self.down
    remove_column :remittors, :is_deleted, :integer
    remove_column :remittors, :remark, :string
    remove_column :remittors, :rating, :string
    remove_column :remittors, :processing_rate_others, :integer
    remove_column :remittors, :processing_rate_triad, :integer
    remove_column :remittors,:total_fields, :integer
    remove_column:remittors, :total_incorrect_fields, :integer
    remove_column :remittors, :field_accuracy, :float
    remove_column :remittors, :eob_qa_checked, :integer
    remove_column :remittors, :total_eobs, :integer
    remove_column :remittors, :rejected_eobs, :integer
    remove_column :remittors, :eob_accuracy, :float
    remove_column:remittors, :shift_id, :integer
  end
end
