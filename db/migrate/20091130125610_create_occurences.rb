class CreateOccurences < ActiveRecord::Migration
  def self.up
    create_table :occurences do |t|

      t.column :ub04_claim_information_id, :integer
      t.foreign_key :ub04_claim_information_id, :ub04_claim_informations, :id
      t.column :code1, :string
      t.column :code2, :string
      t.column :code3, :string
      t.column :code4, :string
      t.column :date1, :datetime
      t.column :date2, :datetime
      t.column :date3, :datetime
      t.column :date4, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :occurences
  end
end
