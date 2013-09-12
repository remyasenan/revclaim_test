class TypeaheadBillingProviders < ActiveRecord::Base

  def popup
    "#{billing_provider_last_name.to_s} + #{billing_provider_first_name} + #{billing_provider_address} + #{id} + #{billing_provider_city} + #{billing_provider_state} + #{billing_provider_zipcode.to_s}"
  end

  def popup_billing_provider_name
    "#{billing_provider_name.to_s} + #{billing_provider_address} + #{id} + #{billing_provider_city} + #{billing_provider_state} + #{billing_provider_zipcode.to_s}"
  end

end
