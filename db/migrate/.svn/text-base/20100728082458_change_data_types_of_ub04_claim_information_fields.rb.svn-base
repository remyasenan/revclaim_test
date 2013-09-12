class ChangeDataTypesOfUb04ClaimInformationFields < ActiveRecord::Migration
  def self.up
    change_column :ub04_claim_informations, :principal_proc_code,:string
    change_column :ub04_claim_informations, :other_proc_code1,:string
    change_column :ub04_claim_informations, :other_proc_code2,:string
    change_column :ub04_claim_informations, :other_proc_code3,:string
    change_column :ub04_claim_informations, :other_proc_code4,:string
    change_column :ub04_claim_informations, :other_proc_code5,:string
  end

  def self.down
    change_column :ub04_claim_informations, :principal_proc_code,:integer
    change_column :ub04_claim_informations, :other_proc_code1,:integer
    change_column :ub04_claim_informations, :other_proc_code2,:integer
    change_column :ub04_claim_informations, :other_proc_code3,:integer
    change_column :ub04_claim_informations, :other_proc_code4,:integer
    change_column :ub04_claim_informations, :other_proc_code5,:integer
  end
end
