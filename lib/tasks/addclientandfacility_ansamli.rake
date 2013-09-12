# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 



namespace :addclientandfacility do
  task :ansamli => :environment do

    @client = Client.new(:name => "ANS", :tat => 42, :contracted_tat => 20)
    @client.save;

    @ans = Client.find_by_name("ANS")

    @facility = Facility.new(:name => "AMLI", :client_id => @ans.id, :sitecode => "AMLI1500")
    @facility.save;

  end
end