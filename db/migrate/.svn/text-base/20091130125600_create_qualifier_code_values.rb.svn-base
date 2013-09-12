class CreateQualifierCodeValues < ActiveRecord::Migration
  def self.up
    create_table :qualifier_code_values do |t|

      t.column :ub04_claim_information_id, :integer
      t.foreign_key :ub04_claim_information_id, :ub04_claim_informations, :id
      t.column :qualifier, :string
      t.column :code, :string
      t.column :value, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :qualifier_code_values
  end
end
