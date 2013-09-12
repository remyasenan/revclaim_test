class RemoveTypeofclaimFromFacilityAddToBatches < ActiveRecord::Migration
  def up
	remove_column :facilities, :type_of_claim
	add_column :batches, "type_of_claim", :string
  end

  def down
	add_column :facilities, "type_of_claim", :string
	remove_column :batches, :type_of_claim
  end
end
