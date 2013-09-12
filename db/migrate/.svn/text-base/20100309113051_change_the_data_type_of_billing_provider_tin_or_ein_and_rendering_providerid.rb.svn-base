class ChangeTheDataTypeOfBillingProviderTinOrEinAndRenderingProviderid < ActiveRecord::Migration
   def self.up
    change_column :ub04_claim_informations, :rendering_providerid,:string
    change_column :ub04_claim_informations, :billing_provider_tin_or_ein,:string
   end

   def self.down
    change_column :ub04_claim_informations, :rendering_providerid,:integer
    change_column :ub04_claim_informations, :billing_provider_tin_or_ein,:integer
   end
end
