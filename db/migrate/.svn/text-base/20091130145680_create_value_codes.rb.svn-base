class CreateValueCodes < ActiveRecord::Migration
  def self.up
    create_table :value_codes do |t|

      t.column :ub04_claim_information_id, :integer
      t.foreign_key :ub04_claim_information_id, :ub04_claim_informations, :id
      t.column :code1, :string
      t.column :code2, :string
      t.column :code3, :string
      t.column :amount1, :decimal, :precision => 8, :scale => 2
      t.column :amount2,  :decimal, :precision => 8, :scale => 2
      t.column :amount3,  :decimal, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :value_codes
  end
end
