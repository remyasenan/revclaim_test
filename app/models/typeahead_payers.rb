class TypeaheadPayers < ActiveRecord::Base

  def popup
    "#{payer.to_s} + #{pay_address_one} + #{pay_address_two} + #{id} + #{state} + #{city} + #{zipcode.to_s}"
  end

end
