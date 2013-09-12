class BillingProviderDetail < ActiveRecord::Base

  def self.billing_provider_details(provider_id)

    provider_details = {}
    provider = BillingProviderDetail.find_by_id(provider_id)
    provider_details["billing_provider_last_name"] = provider.billing_provider_last_name
    provider_details["billing_provider_address1"] = provider.billing_provider_address1
    provider_details["billing_provider_city"] = provider.billing_provider_city
    provider_details["billing_provider_state"] = provider.billing_provider_state
    provider_details["billing_provider_zipcode"] = provider.billing_provider_zipcode
    provider_details["billing_provider_telephone"] = provider.billing_provider_telephone
    provider_details["billing_provider_tin_or_ein"] = provider.billing_provider_tin_or_ein
    provider_details["billing_provider_npi"] = provider.billing_provider_npi
    return provider_details.to_json
  end
end
