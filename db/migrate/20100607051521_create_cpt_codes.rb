class CreateCptCodes < ActiveRecord::Migration
  def self.up
    create_table :cpt_codes do |t|
      t.column :code, :string, :limit => 5, :null => false
      t.column :description, :string, :null => false
      t.timestamps
    end
    add_index :cpt_codes, :code, :unique => true
  end

  def self.down
    remove_index :cpt_codes, :code
    drop_table :cpt_codes
  end
end
