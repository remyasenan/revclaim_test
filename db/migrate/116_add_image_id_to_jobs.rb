class AddImageIdToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs,:images_for_job_id,:integer
    add_foreign_key (:jobs,:images_for_job_id,:images_for_jobs,:id,:name=>:fk_images_for_job_id)
  end

  def self.down
    remove_foreign_key(:jobs,:fk_images_for_job_id)
    remove_column :jobs,:images_for_job_id
  end
end
