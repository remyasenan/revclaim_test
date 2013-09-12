class AddDetailsColumnToUb04ReleatedTables < ActiveRecord::Migration
  def self.up
     add_column :ub04_claim_informations, :details, :text
     add_column :ub04_serviceline_informations, :details, :text
     add_column :occurences, :details, :text
     add_column :occurence_spans, :details, :text
     add_column :value_codes, :details, :text
     add_column :qualifier_code_values, :details, :text
     add_column :ub04payers, :details, :text    
  end

  def self.down
    remove_column :ub04_claim_informations, :details
    remove_column :ub04_serviceline_informations, :details
    remove_column :occurencess, :details
    remove_column :occurence_spans, :details
    remove_column :value_codes, :details
    remove_column :qualifier_code_valuess, :details
    remove_column :ub04payers, :details
  end
end
