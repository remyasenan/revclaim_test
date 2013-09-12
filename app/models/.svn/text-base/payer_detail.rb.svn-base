class PayerDetail < ActiveRecord::Base
  
  def self.payer_details(payer_id)
    payer_details = {}
    payer = PayerDetail.find_by_id(payer_id)
    payer_details["payer_name"] = payer.payer_name
    payer_details["payer_address_one"] = payer.payer_address1
    payer_details["payer_address_two"] = payer.payer_address2
    payer_details["payer_city"] = payer.payer_city
    payer_details["payer_state"] = payer.payer_state
    payer_details["payer_zipcode"] = payer.payer_zipcode
    return payer_details.to_json
  end
end
