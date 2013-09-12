class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.column :name, :string
    end
    
    # generate the join table
    create_table "remittors_roles", :id => false do |t|
      t.column "role_id", :integer
      t.column "remittor_id", :integer
    end
    add_index "remittors_roles", "role_id"
    add_index "remittors_roles", "remittor_id"
  end

  def self.down
    drop_table "roles"
    drop_table "remittors_roles"
  end
end