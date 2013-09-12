class AddUb04PayerDetails < ActiveRecord::Migration
  def self.up
    PayerDetail.create!(:payer_name => "CINERGY HEALTH INC", :payer_address1 => "1844 N NOB HILL RD 623", :payer_address2 =>"", :payer_city => "PLANTATION", :payer_state =>"FL", :payer_zipcode => "33322")
    PayerDetail.create!(:payer_name => "CROSS AMERICA HEALTH PLAN", :payer_address1 => "1844 N NOB HILL", :payer_address2 =>"SUITE 623", :payer_city => "PLANTATION", :payer_state =>"FL", :payer_zipcode => "33322654")
    PayerDetail.create!(:payer_name => "PREFERRED CARE INC", :payer_address1 => "PO BOX 1235", :payer_address2 =>"", :payer_city => "FREDERICK", :payer_state =>"MD", :payer_zipcode => "21702023")
    PayerDetail.create!(:payer_name => "AMERICAN MEDICAL AND LIFE INS", :payer_address1 => "PO BOX 1353", :payer_address2 =>"", :payer_city => "CHICAGO", :payer_state =>"IL", :payer_zipcode => "21702")
  end

  def self.down
    PayerDetail.find_by_payer_name("CINERGY HEALTH INC").delete
    PayerDetail.find_by_payer_name("CROSS AMERICA HEALTH PLAN").delete
    PayerDetail.find_by_payer_name("PREFERRED CARE INC").delete
    PayerDetail.find_by_payer_name("AMERICAN MEDICAL AND LIFE INS").delete
  end
end


