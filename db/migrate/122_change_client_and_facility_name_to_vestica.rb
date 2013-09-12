class ChangeClientAndFacilityNameToVestica < ActiveRecord::Migration
  def self.up
    ans = Client.find_by_name("ANS")
    ans.name = "Vestica"
    ans.update
    facility_ans = Facility.find_by_name("ANS")
    facility_ans.name = "Vestica"
    facility_ans.update
    Client.create(:name => "ANS", :tat => 48)
  end

  def self.down
    ans = Client.find_by_name("Vestica")
    ans.name = "ANS" 
    ans.update
    facility_ans = Facility.find_by_name("Vestica")
    facility_ans.name = "ANS"
    facility_ans.update
  end
end
