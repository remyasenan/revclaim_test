class TypeaheadPayers < ActiveRecord::Migration
  def self.up
     create_table "typeahead_payers", :force => true do |t|
      t.column :payer, :string
      t.column :pay_address_one, :text
      t.column :pay_address_two, :text
      t.column :city, :string
      t.column :state, :string
      t.column :zipcode, :string

    end
  end

  def self.down
    drop_table "typeahead_payers"
  end
end
