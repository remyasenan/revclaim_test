class CreateRenderingProviderDetail < ActiveRecord::Migration
  def self.up
    create_table :rendering_provider_details do |t|
      t.column :rendering_provider_first_name,  :string, :limit   => 50
      t.column :rendering_provider_last_name, :string, :limit   => 50
      t.column :rendering_provider_address1,  :string, :limit   => 50
      t.column :rendering_provider_city,  :string, :limit   => 50
      t.column :rendering_provider_state, :string, :limit   => 50
      t.column :rendering_provider_zipcode, :integer
    end
  end

  def self.down
    drop_table :rendering_provider_details
  end
end
