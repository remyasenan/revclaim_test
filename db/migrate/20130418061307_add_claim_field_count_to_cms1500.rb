class AddClaimFieldCountToCms1500 < ActiveRecord::Migration
  def change
    add_column "cms1500s", "total_field_count", :integer, :default => 0
  end
end