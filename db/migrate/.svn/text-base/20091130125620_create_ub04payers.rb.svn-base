class CreateUb04payers < ActiveRecord::Migration
  def self.up
    create_table :ub04payers do |t|
      
       t.column :ub04_claim_information_id, :integer
       t.foreign_key :ub04_claim_information_id, :ub04_claim_informations, :id
       t.column :name, :string
       t.column :health_planid , :string
       t.column :release_info, :string
       t.column :assign_benefits , :string
       t.column :prior_payments, :string
       t.column :est_amounts , :string
       t.column :insured_first_name , :string
       t.column :insured_last_name , :string
       t.column :patient_relationship ,:string
       t.column :insured_id , :string
       t.column :group_name , :string
       t.column :group_no , :string
       t.column :treatment_authorisation , :string
       t.column :document_control_no , :string
       t.column :employer_name , :string  
       
      t.timestamps
    end
    
  end

  def self.down
    drop_table :ub04payers
    
  end
end
