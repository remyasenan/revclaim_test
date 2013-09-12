class AddRenderingProviderAddress2ToRenderingProviderDetails < ActiveRecord::Migration
  def self.up
    add_column :rendering_provider_details, :rendering_provider_address2, :string, :limit => 50
  end

  def self.down
    remove_column :rendering_provider_details, :rendering_provider_address2
  end
end
