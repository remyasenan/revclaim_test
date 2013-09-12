class HlscDocument < ActiveRecord::Base
  validates_uniqueness_of :file_location
  belongs_to :payer,  :foreign_key => :payer_id
  belongs_to :facility,  :foreign_key => :facility_id
end
