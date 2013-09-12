class CreateOccurenceSpans < ActiveRecord::Migration
  def self.up
    create_table :occurence_spans do |t|

      t.column :ub04_claim_information_id, :integer
      t.foreign_key :ub04_claim_information_id, :ub04_claim_informations, :id
      t.column :code1, :string
      t.column :code2, :string
      t.column :from_date1, :datetime
      t.column :from_date2, :datetime
      t.column :through_date1, :datetime
      t.column :through_date2, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :occurence_spans
  end
end
