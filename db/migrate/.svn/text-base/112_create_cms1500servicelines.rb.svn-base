class CreateCms1500servicelines < ActiveRecord::Migration
  def self.up
    create_table :cms1500servicelines do |t|
       t.column :cms1500_id, :integer,:references=>:cms1500s
      t.foreign_key :cms1500_id,:cms1500s,:id
      t.column :service_from_date, :date
      t.column :service_to_date, :date
      t.column :service_place, :string,:limit =>2
      t.column :emg, :string,:limit =>2
      t.column :cpt_hcpcts, :string,:limit =>6
      t.column :modifier1, :string,:limit =>2
      t.column :modifier2, :string,:limit =>2
      t.column :modifier3, :string,:limit =>2
      t.column :modifier4, :string,:limit =>2
      t.column :diagnosis_pointer, :integer,:limit =>4
      t.column :charges, :decimal,:precision => 10, :scale => 2
      t.column :days_units, :decimal,:precision => 10, :scale => 2
      t.column :epsdt, :string,:limit =>2
      t.column :family_plan, :string,:limit =>5
      t.column :qual_id, :string,:limit =>5
      t.column :rendering_provider_id,:string,:limit =>11
      t.column :rendering_provider_qualifier_npi_id, :integer 
    end
  end

  def self.down
    drop_table :cms1500servicelines
  end
end
