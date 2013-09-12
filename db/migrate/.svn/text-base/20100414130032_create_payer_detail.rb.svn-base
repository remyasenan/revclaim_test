class CreatePayerDetail < ActiveRecord::Migration
  def self.up
    create_table :payer_details do |t|
      t.column :payer_name,  :string, :limit   => 50
      t.column :payer_address1,  :string, :limit   => 50
      t.column :payer_address2,  :string, :limit   => 50
      t.column :payer_city,  :string, :limit   => 50
      t.column :payer_state, :string, :limit   => 50
      t.column :payer_zipcode, :integer
  end
  end
  def self.down
    drop_table :payer_details
  end
end
