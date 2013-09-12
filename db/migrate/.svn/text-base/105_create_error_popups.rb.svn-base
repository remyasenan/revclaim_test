class CreateErrorPopups < ActiveRecord::Migration
  def self.up
    create_table :error_popups do |t|
      t.column :comment, :string
      t.column :payer_id, :string
      t.column :facility_id, :integer
      t.foreign_key :facility_id,:facilities,:id
      t.column :start_datetime, :date
      t.column :end_datetime, :date
    end
  end

  def self.down
    drop_table :error_popups
  end
end
