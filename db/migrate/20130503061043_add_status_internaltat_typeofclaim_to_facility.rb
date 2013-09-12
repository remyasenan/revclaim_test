class AddStatusInternaltatTypeofclaimToFacility < ActiveRecord::Migration
  def change
	add_column :facilities, "status", :string, :default => 'ACTIVATE'
	add_column :facilities, "internal_tat", :string
	add_column :facilities, "type_of_claim", :string
  end
end
