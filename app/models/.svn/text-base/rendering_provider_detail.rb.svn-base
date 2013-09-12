class RenderingProviderDetail < ActiveRecord::Base
  def self.provider_details(provider_id)
    provider_details = {}
    provider = RenderingProviderDetail.find_by_id(provider_id)
    provider_details["rendering_provider_last_name"] = provider.rendering_provider_last_name
    provider_details["rendering_provider_address1"] = provider.rendering_provider_address1
    provider_details["rendering_provider_city"] = provider.rendering_provider_city
    provider_details["rendering_provider_state"] = provider.rendering_provider_state
    provider_details["rendering_provider_zipcode"] = provider.rendering_provider_zipcode
    return provider_details.to_json
  end
end
