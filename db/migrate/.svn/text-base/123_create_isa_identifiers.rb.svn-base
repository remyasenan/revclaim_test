class CreateIsaIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :isa_identifiers do |t|
      t.column :isa_number, :integer
    end
    IsaIdentifier.create!(:isa_number => 0)
  end

  def self.down
    drop_table :isa_identifiers
  end
end
