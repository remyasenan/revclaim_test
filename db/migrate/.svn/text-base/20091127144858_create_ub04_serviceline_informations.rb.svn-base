class CreateUb04ServicelineInformations < ActiveRecord::Migration
  def self.up
    create_table :ub04_serviceline_informations do |t|

      t.column :ub04_claim_information_id, :integer
      t.foreign_key :ub04_claim_information_id, :ub04_claim_informations, :id
      t.column :rev_code, :integer
      t.column :description, :string
      t.column :hcpcs,  :string
      t.column :rates,  :integer
      t.column :hipps_codes,  :string
      t.column :service_date,  :datetime
      t.column :creation_date,  :datetime
      t.column :service_units,  :integer
      t.column :charges, :decimal, :precision => 8, :scale => 2
      t.column :non_covered_charges,:decimal, :precision => 8, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :ub04_serviceline_informations
  end
end
