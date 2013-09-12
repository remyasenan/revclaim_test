class AlterChargesTypeInUb04 < ActiveRecord::Migration
  def self.up
    change_column(:ub04_claim_informations, :total_charges, :decimal, :precision => 10, :scale => 2)
    change_column(:ub04_claim_informations, :total_non_covered_charges, :decimal, :precision => 10, :scale => 2)
    change_column(:ub04_serviceline_informations, :charges, :decimal, :precision => 10, :scale => 2)
    change_column(:ub04_serviceline_informations, :non_covered_charges, :decimal, :precision => 10, :scale => 2)
    change_column(:value_codes, :amount1, :decimal, :precision => 10, :scale => 2)
    change_column(:value_codes, :amount2, :decimal, :precision => 10, :scale => 2)
    change_column(:value_codes, :amount3, :decimal, :precision => 10, :scale => 2)
   end

  def self.down
    change_column(:ub04_claim_informations, :total_charges, :decimal, :precision => 8, :scale => 2)
    change_column(:ub04_claim_informations, :total_non_covered_charges, :decimal, :precision => 8, :scale => 2)
    change_column(:ub04_serviceline_informations, :charges, :decimal, :precision => 8, :scale => 2)
    change_column(:ub04_serviceline_informations, :non_covered_charges, :decimal, :precision => 8, :scale => 2)
    change_column(:value_codes, :amount1, :decimal, :precision => 8, :scale => 2)
    change_column(:value_codes, :amount2, :decimal, :precision => 8, :scale => 2)
    change_column(:value_codes, :amount3, :decimal, :precision => 8, :scale => 2)
  end
end
