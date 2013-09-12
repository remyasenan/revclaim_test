class AddPayeridFacilityidUseridToHlscdocuments < ActiveRecord::Migration
  def self.up
    add_column:hlsc_documents,:payer_id,:integer
    add_foreign_key(:hlsc_documents, :payer_id, :payers,:id ,:name =>:fk_hlsc_payer_id)
    add_column:hlsc_documents,:facility_id,:integer
    add_foreign_key(:hlsc_documents, :facility_id, :facilities,:id,:name =>:fk_hlsc_facility_id )
    add_column :hlsc_documents,:user_id,:integer
    add_foreign_key(:hlsc_documents, :user_id, :users,:id,:name =>:fk_hlsc_user_id )
  end

  def self.down
    remove_foreign_key(:hlsc_documents, :fk_hlsc_payer_id)
    remove_column:hlsc_documents,:payer_id
    remove_foreign_key (:hlsc_documents,:fk_hlsc_facility_id) 
    remove_column:hlsc_documents,:facility_id
    remove_foreign_key (:hlsc_documents,:fk_hlsc_user_id)
    remove_column:hlsc_documents,:user_id
  end
end
