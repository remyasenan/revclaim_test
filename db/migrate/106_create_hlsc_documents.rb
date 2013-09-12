class CreateHlscDocuments < ActiveRecord::Migration
  def self.up
    create_table :hlsc_documents do |t|
      t.column :file_name, :string
      t.column :file_location, :string
      t.column :file_comments, :string
      t.column :file_created_time, :datetime
    end
  end

  def self.down
    drop_table :hlsc_documents
  end
end
