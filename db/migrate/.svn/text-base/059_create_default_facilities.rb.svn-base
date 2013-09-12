# Copyright (c) 2007. RevenueMed, Inc. All rights reserved.

class CreateDefaultFacilities < ActiveRecord::Migration
  def self.up
    apria = Client.find_by_name("Apria")
    liberty = Client.find_by_name("Liberty")
    partners = Client.find_by_name("Partners")
    triad = Client.find_by_name("Triad")
    ans = Client.find_by_name("ANS")
    other = Client.create(:name => "Other", :tat => 12)
    other = Client.find_by_name("Other") # Not sure that this is the best way, but I need to be sure I have id
    Facility.delete_all # Drop any preexisting facility entries
    facility_list = [ \
        {:name => "Carolinas", :sitecode => "00811", :client => apria}, 
      {:name => "Home Medical", :sitecode => "00823", :client => apria}, 
      {:name => "Machesney Park", :sitecode => "00802", :client => apria}, 
      {:name => "Mid-Atlantic Region", :sitecode => "00807", :client => apria}, 
      {:name => "Mid South", :sitecode => "00812", :client => apria}, 
      {:name => "Minster", :sitecode => "00813", :client => apria}, 
      {:name => "Nca Region", :sitecode => "00827", :client => apria}, 
      {:name => "New England", :sitecode => "00805", :client => apria}, 
      {:name => "Plains", :sitecode => "00803", :client => apria}, 
      {:name => "Redmond Hme", :sitecode => "00826", :client => apria}, 
      {:name => "Rockies Region", :sitecode => "00806", :client => apria}, 
      {:name => "Sca Region", :sitecode => "00822", :client => apria}, 
      {:name => "Southern Region", :sitecode => "00800", :client => apria}, 
      {:name => "St Louis Hme", :sitecode => "00818", :client => apria}, 
      {:name => "Swt Region", :sitecode => "00820", :client => apria}, 
      {:name => "Twin States Region", :sitecode => "00808", :client => apria}, 
      {:name => "Upper Midwest Region", :sitecode => "00809", :client => apria}, 
      {:name => "Western Pa Region", :sitecode => "00810", :client => apria}, 
      {:name => "Central Arkansas Hospital", :sitecode => "00956", :client => triad}, 
      {:name => "St Marys Regional Med Ctr", :sitecode => "00959", :client => triad}, 
      {:name => "National Park Medical Ctr", :sitecode => "00957", :client => triad}, 
      {:name => "Liberty Medical", :sitecode => "00890", :client => liberty}, 
      {:name => "Partners - Mass General", :sitecode => "00862", :client => partners}, 
      {:name => "Byram Healthcare", :sitecode => "00896", :client => other}, 
      {:name => "Austin Diagnostic Clinic", :sitecode => "00895", :client => other}, 
      {:name => "PPI Floyd Cardiology", :sitecode => "00A21", :client => other},
      {:name => "ANS", :sitecode => "00ANS21", :client => ans }]
    
    facility_list.each do |f|
      fac = Facility.create(f)
    end
  end

  def self.down
    Facility.delete_all
    other = Client.find_by_name("Other")
    other.destroy
  end
end
