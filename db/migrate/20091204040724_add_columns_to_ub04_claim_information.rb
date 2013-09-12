class AddColumnsToUb04ClaimInformation < ActiveRecord::Migration
  def self.up
    add_column :ub04_claim_informations, :billing_provider_telephone2, :string, :limit => 20
    add_column :ub04_claim_informations, :patient_middle_initial, :string, :limit => 5
    add_column :ub04_claim_informations, :subscriber_middle_initial, :string, :limit => 5
    add_column :ub04_claim_informations, :unlabel_7_1, :string , :limit =>10
    add_column :ub04_claim_informations, :unlabel_7_2, :string , :limit =>10
    add_column :ub04_claim_informations, :unlabel_30_1, :string , :limit =>15
    add_column :ub04_claim_informations, :unlabel_30_2, :string , :limit =>15
    add_column :ub04_claim_informations, :unlabel_37_1, :string , :limit =>10
    add_column :ub04_claim_informations, :unlabel_37_2, :string , :limit =>10
    add_column :ub04_claim_informations, :unlabel_42_23,:string , :limit =>5
    add_column :ub04_serviceline_informations, :unlabel_49,:string , :limit =>5
    add_column :ub04_claim_informations, :unlabel_68_1, :string , :limit =>10
    add_column :ub04_claim_informations, :unlabel_68_2, :string , :limit =>10
    add_column :ub04_claim_informations, :unlabel_73, :string , :limit =>10
    add_column :ub04_claim_informations, :unlabel_75_1, :string , :limit =>5
    add_column :ub04_claim_informations, :unlabel_75_2, :string , :limit =>5
    add_column :ub04_claim_informations, :unlabel_75_3, :string , :limit =>5
    add_column :ub04_claim_informations, :unlabel_75_4, :string , :limit =>5
    add_column :ub04payers,:insured_middle_initial , :string , :limit =>5

  end

  def self.down
    remove_column :ub04_claim_informations, :billing_provider_telephone2
    remove_column :ub04_claim_informations, :patient_middle_initial
    remove_column :ub04_claim_informations, :subscriber_middle_initial
    remove_column :ub04_claim_informations, :unlabel_7_1
    remove_column :ub04_claim_informations, :unlabel_7_2
    remove_column :ub04_claim_informations, :unlabel_30_1
    remove_column :ub04_claim_informations, :unlabel_30_2
    remove_column :ub04_claim_informations, :unlabel_37_1
    remove_column :ub04_claim_informations, :unlabel_37_2
    remove_column :ub04_claim_informations, :unlabel_42_23
    remove_column :ub04_serviceline_informations, :unlabel_49
    remove_column :ub04_claim_informations, :unlabel_68_1
    remove_column :ub04_claim_informations, :unlabel_68_2
    remove_column :ub04_claim_informations, :unlabel_73
    remove_column :ub04_claim_informations, :unlabel_75_1
    remove_column :ub04_claim_informations, :unlabel_75_2
    remove_column :ub04_claim_informations, :unlabel_75_3
    remove_column :ub04_claim_informations, :unlabel_75_4
    remove_column :ub04payers,:insured_middle_initial 

  end
end


