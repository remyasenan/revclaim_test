function resetTextfieldSize(id,actualwidth){
       $(id).size = actualwidth
}

function enlargeTextfieldSize(id,actualsize){
   var text_length = $(id).value.length
   if (text_length >= actualsize){
      $(id).size = ($(id).value.length) + 4
   }
}
function payerInformations(){
    var url = 'payer_informations';
    var parameters = 'payer=' + $('payer_name').value;
    $('payer_name').value = $('payer_name').value.split('+')[0].strip()
    var payerAjax = new Ajax.Request(url,{
        method: 'get',
        parameters: parameters,
        onComplete: function(payer){

            var payerInformations = eval("(" + payer.responseText + ")");
            if(payerInformations){
                if(payerInformations.payer_address_one != null)
                    $("pay_add_one").value = payerInformations.payer_address_one
                else
                    $("pay_add_one").value = ""
                if(payerInformations.payer_address_two != null)
                    $("pay_add_two").value = payerInformations.payer_address_two
                else
                    $("pay_add_two").value = ""
                if(payerInformations.payer_state != null)
                    $("payer_state").value = payerInformations.payer_state
                else
                    $("payer_state").value = ""
                if(payerInformations.payer_city != null)
                    $("payer_city").value = payerInformations.payer_city
                else
                    $("payer_city").value = ""
                if(payerInformations.payer_zip != null)
                    $("payer_zipcode").value = payerInformations.payer_zip
                else
                    $("payer_zipcode").value = ""
                }
        }
    });
}



function providerInformations(){
    var url = 'provider_informations';
    var parameters = 'provider=' + $('cms1500_billing_provider_last_name').value;
    $('cms1500_billing_provider_last_name').value = $('cms1500_billing_provider_last_name').value.split('+')[0].strip()
    var providerAjax = new Ajax.Request(url,{
        method: 'get',
        parameters: parameters,
        onComplete: function(provider){

            var providerInformations = eval("(" + provider.responseText + ")");
            
            if(providerInformations){
                if(providerInformations.billing_provider_suffix != null)
                    $("cms1500_billing_provider_suffix").value = providerInformations.billing_provider_suffix
                else
                    $("cms1500_billing_provider_suffix").value = ""
                if(providerInformations.billing_provider_first_name != null)
                    $("cms1500_billing_provider_first_name").value = providerInformations.billing_provider_first_name
                else
                    $("cms1500_billing_provider_first_name").value = ""
                if(providerInformations.billing_provider_middle_initial != null)
                    $("cms1500_billing_provider_middle_initial").value = providerInformations.billing_provider_middle_initial
                else
                    $("cms1500_billing_provider_middle_initial").value = ""
                if(providerInformations.billing_provider_address != null)
                    $("cms1500_billing_provider_address").value = providerInformations.billing_provider_address
                else
                    $("cms1500_billing_provider_address").value = ""
                if(providerInformations.billing_provider_city != null)
                    $("cms1500_billing_provider_city").value = providerInformations.billing_provider_city
                else
                    $("cms1500_billing_provider_city").value = ""
                  if(providerInformations.billing_provider_state != null)
                    $("billing_prv_state").value = providerInformations.billing_provider_state
                else
                    $("billing_prv_state").value = ""
                  if(providerInformations.billing_provider_zipcode != null)
                    $("cms1500_billing_provider_zipcode").value = providerInformations.billing_provider_zipcode
                else
                    $("cms1500_billing_provider_zipcode").value = ""
                  if(providerInformations.billing_provider_npi_id != null)
                    {
                        $("bill_a").value = providerInformations.billing_provider_npi_id
                    }
                else{
                    $("bill_a").value = ""
                }
                $("cms1500_billing_provider_name").value = ""
                $("cms1500_billing_provider_phone").value = ""
          }
        }
    });
}


function providerOrganizationInformations(){
    var url = 'provider_organization_informations';
    var parameters = 'provider=' + $('cms1500_billing_provider_name').value;
    $('cms1500_billing_provider_name').value = $('cms1500_billing_provider_name').value.split('+')[0].strip()
    var providerAjax = new Ajax.Request(url,{
        method: 'get',
        parameters: parameters,
        onComplete: function(provider){

            var providerInformations = eval("(" + provider.responseText + ")");

            if(providerInformations){
                    $("cms1500_billing_provider_suffix").value = ""
                    $("cms1500_billing_provider_first_name").value = ""
                    $("cms1500_billing_provider_last_name").value = ""
                    $("cms1500_billing_provider_middle_initial").value = ""
                    $("cms1500_billing_provider_phone").value = ""
                    $("cms1500_billing_provider_address").focus()
                if(providerInformations.billing_provider_address != null)
                    $("cms1500_billing_provider_address").value = providerInformations.billing_provider_address
                else
                    $("cms1500_billing_provider_address").value = ""
                if(providerInformations.billing_provider_city != null)
                    $("cms1500_billing_provider_city").value = providerInformations.billing_provider_city
                else
                    $("cms1500_billing_provider_city").value = ""
                  if(providerInformations.billing_provider_state != null)
                    $("billing_prv_state").value = providerInformations.billing_provider_state
                else
                    $("billing_prv_state").value = ""
                  if(providerInformations.billing_provider_zipcode != null)
                    $("cms1500_billing_provider_zipcode").value = providerInformations.billing_provider_zipcode
                else
                    $("cms1500_billing_provider_zipcode").value = ""
                  if(providerInformations.billing_provider_npi_id != null)
                      $("bill_a").value = providerInformations.billing_provider_npi_id
                  else
                    $("bill_a").value = ""
                
               
          }
        }
    });
}


function servicefacilityInformations(){
    var url = 'service_facility_informations';
    var parameters = 'service_facility=' + $('cms1500_service_facility_name').value;
    $('cms1500_service_facility_name').value = $('cms1500_service_facility_name').value.split('+')[0].strip()
    var esrvicefacilityAjax = new Ajax.Request(url,{
        method: 'get',
        parameters: parameters,
        onComplete: function(s_facility){

            var servicefacilityInformations = eval("(" + s_facility.responseText + ")");

            if(servicefacilityInformations){
                if(servicefacilityInformations.service_facility_address != null)
                    $("cms1500_service_facility_address").value = servicefacilityInformations.service_facility_address
                else
                    $("cms1500_service_facility_address").value = ""
                  if(servicefacilityInformations.service_facility_city != null)
                    $("cms1500_service_facility_city").value = servicefacilityInformations.service_facility_city
                else
                    $("cms1500_service_facility_city").value = ""
                  if(servicefacilityInformations.service_facility_zipcode != null)
                    $("cms1500_service_facility_zipcode").value = servicefacilityInformations.service_facility_zipcode
                else
                    $("cms1500_service_facility_zipcode").value = ""
                  if(servicefacilityInformations.service_facility_npi_id != null)
                    $("cms1500_service_facility_npi_id").value = servicefacilityInformations.service_facility_npi_id
                else
                    $("cms1500_service_facility_npi_id").value = ""
                  if(servicefacilityInformations.service_facility_non_npi_id != null)
                    $("cms1500_service_facility_non_npi_id").value = servicefacilityInformations.service_facility_non_npi_id
                else
                    $("cms1500_service_facility_non_npi_id").value = ""
                  if(servicefacilityInformations.service_facility_state != null)
                    $("service_facility_state").value = servicefacilityInformations.service_facility_state
                else
                    $("service_facility_state").value = ""
                
                }
        }
    });
}

