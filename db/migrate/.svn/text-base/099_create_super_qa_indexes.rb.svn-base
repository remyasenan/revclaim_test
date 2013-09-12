class CreateSuperQaIndexes < ActiveRecord::Migration
  def self.up
    add_index :eob_sqas, :job_id
    add_index :eob_sqas, :processor_id
    add_index :eob_sqas, :qa_id
    add_index :eob_sqas, :sqa_id
    add_index :eob_sqas, :error_id
    add_index :jobs, :work_queue
    add_index :jobs, :sqa_id
    add_index :jobs, :sqa_status
  end

  def self.down
    remove_index :eob_sqas, :job_id
    remove_index :eob_sqas, :processor_id
    remove_index :eob_sqas, :qa_id
    remove_index :eob_sqas, :sqa_id
    remove_index :eob_sqas, :error_id
    remove_index :jobs, :work_queue
    remove_index :jobs, :sqa_id
    remove_index :jobs, :sqa_status
  end
end

