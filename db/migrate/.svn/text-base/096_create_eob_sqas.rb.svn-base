class CreateEobSqas < ActiveRecord::Migration
  def self.up
    create_table :eob_sqas do |t|
      t.column :job_id, :integer 
      t.column :processor_id, :integer
      t.column :qa_id, :integer
      t.column :sqa_id, :integer
      t.column :sqa_flag_time, :datetime
      t.column :total_fields, :integer
      t.column :total_incorrect_fields, :integer
      t.column :error_id, :integer
      t.column :comments, :string
    end
  end

  def self.down
    drop_table :eob_sqas
  end
end
