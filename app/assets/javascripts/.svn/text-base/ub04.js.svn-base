var c = 0;
var alphanumeric = /^[a-zA-Z0-9 ]+$/
var npi_number = /^[0-9]{10}$/
var decimalamount = /^[0-9]{1,8}[.]{0,1}[0-9]{0,2}$/
var mmddyy = /^(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])([0-9]{2})$/
var mmddyyyy = /^(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])((19|20)[0-9][0-9])$/
var revenue_code = /^[0-9]{4}$/
var hcpcs_code = /^[a-zA-Z0-9]{5}$/
var alphabet = /^[a-zA-Z]+$/
var regexp = /(^\d{5}$)|(^\d{9}$)/
var federal_tax_id = /^[0-9]+$/
// /^[0-9\-]+$/
var pay_to_provider_id = /^[0-9a-zA-Z\-]+$/
var today = new Date()
var lastyear = parseInt((today.getYear()) - 2)
var issplchr = /[!@#$%^&*()_+"':;`~=?<\\|]+/
var modifierregexp = /^\w{2}$/
var count = 0;
var count1 = 4000;
var newcount = 0
var newcount1 = 0
var sum = 0
var rowcount = 0;
var now = new Date();
var submitted = false

var dragobject = {
    z: 0,
    x: 0,
    y: 0,
    offsetx : null,
    offsety : null,
    targetobj : null,
    dragapproved : 0,
    initialize:function() {
        document.onmousedown = this.drag
        document.onmouseup = function() {
            this.dragapproved = 0
        }
    },
    drag:function(e) {
        var evtobj = window.event ? window.event : e
        this.targetobj = window.event ? event.srcElement : e.target
        if (this.targetobj.className == "drag") {
            this.dragapproved = 1
            if (isNaN(parseInt(this.targetobj.style.left))) {
                this.targetobj.style.left = 0
            }
            if (isNaN(parseInt(this.targetobj.style.top))) {
                this.targetobj.style.top = 0
            }
            this.offsetx = parseInt(this.targetobj.style.left)
            this.offsety = parseInt(this.targetobj.style.top)
            this.x = evtobj.clientX
            this.y = evtobj.clientY
            if (evtobj.preventDefault)
                evtobj.preventDefault()
            document.onmousemove = dragobject.moveit
        }
    },
    moveit:function(e) {
        var evtobj = window.event ? window.event : e
        if (this.dragapproved == 1) {
            this.targetobj.style.left = this.offsetx + evtobj.clientX - this.x + "px"
            this.targetobj.style.top = this.offsety + evtobj.clientY - this.y + "px"
            return false
        }
    }
}

dragobject.initialize()

function countr()
{
    $('s').value = c
    c = c + 1
    setTimeout("countr()", 1000)
}

function pay_to_provider_check() {
    if (!($('ub04_claim_informations_rendering_providerid').value.match(pay_to_provider_id)) && !($('ub04_claim_informations_rendering_providerid').value == ''))
    {
        alert("Pay to Provider Id must not have special characters other than hyphen");
        $('ub04_claim_informations_rendering_providerid').focus();
        $('ub04_claim_informations_rendering_providerid').highlight();
        return false;
    }
    return true;
}


function isValidNPI(npi)
{
    if (npi != '')
    {
        var tmp, sum, i, j;
        /* the NPI is a 10 digit number, but it could be
         * preceded by the ISO prefix for the USA (80840)
         * when stored as part of an ID card.  The prefix
         * must be accounted for, so the NPI check-digit
         * will be the same with or without prefix.
         * The magic constant for 80840 is 24.
         */
        i = npi.length;
        if ((i == 15) && (npi.substring(0, 5) == "80840"))
            sum = 0;
        else if (i == 10)
            sum = 24;    /* to compensate for the prefix */
        else
        {
            alert("NPI must be 10 digits");
            return 0;
            /* length must be 10 or 15 bytes */
        }

        /* the algorithm calls for calculating the check-digit
         * from right to left
         */
        /* first, intialize the odd/even counter, taking into account
         * that the rightmost digit is presumed to be the check-sum
         * so in this case the rightmost digit is even instead of
         * being odd
         */
        j = 0;
        /* now scan the NPI from right to left */
        while (i--)
        {    /* only digits are valid for the NPI */
            if (isNaN(npi.charAt(i)))
            {
                alert("NPI Must be numeric")
                return 0;
            }
            /* this conversion works for ASCII and EBCDIC */
            tmp = npi.charAt(i) - '0';
            /* the odd positions are multiplied by 2 */
            if (j++ & 1)
            {    /* instead of multiplying by 2, in C
             * we can just shift-left by one bit
             * which is a faster way to multiply
             * by two.  Same as (tmp * 2)
             */
                if ((tmp <<= 1) > 9)
                {    /* when the multiplication by 2
                 * results in a two digit number
                 * (i.e., greater than 9) then the
                 * two digits are added up.  But we
                 * know that the left digit must be
                 * '1' and the right digit must be
                 * x mod 10.  In that case we can
                 * just subtract 10 instead of 'mod'
                 */
                    tmp -= 10;
                    /* 'tmp mod 10' */
                    tmp++;
                    /* left digit is '1' */
                }
            }
            sum += tmp;
        }
        /* If the checksum mod 10 is zero then the NPI is valid */
        if (sum % 10)
        {
            agree = confirm("This NPI number doesn't seems to be valid. Are you sure to continue?");
            if (agree == true)
                return 1;
            else
                return 0;
        }
        else
            return 1;
    }
    else
        return true
}


function payerdetails_autopopulate()
{

    var url = 'payer_informations_ub04';
    var parameters = 'payer=' + $('payer_details_payer_name').value;
    var payerAjax = new Ajax.Request(url, {
        method: 'get',
        parameters: parameters,
        onComplete: function(payer) {
            var payerInformations = eval("(" + payer.responseText + ")");

            if (payerInformations) {
                if (payerInformations.payer_name != null)
                    $("payer_details_payer_name").value = payerInformations.payer_name
                else
                    $("payer_details_payer_name").value = ""
                if (payerInformations.payer_address_one != null)
                    $("payer_details_payer_address1").value = payerInformations.payer_address_one
                else
                    $("payer_details_payer_address1").value = ""
                if (payerInformations.payer_address_two != null)
                    $("payer_details_payer_address2").value = payerInformations.payer_address_two
                else
                    $("payer_details_payer_address2").value = ""
                if (payerInformations.payer_city != null)
                    $("payer_details_payer_city").value = payerInformations.payer_city
                else
                    $("payer_details_payer_city").value = ""
                if (payerInformations.payer_state != null)
                    $("payer_details_payer_state").value = payerInformations.payer_state
                else
                    $("payer_details_payer_state").value = ""
                if (payerInformations.payer_zipcode != null)
                    $("payer_details_payer_zipcode").value = payerInformations.payer_zipcode
                else
                    $("payer_details_payer_zipcode").value = ""
            }
        }
    });
}


function providerdetails_autopopulate()
{

    var url = 'provider_informations_ub04';
    var parameters = 'provider=' + $('rendering_provider_details_rendering_provider_last_name').value;
    var providerAjax = new Ajax.Request(url, {
        method: 'get',
        parameters: parameters,
        onComplete: function(provider) {
            var providerInformations = eval("(" + provider.responseText + ")");

            if (providerInformations) {
                if (providerInformations.rendering_provider_last_name != null)
                    $("rendering_provider_details_rendering_provider_last_name").value = providerInformations.rendering_provider_last_name
                else
                    $("rendering_provider_details_rendering_provider_last_name").value = ""
                if (providerInformations.rendering_provider_address1 != null)
                    $("rendering_provider_details_rendering_provider_address1").value = providerInformations.rendering_provider_address1
                else
                    $("rendering_provider_details_rendering_provider_address1").value = ""
                if (providerInformations.rendering_provider_address2 != null)
                    $("rendering_provider_details_rendering_provider_address2").value = providerInformations.rendering_provider_address2
                else
                    $("rendering_provider_details_rendering_provider_address2").value = ""
                if (providerInformations.rendering_provider_city != null)
                    $("rendering_provider_details_rendering_provider_city").value = providerInformations.rendering_provider_city
                else
                    $("rendering_provider_details_rendering_provider_city").value = ""
                if (providerInformations.rendering_provider_state != null)
                    $("rendering_provider_details_rendering_provider_state").value = providerInformations.rendering_provider_state
                else
                    $("rendering_provider_details_rendering_provider_state").value = ""
                if (providerInformations.rendering_provider_zipcode != null)
                    $("rendering_provider_details_rendering_provider_zipcode").value = providerInformations.rendering_provider_zipcode
                else
                    $("rendering_provider_details_rendering_provider_zipcode").value = ""

            }
        }
    });
}


function billing_providerdetails_autopopulate()
{

    var url = 'billing_provider_informations_ub04';
    var parameters = 'provider=' + $('billing_provider_details_billing_provider_last_name').value;
    var providerAjax = new Ajax.Request(url, {
        method: 'get',
        parameters: parameters,
        onComplete: function(provider) {
            var providerInformations = eval("(" + provider.responseText + ")");
            if (providerInformations) {
                if (providerInformations.billing_provider_last_name != null)
                    $("billing_provider_details_billing_provider_last_name").value = providerInformations.billing_provider_last_name
                else
                    $("billing_provider_details_billing_provider_last_name").value = ""
                if (providerInformations.billing_provider_address1 != null)
                    $("billing_provider_details_billing_provider_address1").value = providerInformations.billing_provider_address1
                else
                    $("billing_provider_details_billing_provider_address1").value = ""

                if (providerInformations.billing_provider_city != null)
                    $("billing_provider_details_billing_provider_city").value = providerInformations.billing_provider_city
                else
                    $("billing_provider_details_billing_provider_city").value = ""
                if (providerInformations.billing_provider_state != null)
                    $("billing_provider_details_billing_provider_state").value = providerInformations.billing_provider_state
                else
                    $("billing_provider_details_billing_provider_state").value = ""
                if (providerInformations.billing_provider_zipcode != null)
                    $("billing_provider_details_billing_provider_zipcode").value = providerInformations.billing_provider_zipcode
                else
                    $("billing_provider_details_billing_provider_zipcode").value = ""
                if (providerInformations.billing_provider_telephone != null)
                    $("billing_provider_details_billing_provider_telephone").value = providerInformations.billing_provider_telephone
                else
                    $("billing_provider_details_billing_provider_telephone").value = ""
                if (providerInformations.billing_provider_npi != null)
                    $("billing_provider_details_billing_provider_npi").value = providerInformations.billing_provider_npi
                else
                    $("billing_provider_details_billing_provider_npi").value = ""
                if (providerInformations.billing_provider_tin_or_ein != null)
                    $("billing_provider_details_billing_provider_tin_or_ein").value = providerInformations.billing_provider_tin_or_ein
                else
                    $("billing_provider_details_billing_provider_tin_or_ein").value = ""


            }
        }
    });
}


function federal_tax_id_check() {

    if ($('ub04_claim_informations_billing_provider_tin_or_ein').value == '00-0000000')
    {
        return true;
    }
    else if (!($('ub04_claim_informations_billing_provider_tin_or_ein').value.match(federal_tax_id)))
    {

        alert("Federal tax id must be numeric");
        $('ub04_claim_informations_billing_provider_tin_or_ein').focus();
        $('ub04_claim_informations_billing_provider_tin_or_ein').highlight();
        return false;
    }
    else if ($('ub04_claim_informations_billing_provider_tin_or_ein').value.length != 9)
    {
        alert("Federal tax id must be numeric with 9 digits");
        $('ub04_claim_informations_billing_provider_tin_or_ein').focus();
        $('ub04_claim_informations_billing_provider_tin_or_ein').highlight();
        return false;
    }
    return true;
}

function zipcode_mandatory_onsubmit()
{

    // Billing Provider Zipcode

    if ($('billing_provider_details_billing_provider_zipcode').value == '')
    {
        alert('Billing Provider ZipCode cannot be blank');
        $('billing_provider_details_billing_provider_zipcode').focus();
        $('billing_provider_details_billing_provider_zipcode').highlight();
        return false;
    }

    if ($('billing_provider_details_billing_provider_zipcode').value != '')
    {
        if (!($('billing_provider_details_billing_provider_zipcode').value.match(regexp)))
        {
            alert("Zip code value should be 5 or 9 digits ");
            $('billing_provider_details_billing_provider_zipcode').focus();
            $('billing_provider_details_billing_provider_zipcode').highlight();
            return false;
        }
    }

    // Patient Zipcode

    if ($('ub04_claim_informations_patient_zipcode').value == '')
    {
        alert('Patient ZipCode cannot be blank');
        $('ub04_claim_informations_patient_zipcode').focus();
        $('ub04_claim_informations_patient_zipcode').highlight();
        return false;
    }


    if ($('ub04_claim_informations_patient_zipcode').value != '')
    {
        if (!($('ub04_claim_informations_patient_zipcode').value.match(regexp)))
        {
            alert("Zip code value should be 5 or 9 digits ");
            $('ub04_claim_informations_patient_zipcode').focus();
            $('ub04_claim_informations_patient_zipcode').highlight();
            return false;
        }
    }

    // Subscriber Zipcode

    if ($('ub04_claim_informations_subscriber_zipcode').value == '')
    {
        alert('Subscriber Zipcode cannot be blank');
        $('ub04_claim_informations_subscriber_zipcode').focus();
        $('ub04_claim_informations_subscriber_zipcode').highlight();
        return false;
    }

    if ($('ub04_claim_informations_subscriber_zipcode').value != '')
    {
        if (!($('ub04_claim_informations_subscriber_zipcode').value.match(regexp)))
        {
            alert("Zip code should be 5 or 9 digits ");
            $('ub04_claim_informations_subscriber_zipcode').focus();
            $('ub04_claim_informations_subscriber_zipcode').highlight();
            return false;
        }
    }

    // Payto Provider ZipCOde

    if ($('rendering_provider_details_rendering_provider_zipcode').value != '')
    {
        if (!($('rendering_provider_details_rendering_provider_zipcode').value.match(regexp)))
        {
            alert("Zip code should be 5 or 9 digits ");
            $('rendering_provider_details_rendering_provider_zipcode').focus();
            $('rendering_provider_details_rendering_provider_zipcode').highlight();
            return false;
        }
    }

    return true;

}


function mandatory(batch_type)
{

    var line;

    if ($('billing_provider_details_billing_provider_last_name').value == '')
    {
        alert('Billing Provider Name cannot be blank');
        $('billing_provider_details_billing_provider_last_name').focus();
        $('billing_provider_details_billing_provider_last_name').highlight();
        return  false;
    }

    if ($('billing_provider_details_billing_provider_address1').value == '')
    {
        alert('Billing Provider Address cannot be blank');
        $('billing_provider_details_billing_provider_address1').focus();
        $('billing_provider_details_billing_provider_address1').highlight();
        return false;
    }

    if ($('billing_provider_details_billing_provider_city').value == '')
    {
        alert('Billing Provider City cannot be blank');
        $('billing_provider_details_billing_provider_city').focus();
        $('billing_provider_details_billing_provider_city').highlight();
        return false;
    }

    if (($('billing_provider_details_billing_provider_state').value == '--' ) || ($('billing_provider_details_billing_provider_state').value == '' ))
    {
        alert('If State code is not present, capture XX, otherwise select correct State code');
        $('billing_provider_details_billing_provider_state').focus();
        $('billing_provider_details_billing_provider_state').highlight();
        return false;
    }

    if (($("ub04payer_patient_relationship1").value == "--") && (($("ub04payer_insured_last_name1").value != "") || ($("ub04payer_insured_first_name1").value != "")))
    {
        alert('Patient Relationship1 cannot be blank');
        $('ub04payer_patient_relationship1').focus();
        $('ub04payer_patient_relationship1').highlight();
        return false;
    }

    if (($("ub04payer_patient_relationship2").value == "--") && (($("ub04payer_insured_last_name2").value != "") || ($("ub04payer_insured_first_name2").value != "")))
    {
        alert('Patient Relationship2 cannot be blank');
        $('ub04payer_patient_relationship2').focus();
        $('ub04payer_patient_relationship2').highlight();
        return false;
    }

    if (($("ub04payer_patient_relationship3").value == "--") && (($("ub04payer_insured_last_name3").value != "") || ($("ub04payer_insured_first_name3").value != "")))
    {
        alert('Patient Relationship3 cannot be blank');
        $('ub04payer_patient_relationship3').focus();
        $('ub04payer_patient_relationship3').highlight();
        return false;
    }
    if ($('ub04_claim_informations_patient_account_number').value == '')
    {
        alert('Patient Control Number cannot be blank');
        $('ub04_claim_informations_patient_account_number').focus();
        $('ub04_claim_informations_patient_account_number').highlight();
        return false;
    }

    if ($('ub04_claim_informations_patient_bill_type').value == '')
    {
        alert('Type of bill cannot be blank');
        $('ub04_claim_informations_patient_bill_type').focus();
        $('ub04_claim_informations_patient_bill_type').highlight();
        return false;
    }

    if ($('ub04_claim_informations_billing_provider_tin_or_ein').value == '')
    {
        alert('Federal Tax number cannot be blank');
        $('ub04_claim_informations_billing_provider_tin_or_ein').focus();
        $('ub04_claim_informations_billing_provider_tin_or_ein').highlight();
        return false;
    }

    if ($('ub04_claim_informations_statement_cover_from').value == '')
    {
        alert('Statement Covers From cannot be blank');
        $('ub04_claim_informations_statement_cover_from').focus();
        $('ub04_claim_informations_statement_cover_from').highlight();
        return false;
    }

    if ($('ub04_claim_informations_statement_cover_to').value == '')
    {
        alert('Statement Covers Through cannot be blank');
        $('ub04_claim_informations_statement_cover_to').focus();
        $('ub04_claim_informations_statement_cover_to').highlight();
        return false;
    }

    if ($('ub04_claim_informations_patient_last_name').value == '')
    {
        alert('Patient Last Name cannot be blank');
        $('ub04_claim_informations_patient_last_name').focus();
        $('ub04_claim_informations_patient_last_name').highlight();
        return false;
    }

    if ($('ub04_claim_informations_patient_first_name').value == '')
    {
        alert('Patient First Name cannot be blank');
        $('ub04_claim_informations_patient_first_name').focus();
        $('ub04_claim_informations_patient_first_name').highlight();
        return false;
    }

    if ($('ub04_claim_informations_patient_address1').value == '')
    {
        alert('Patient Address cannot be blank');
        $('ub04_claim_informations_patient_address1').focus();
        $('ub04_claim_informations_patient_address1').highlight();
        return false;
    }

    if ($('ub04_claim_informations_patient_city').value == '')
    {
        alert('Patient City cannot be blank');
        $('ub04_claim_informations_patient_city').focus();
        $('ub04_claim_informations_patient_city').highlight();
        return false;
    }

    if (($('ub04_claim_informations_patient_state').value == '--' ) || ($('ub04_claim_informations_patient_state').value == '' ))
    {
        alert('If State code is not present, capture XX, otherwise select correct State code');
        $('ub04_claim_informations_patient_state').focus();
        $('ub04_claim_informations_patient_state').highlight();
        return false;
    }


    if ($('ub04_claim_informations_patient_dob').value == '')
    {
        alert('Patient Birth Date cannot be blank');
        $('ub04_claim_informations_patient_dob').focus();
        $('ub04_claim_informations_patient_dob').highlight();
        return false;
    }

    if ($('ub04_claim_informations_patient_gender').value == '')
    {
        alert('Patient Sex cannot be blank');
        $('ub04_claim_informations_patient_gender').focus();
        $('ub04_claim_informations_patient_gender').highlight();
        return false;
    }

    if ($('ub04_claim_informations_subscriber_last_name').value == '')
    {
        alert('Subscriber Last Name cannot be blank');
        $('ub04_claim_informations_subscriber_last_name').focus();
        $('ub04_claim_informations_subscriber_last_name').highlight();
        return false;
    }

    if ($('ub04_claim_informations_subscriber_first_name').value == '')
    {
        alert('Subscriber First Name cannot be blank');
        $('ub04_claim_informations_subscriber_first_name').focus();
        $('ub04_claim_informations_subscriber_first_name').highlight();
        return false;
    }

    if ($('ub04_claim_informations_subscriber_address1').value == '')
    {
        alert('Subscriber Address cannot be blank');
        $('ub04_claim_informations_subscriber_address1').focus();
        $('ub04_claim_informations_subscriber_address1').highlight();
        return false;
    }

    if ($('ub04_claim_informations_subscriber_city').value == '')
    {
        alert('Subscriber City cannot be blank');
        $('ub04_claim_informations_subscriber_city').focus();
        $('ub04_claim_informations_subscriber_city').highlight();
        return false;
    }

    if (($('ub04_claim_informations_subscriber_state').value == '--' ) || ($('ub04_claim_informations_subscriber_state').value == '' ))
    {

        alert('If State code is not present, capture XX, otherwise select correct State code');
        $('ub04_claim_informations_subscriber_state').focus();
        $('ub04_claim_informations_subscriber_state').highlight();
        return false;
    }


    /*
     if ($('ub04_claim_informations_billing_provider_npi').value == '' )
     {
     alert('Billing Provider Npi cannot be blank');
     $('ub04_claim_informations_billing_provider_npi').focus();
     $('ub04_claim_informations_billing_provider_npi').highlight();
     return false;
     }
     */
    if (batch_type != "PCN"){
        if ($('ub04_claim_informations_attending_provider_last_name').value == '')
        {
            alert('Attending Provider Last Name cannot be blank');
            $('ub04_claim_informations_attending_provider_last_name').focus();
            $('ub04_claim_informations_attending_provider_last_name').highlight();
            return false;
        }

        if ($('ub04_claim_informations_attending_provider_first_name').value == '')
        {
            alert('Attending Provider First Name cannot be blank');
            $('ub04_claim_informations_attending_provider_first_name').focus();
            $('ub04_claim_informations_attending_provider_first_name').highlight();
            return false;
        }
    }

    var payer_presence = false;
    for (line = 1; line <= 3; line++)
    {
        if ($('ub04payer_name' + line).value != '')
            payer_presence = true;
    }
    if (!(payer_presence))
    {
        alert("Enter atleast one payer")
        $('ub04payer_name1').focus()
        $('ub04payer_name1').highlight()
        return false;
    }
    var insured__name_presence = false;
    for (line = 1; line <= 3; line++)
    {
        if ($('ub04payer_insured_last_name' + line).value != '')
            insured__name_presence = true;
    }
    if (!(insured__name_presence))
    {
        alert("Enter atleast one insured last name")
        $('ub04payer_insured_last_name1').focus()
        $('ub04payer_insured_last_name1').highlight()
        return false;
    }
    insured__name_presence = false
    for (line = 1; line <= 3; line++)
    {
        if ($('ub04payer_insured_first_name' + line).value != '')
            insured__name_presence = true;
    }
    if (!(insured__name_presence))
    {
        alert("Enter atleast one insured first name")
        $('ub04payer_insured_first_name1').focus()
        $('ub04payer_insured_first_name1').highlight()
        return false;
    }
    var insured__id_presence = false;
    for (line = 1; line <= 3; line++)
    {
        if ($('ub04payer_insured_id' + line).value != '')
            insured__id_presence = true;
    }
    if (!(insured__id_presence))
    {
        alert("Enter atleast one insured id")
        $('ub04payer_insured_id1').focus()
        $('ub04payer_insured_id1').highlight()
        return false;
    }

//    if ($('ub04_claim_informations_rendering_providerid').value == '')
//    {
//
//        alert('Pay To Provider Id cannot be blank');
//        $('ub04_claim_informations_rendering_providerid').focus();
//        $('ub04_claim_informations_rendering_providerid').highlight();
//        return false;
//    }
    return true;
}

function IS_billing_provider_last_name()
{
    if ($('billing_provider_details_billing_provider_last_name').value != '')
    {
        if ($('billing_provider_details_billing_provider_last_name').value.match(alphanumeric))
            return true;
        else
        {
            alert('Please enter valid Billing Provider Name');
            $('billing_provider_details_billing_provider_last_name').focus();
            $('billing_provider_details_billing_provider_last_name').highlight();
            return false;
        }
    }
    else
    {
        alert('Billing Provider Name cannot be blank');
        $('billing_provider_details_billing_provider_last_name').focus();
        $('billing_provider_details_billing_provider_last_name').highlight();
        return false;
    }
}

function IS_patient_account_number()
{
    if ($('ub04_claim_informations_patient_account_number').value != '')
        return true;
    else
    {
        alert('Account No. cannot be blank');
        $('ub04_claim_informations_patient_account_number').focus();
        $('ub04_claim_informations_patient_account_number').highlight();
        return false;
    }
}
function IS_patient_last_name()
{
    if ($('ub04_claim_informations_patient_last_name').value != "")
        return true;
    else
    {
        alert("Patient Last Name cannot be blank");
        $('ub04_claim_informations_patient_last_name').focus();
        $('ub04_claim_informations_patient_last_name').highlight();
        return false;
    }
}

function IS_patient_first_name()
{
    if ($('ub04_claim_informations_patient_first_name').value != "")
        return true;
    else
    {
        alert("Patient First Name cannot be blank");
        $('ub04_claim_informations_patient_first_name').focus();
        $('ub04_claim_informations_patient_first_name').highlight();
        return false;
    }
}

function IS_billing_provider_npi()
{
    if ($('ub04_claim_informations_billing_provider_npi').value != "")
    {
        if ($('ub04_claim_informations_billing_provider_npi').value.match(npi_number))
        {
            return true;
        }
        else
        {
            alert("NPI Number should be 10 digits");
            $('ub04_claim_informations_billing_provider_npi').focus();
            $('ub04_claim_informations_billing_provider_npi').highlight();
            return false;
        }
    }
    else
    {
        confirm_npi = confirm("NPI Number is blank. Are you sure to continue?");
        if (confirm_npi == false)
        {
            $('ub04_claim_informations_billing_provider_npi').focus();
            $('ub04_claim_informations_billing_provider_npi').highlight();
            return false;
        }
        else
            return true
    }
}

function IS_provider_id()
{
    if ($('ub04_claim_informations_billing_providerid1').value == "")
    {
        confirm_prvid = confirm("Billing provider id field left blank. Are you sure to continue?");
        if (confirm_prvid == false)
        {
            $('ub04_claim_informations_billing_providerid1').focus();
            $('ub04_claim_informations_billing_providerid1').highlight();
            return false;
        }
        else
            return true
    }
    else
        return true

}

function service_line_blank_validator()
{
    if ($('ub04_serviceline_informations_charges').value != '' && $('ub04_serviceline_informations_rev_code').value != '' && $('ub04_serviceline_informations_service_units').value != '')
        return true;

    else if ($('ub04_serviceline_informations_charges').value == '')
    {
        alert("Enter the serviceline with RevCode,Service Units,Charges")
        $('ub04_serviceline_informations_charges').focus()
        $('ub04_serviceline_informations_charges').highlight()

        return false;
    }
    else if ($('ub04_serviceline_informations_rev_code').value == '')
    {
        alert("Enter the serviceline with RevCode,Service Units,Charges")
        $('ub04_serviceline_informations_rev_code').focus()
        $('ub04_serviceline_informations_rev_code').highlight()

        return false;
    }
    else if ($('ub04_serviceline_informations_service_units').value == '')
    {
        alert("Enter the serviceline with RevCode,Service Units,Charges")
        $('ub04_serviceline_informations_service_units').focus()
        $('ub04_serviceline_informations_service_units').highlight()

        return false;
    }
}

function service_line_validator()
{
    if (($('ub04_serviceline_informations_charges').value != "") && !($('ub04_serviceline_informations_charges').value.match(decimalamount)))
    {
        alert("Enter numeric value")
        $('ub04_serviceline_informations_charges').focus()
        $('ub04_serviceline_informations_charges').highlight()
        return false
    }
    else
        return true
}

function service_line_service_date()
{

    if (!($('ub04_serviceline_informations_service_date').value.match(mmddyyyy)) && ($('ub04_serviceline_informations_service_date').value) != "")
    {
        alert("Please enter a valid date, year must be greater than 1900");
        $('ub04_serviceline_informations_service_date').focus()
        $('ub04_serviceline_informations_service_date').highlight()
        return false
    }
    else if (($('ub04_serviceline_informations_service_date').value.match(mmddyyyy)) && (($('ub04_serviceline_informations_service_date').value) != ""))
    {
        if (future_date($('ub04_serviceline_informations_service_date').value))
        {
             alert("Future date is not permitted");
                    $('ub04_serviceline_informations_service_date').focus()
                    $('ub04_serviceline_informations_service_date').highlight()
                        return false;
//            agreefuturedate = confirm("You entered a future date. Are you sure to continue?")
//            if(agreefuturedate == true)
//                return true
//            else
//                {
//                    $('ub04_serviceline_informations_service_date').focus()
//                    $('ub04_serviceline_informations_service_date').highlight()
//                    return false
//                }
        }
        else
            {
                month = $('ub04_serviceline_informations_service_date').value.slice(0,2);
                day = $('ub04_serviceline_informations_service_date').value.slice(2,4);
                year = $('ub04_serviceline_informations_service_date').value.slice(4,8);
                threeMonthsPrior = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
                input_date = new Date(year, month, day)
                if(input_date >= threeMonthsPrior)
                      return true
                else
                {
                    agree = confirm('Date you entered needs to be confirmed. Are you sure to continue?');
                    if(agree == true)
                        return true
                    else
                    {
                        $('ub04_serviceline_informations_service_date').focus()
                        return false
                    }
                }
            }

    }
    return true
}


function total_charge_adder() {
    if ($('incorrect') == null)
    {
        sum = 0
        if ($('numservicelines') != null) // checking if it is incompleted view
        {
            numsvc = $('numservicelines').value;

            if (numsvc > rowcount)
                loopcount = numsvc
            else
                loopcount = rowcount
        }
        else
            loopcount = rowcount

        for (i = 1; i <= loopcount; i++)
        {
            if($("ub04_serviceline_informations_charges" + i + "") != null)
            {
                if($("ub04_serviceline_informations_charges" + i + "").value != "")
                    {
                        sum = sum + parseFloat(($("ub04_serviceline_informations_charges" + i + "").value))
                    }
            }
            
        }
        if (sum.toFixed(2) != ((parseFloat($("ub04_claim_informations_total_charges").value)).toFixed(2)))
        {
            alert("Total Charge is not matching with sum of service line Charges");
            $('ub04_claim_informations_total_charges').focus();
//          $('ub04_claim_informations_total_charges').value = parseFloat(sum);                                Commented this line as per ticket #14413
            return false
        }
        else
            return true
    }
    else
    {
        svc_count = $('svc_count').value
        numsvc = $('numservicelines').value;
        sum1 = 0
        for (i = 1; i <= svc_count; i++)
        {
            if($("ub04_serviceline_informations_charges" + i + "") != null)
                {
                if($("ub04_serviceline_informations_charges" + i + "").value != "")
                    {
                        sum1 = sum1 + parseFloat(($("ub04_serviceline_informations_charges" + i + "").value))
                    }
                }
            // $('ub04_claim_informations_total_charges').value = sum;
        }
       if (sum1.toFixed(2) != ((parseFloat($("ub04_claim_informations_total_charges").value)).toFixed(2)))
        {
            alert("Total Charge is not matching with sum of service line Charges");
            $('ub04_claim_informations_total_charges').focus();
//          $('ub04_claim_informations_total_charges').value = parseFloat(sum1);                                    Commented this line as per ticket #14413
            return false
        }
        else
            return true
    }
    return true;
}

function atleastoneserviceline()
{

    if ($('incorrect') == null)
    {
        if (count == 0 && $('view') == null)
        {
            alert("Add atleast one serviceline");
            $('ub04_serviceline_informations_rev_code').focus();
            return false;
        }
        else
            return true;
    }
    else
        return true
}

function future_date(date)
{
    var now = new Date();
    var day = date.substr(2, 2);
    var month = date.substr(0, 2);
    var year;
    if (date.length == 8)
        year = date.substr(4, 4);
    else
    {
        year = date.substr(4, 2)
        if (year.charAt(0) == '0' || parseInt(date.substr(4, 2), 10) < 50)
            year = "20" + year
        else
            year = "19" + year
    }
    var date1 = new Date(year, month - 1, day);
    if (date1 > now)
    {
        return true
    }
    return false
}
function IS_date_mmddyy()
{
    var line
    if (!($('ub04_claim_informations_statement_cover_from').value.match(mmddyyyy) ))
    {
        alert("Date format:[01-12][01-31][yyyy]");
        $('ub04_claim_informations_statement_cover_from').focus()
        $('ub04_claim_informations_statement_cover_from').highlight()
        return false
    }
    else if (!($('ub04_claim_informations_statement_cover_to').value.match(mmddyyyy) ))
    {
        alert("Date format:[01-12][01-31][yyyy]");
        $('ub04_claim_informations_statement_cover_to').focus()
        $('ub04_claim_informations_statement_cover_to').highlight()
        return false
    }
    else
    {
        if ((($('ub04_claim_informations_statement_cover_from').value).substr(4, 4) < 1900) && ($('ub04_claim_informations_statement_cover_from').value != '01012000'))
        {
            alert("Invalid date / Year must be greater than 1900")
            $('ub04_claim_informations_statement_cover_from').focus()
            $('ub04_claim_informations_statement_cover_from').highlight()
            return false
        }
        if (($('ub04_claim_informations_statement_cover_to').value).substr(4, 4) < 1900)
        {
            alert("Year must be greater than 1900")
            $('ub04_claim_informations_statement_cover_to').focus()
            $('ub04_claim_informations_statement_cover_to').highlight()
            return false
        }
    }

    if (!($('ub04_claim_informations_patient_dob').value.match(mmddyyyy) ))
    {
        alert("Date format: [00-12][01-31][yyyy]");
        $('ub04_claim_informations_patient_dob').focus()
        $('ub04_claim_informations_patient_dob').highlight()
        return false
    }
    else
    {
        if (future_date($('ub04_claim_informations_patient_dob').value))
        {
            alert("PATIENT DATE OF BIRTH is a future date")
            $('ub04_claim_informations_patient_dob').focus()
            $('ub04_claim_informations_patient_dob').highlight()
            return false
        }
    }

    if (!($('ub04_claim_informations_admission_date').value.match(mmddyyyy)) && ($('ub04_claim_informations_admission_date').value) != "")
    {
        alert("Date format:[01-12][01-31][yyyy]");
        $('ub04_claim_informations_admission_date').focus()
        $('ub04_claim_informations_admission_date').highlight()
        return false
    }
    else if (($('ub04_claim_informations_admission_date').value.match(mmddyyyy)) && ($('ub04_claim_informations_admission_date').value) != "")
    {
        if (future_date($('ub04_claim_informations_admission_date').value))
        {
            alert("ADMISSION DATE is a future date")
            $('ub04_claim_informations_admission_date').focus()
            $('ub04_claim_informations_admission_date').highlight()
            return false
        }

        // var enteredyear = parseInt($('ub04_claim_informations_admission_date').value).substr(4,4)

        else if (($('ub04_claim_informations_admission_date').value).substr(4, 4) < 1900)
        {
            alert("Year must be greater than 1900")
            $('ub04_claim_informations_admission_date').focus()
            $('ub04_claim_informations_admission_date').highlight()
            return false
        }

    }
    for (line = 1; line <= 8; line++)
    {
        if (!($('occurence_date' + line).value.match(mmddyyyy)) && ($('occurence_date' + line).value) != "")
        {
            alert("Date format:[01-12][01-31][yyyy]");
            $('occurence_date' + line).focus()
            $('occurence_date' + line).highlight()
            return false
        }
        else
        {
            /*
             // Checking if the 8 occurance fields entered future date
             if(future_date($('occurence_date'+line).value))
             {
             alert("OCCURRENCE DATE is a future date")
             $('occurence_date'+line).focus()
             $('occurence_date'+line).highlight()
             return false
             }
             */
        }
    }

    for (line = 1; line <= 4; line++)
    {
        if (!($('occurence_span_from_date' + line).value.match(mmddyyyy)) && ($('occurence_span_from_date' + line).value) != "")
        {
            alert("Date format:[01-12][01-31][yyyy]");
            $('occurence_span_from_date' + line).focus()
            $('occurence_span_from_date' + line).highlight()
            return false
        }

    }

    for (line = 1; line <= 4; line++)
    {
        if (!($('occurence_span_through_date' + line).value.match(mmddyyyy)) && ($('occurence_span_through_date' + line).value) != "")
        {
            alert("Date format:[01-12][01-31][yyyy]");
            $('occurence_span_through_date' + line).focus()
            $('occurence_span_through_date' + line).highlight()
            return false
        }

    }


    if (!($('ub04_claim_informations_principal_proc_date').value.match(mmddyyyy)) && ($('ub04_claim_informations_principal_proc_date').value) != "")
    {
        alert("Date format:[01-12][01-31][yyyy]");
        $('ub04_claim_informations_principal_proc_date').focus()
        $('ub04_claim_informations_principal_proc_date').highlight()
        return false
    }
    else
    {
        if (future_date($('ub04_claim_informations_principal_proc_date').value))
        {
            alert("PRINCIPAL PROCEDURE DATE is a future date")
            $('ub04_claim_informations_principal_proc_date').focus()
            $('ub04_claim_informations_principal_proc_date').highlight()
            return false
        }
    }

    for (line = 1; line <= 5; line++)
    {
        if (!($('ub04_claim_informations_other_proc_date' + line).value.match(mmddyyyy)) && ($('ub04_claim_informations_other_proc_date' + line).value) != "")
        {
            alert("Date format:[01-12][01-31][yyyy]");
            $('ub04_claim_informations_other_proc_date' + line).focus()
            $('ub04_claim_informations_other_proc_date' + line).highlight()
            return false
        }
        else
        {
            if (future_date($('ub04_claim_informations_other_proc_date' + line).value))
            {
                alert("OTHER PROCEDURE DATE  is a future date")
                $('ub04_claim_informations_other_proc_date' + line).focus()
                $('ub04_claim_informations_other_proc_date' + line).highlight()
                return false
            }
        }
    }

    return true
}

function IS_futuredate_creationdate()
{
    if (future_date($('ub04_claim_informations_creation_date').value))
    {
        alert("CREATION DATE  is a future date")
        $('ub04_claim_informations_creation_date').focus()
        $('ub04_claim_informations_creation_date').highlight()
        return false
    }
    else
        return true;
}


function IS_statement_from_less_equal_statement_to_future() //date validation functions in statement  cover field
{
    var now = new Date();
    var statement_from = $('ub04_claim_informations_statement_cover_from').value
    var statement_to = $('ub04_claim_informations_statement_cover_to').value
    var from_date = statement_from.substr(2, 2);
    var from_month = statement_from.substr(0, 2);
    var from_year = statement_from.substr(4, 4);
    /*
     if (from_year.charAt(0) == '0' ||  parseInt(statement_from.substr(4,2),10) < 50 )
     from_year = "20"+ from_year
     else
     from_year = "19"+ from_year
     */
    var date1 = new Date(from_year, from_month - 1, from_date);
    var to_date = statement_to.substr(2, 2);
    var to_month = statement_to.substr(0, 2);
    var to_year = statement_to.substr(4, 4);
    /*
     if (to_year.charAt(0) == '0' ||  parseInt(statement_to.substr(4,2),10) < 50 )
     to_year = "20"+ to_year
     else
     to_year = "19"+ to_year
     */
    var date2 = new Date(to_year, to_month - 1, to_date);
    if ($('ub04_claim_informations_statement_cover_from').value != "" && date1 > now) //to check whethet statement cover from is a future date
    {
        alert("STATEMENT FROM date is a future date")
        $('ub04_claim_informations_statement_cover_from').focus()
        $('ub04_claim_informations_statement_cover_from').highlight()
        return false
    }
    else if ($('ub04_claim_informations_statement_cover_to').value != "" && date2 > now && $('ub04_claim_informations_statement_cover_to').value != '12312010') //to check whethet statement cover through is a future date
    {
        alert("STATEMENT THROUGH date is a future date")
        $('ub04_claim_informations_statement_cover_to').focus()
        $('ub04_claim_informations_statement_cover_to').highlight()
        return false
    }
    else if (($('ub04_claim_informations_statement_cover_from').value != "") && ($('ub04_claim_informations_statement_cover_to').value != ""))
    {

        if (date2 < date1) // to check whether  statement cover from date from is less than statement through date
        {
            alert(" STATEMENT FROM DATE cannot be greater than STATEMENT TO DATE");
            $('ub04_claim_informations_statement_cover_from').focus()
            $('ub04_claim_informations_statement_cover_from').highlight()
            return false;
        }
        else
            return true;
    }
    else
        return true;
}

function IS_occurence_from_less_equal_occurence_to_future()//date validation functions in occurence span field
{
    var now = new Date();
    var return_value = true;
    for (var i = 1; i <= 4; i++)
    {
        var occurence_from = $("occurence_span_from_date" + i).value
        var occurence_to = $("occurence_span_through_date" + i).value
        var from_date = occurence_from.substr(2, 2);
        var from_month = occurence_from.substr(0, 2);
        var from_year = occurence_from.substr(4, 4);
        /*
         if (from_year.charAt(0) == '0' ||  parseInt(occurence_from.substr(4,2),10) < 50 )
         from_year = "20"+ from_year
         else
         from_year = "19"+ from_year
         */
        var date1 = new Date(from_year, from_month - 1, from_date);
        var to_date = occurence_to.substr(2, 2);
        var to_month = occurence_to.substr(0, 2);
        var to_year = occurence_to.substr(4, 4);
        /*
         if (to_year.charAt(0) == '0' ||  parseInt(occurence_to.substr(4,2),10) < 50 )
         to_year = "20"+ to_year
         else
         to_year = "19"+ to_year
         */
        var date2 = new Date(to_year, to_month - 1, to_date);
        /*
         if  ($("occurence_span_from_date"+i).value !="" && date1 > now ) //to check whethet statement cover from is a future date
         {
         alert("OCCURENCE SPAN FROM date is a future date")
         $("occurence_span_from_date"+i).focus()
         $("occurence_span_from_date"+i).highlight()
         return_value = false
         }
         else if ($("occurence_span_through_date"+i).value!= "" && date2 > now) //to check whethet statement cover through is a future date
         {
         alert("OCCURENCE SPAN THROUGH date is a future date")
         $("occurence_span_through_date"+i).focus()
         $("occurence_span_through_date"+i).highlight()
         return_value = false
         }
         else */
        if (($("occurence_span_from_date" + i).value != "") && ($("occurence_span_through_date" + i).value != ""))
        {

            if (date2 < date1) // to check whether  statement cover from date from is less than statement through date
            {
                alert(" OCCURRENCE SPAN FROM DATE cannot be greater than OCCURENCE SPAN THROUGH DATE");
                $("occurence_span_from_date" + i).focus()
                $("occurence_span_from_date" + i).highlight()
                return_value = false;
            }
            else
                return_value = true;
        }
    }
    return return_value
}

function rev_code()
{
    if (!($('ub04_serviceline_informations_rev_code').value.match(revenue_code)) && ($('ub04_serviceline_informations_rev_code').value) != "")
    {
        alert("Revenue Code should be 4 digits");
        $('ub04_serviceline_informations_rev_code').focus()
        $('ub04_serviceline_informations_rev_code').highlight()
        return false
    }
    return true
}

function admission_hour()
{
    if ($('ub04_claim_informations_admission_hour').value == "")
    {
        var confirmation = confirm("No value entered in ADMISSION HOUR. Are you sure to continue?")
        if (confirmation == true)
            return true;
        else
        {
            $('ub04_claim_informations_admission_hour').focus()
            $('ub04_claim_informations_admission_hour').highlight()
            return false;
        }
    }
}

function admission_source()
{
    if ($('ub04_claim_informations_admission_source').value == "")
    {
        var confirmation = confirm("No value entered in ADMISSION SOURCE. Are you sure to continue?")
        if (confirmation == true)
            return true;
        else
        {
            $('ub04_claim_informations_admission_source').focus()
            $('ub04_claim_informations_admission_source').highlight()
            return false;
        }
    }
}

function patient_status()
{
    if ($('ub04_claim_informations_patient_status_code').value == "")
    {
        var confirmation = confirm("No value entered in PATIENT STATUS CODE. Are you sure to continue?")
        if (confirmation == true)
            return true;
        else
        {
            $('ub04_claim_informations_patient_status_code').focus()
            $('ub04_claim_informations_patient_status_code').highlight()
            return false;
        }
    }
}

function principal_diag()
{

    if (($('ub04_claim_informations_dx_version_qualifier').value == "") && ($('ub04_claim_informations_principal_diag').value == ""))
    {
        confirm_dx_and_pd = confirm("Both Diagnosis/Procedure Code and PRINCIPAL DIAG are empty. Are you sure to continue?");
        if (confirm_dx_and_pd == true)
            return true
        else
        {
            $('ub04_claim_informations_dx_version_qualifier').focus()
            $('ub04_claim_informations_dx_version_qualifier').highlight()
            return false
        }
    }
    else if (($('ub04_claim_informations_dx_version_qualifier').value == "") && ($('ub04_claim_informations_principal_diag').value != ""))
    {

        confirm_dx = confirm("No value entered in Diagnosis/Procedure Code. Are you sure to continue?");
        if (confirm_dx == true)
            return true
        else
        {
            $('ub04_claim_informations_dx_version_qualifier').focus()
            $('ub04_claim_informations_dx_version_qualifier').highlight()
            return false
        }
    }
    else if (($('ub04_claim_informations_dx_version_qualifier').value != "") && ($('ub04_claim_informations_principal_diag').value == ""))
    {

        confirm_pd = confirm("No value entered in PRINCIPAL DIAG. Are you sure to continue?");
        if (confirm_pd == true)
            return true
        else
        {
            $('ub04_claim_informations_principal_diag').focus()
            $('ub04_claim_informations_principal_diag').highlight()
            return false
        }
    }
    else
    {
        return true;
    }
}

function hcpcs_prompt()
{
    if ((($('ub04_serviceline_informations_hcpcs').value != '')) && (!($('ub04_serviceline_informations_hcpcs').value.match(hcpcs_code))))
    {
        alert("Hcpcs code should be 5 characters");
        $('ub04_serviceline_informations_hcpcs').focus();
        $('ub04_serviceline_informations_hcpcs').highlight();
        return false
    }
    else
        return true
}

function release_info(field, id)
{

    if (id == '1')
    {
        var field1 = field + id
        if ($(field1).value == "")
        {
            var confirmation = confirm("No value entered in RELEASE INFO. Are you sure to continue?")

            if (confirmation == true)
                return true;
            else
            {
                $(field1).focus()
                $(field1).highlight()
                return false;
            }
        }
    }
}

function assign_benefits(field_id)
{

    if ($(field_id).value == "")
    {
        var confirmation = confirm("No value entered in ASSIGNMENT BENEFITS. Are you sure to continue?")
        if (confirmation == true)
            return true;
        else
        {
            $(field_id).focus()
            $(field_id).highlight()
            return false;
        }
    }

}

function patient_relationship(field_id)
{

    if ($(field_id).value == "")
    {
        var confirmation = confirm("No value entered in PATIENT RELETIONSHIPS. Are you sure to continue?")
        if (confirmation == true)
            return true;
        else
        {
            $(field_id).focus()
            $(field_id).highlight()
            return false;
        }
    }
}

function optional_attending_npi1(field_id, batch_type)
{
  // if (batch_type == "PCN"){
     if ($(field_id).value == ""){
        var confirmation = confirm("No value entered in NPI / FIRST / LAST . Are you sure to continue?")
        if (confirmation == true)
            return true;
        else {
//            setTimeout($(field_id).focus(), 10);
            document.getElementById(field_id).highlight()
            return false;
        }
     }
 //  }
}

function validate_qualifier(field_id, batch_type)
{
   //if (batch_type == "PCN"){
     if ($(field_id).value == ""){
        var confirmation = confirm("QUAL is blank. Are you sure to continue?")
        if (confirmation == true){
            return true;
        }
        else {
            //$(field_id).highlight();
            $(field_id).focus();
            return false;
        }
     }
     else
         {
            flag = 0;
            qual_arr = new Array( '0B', '1A', '1B', '1C', '1D', '1G', '1H', '1J', 'B3', 'BQ', 'EI', 'FH', 'G2', 'G5', 'LU', 'SY', 'U3', 'X5', 'ZZ');
            temp_value = $(field_id).value;

            for (qual_array_count = 0; qual_array_count < qual_arr.length; qual_array_count++) {

                if (qual_arr[qual_array_count] != temp_value)
                    flag = flag + 0;
                else
                    flag = flag + 1;
            }
            if (flag > 0)
                return true;
            else
            {
                agree = confirm("Qualifier you entered needs to be confirmed. Are you sure to continue?”");
                if(agree == true)
                    return true
                else
                   {
                       $(field_id).focus();
                    return false
                   } 
         }
         }
   //}
}

function optional_pay_to_provider(field_id, batch_type)
{
    if (batch_type == "PCN"){
       if ($(field_id).value == ""){
            var confirmation = confirm("No value entered in Pay to Provider ID . Are you sure to continue?")
            if (confirmation == true)
                return true;
            else {
                $(field_id).focus()
                $(field_id).highlight()
                return false;
            }
        }
    }
}

function IS_revenue_code_0001(line)
{
    if ((($('ub04_serviceline_informations_rev_code' + line).value != '') && ($('ub04_serviceline_informations_rev_code' + line).value == "0001")))
    {
        var confirmation = confirm("Revenue code '0001' is for total charges. Are you sure to continue?")
        if (confirmation == true)
            return true;
        else
            return false;
    }
}

function zipcode_validator(element_id)
{
    if (element_id == 'rendering_provider_details_rendering_provider_zipcode')
    {
        if ($F(element_id) != '')
        {
            if ($F(element_id).match(regexp))
                return true
            else
            {
                alert("Zip code value should be 5 or 9 digits ");
                $(element_id).focus();
                //return false;
            }
        }
        else
            return true
    }
    else
    {
        if ($F(element_id).match(regexp))
            return true
        else
        {
            alert("Zip code cannot be blank / should be 5 or 9 digits");
            $(element_id).focus();
            //return false;
        }
    }
}


function IS_name_string_informations_patient()
{
    if (!($('ub04_claim_informations_patient_last_name').value.match(alphabet)) && !($('ub04_claim_informations_patient_first_name').value.match(alphabet)))
    {
        alert("Name fields cannot be empty, it should contain alphabets only");
        $('ub04_claim_informations_patient_last_name').focus();
        $('ub04_claim_informations_patient_last_name').highlight();
        return false;
    }
    else if (!($('ub04_claim_informations_patient_last_name').value.match(alphabet)) && ($('ub04_claim_informations_patient_first_name').value.match(alphabet)))
    {
        alert("Lastname field cannot be empty, it should contain alphabets only");
        $('ub04_claim_informations_patient_last_name').focus();
        $('ub04_claim_informations_patient_last_name').highlight();
        return false;
    }
    else if (($('ub04_claim_informations_patient_last_name').value.match(alphabet)) && !($('ub04_claim_informations_patient_first_name').value.match(alphabet)))
    {
        alert("Firstname field cannot be empty, it should contain alphabets only");
        $('ub04_claim_informations_patient_first_name').focus();
        $('ub04_claim_informations_patient_first_name').highlight();
        return false;
    }
    else
        return true;
}

function IS_name_string_informations_subscriber()
{
    if (!($('ub04_claim_informations_subscriber_last_name').value.match(alphabet)) && !($('ub04_claim_informations_subscriber_first_name').value.match(alphabet)))
    {
        alert("Name fields cannot be empty, it should contain alphabets only");
        $('ub04_claim_informations_subscriber_last_name').focus();
        $('ub04_claim_informations_subscriber_last_name').highlight();
        return false;
    }
    else if (!($('ub04_claim_informations_subscriber_last_name').value.match(alphabet)) && ($('ub04_claim_informations_subscriber_first_name').value.match(alphabet)))
    {
        alert("Lastname field cannot be empty, it should contain alphabets only");
        $('ub04_claim_informations_subscriber_last_name').focus();
        $('ub04_claim_informations_subscriber_last_name').highlight();
        return false;
    }
    else if (($('ub04_claim_informations_subscriber_last_name').value.match(alphabet)) && !($('ub04_claim_informations_subscriber_first_name').value.match(alphabet)))
    {
        alert("Firstname field cannot be empty, it should contain alphabets only");
        $('ub04_claim_informations_subscriber_first_name').focus();
        $('ub04_claim_informations_subscriber_first_name').highlight();
        return false;
    }
    else
        return true;
}

function IS_name_string_informations_insured()
{
    if (!($('ub04payer_insured_last_name1').value.match(alphabet)) && !($('ub04payer_insured_first_name1').value.match(alphabet)))
    {
        alert("Name fields cannot be empty, it should contain alphabets only");
        $('ub04payer_insured_last_name1').focus();
        $('ub04payer_insured_last_name1').highlight();
        return false;
    }
    else if (!($('ub04payer_insured_last_name1').value.match(alphabet)) && ($('ub04payer_insured_first_name1').value.match(alphabet)))
    {
        alert("Lastname field cannot be empty, it should contain alphabets only");
        $('ub04payer_insured_last_name1').focus();
        $('ub04payer_insured_last_name1').highlight();
        return false;
    }
    else if (($('ub04payer_insured_last_name1').value.match(alphabet)) && !($('ub04payer_insured_first_name1').value.match(alphabet)))
    {
        alert("Firstname field cannot be empty, it should contain alphabets only");
        $('ub04payer_insured_first_name1').focus();
        $('ub04payer_insured_first_name1').highlight();
        return false;
    }
    else
        return true;
}

function IS_string_initials(name)
{
    if ($(name).value != "")
    {
        if ($(name).value.match(alphabet))
            return true
        else
        {
            alert("Initials must be alphabets");
            $(name).focus();
            $(name).highlight();
            return false
        }
    }
    else
        return true
}


function billing_provider_self()
{
    if ($('billing_prv_self').checked == true)
    {
        $('rendering_provider_details_rendering_provider_last_name').value = $('billing_provider_details_billing_provider_last_name').value;
        $('rendering_provider_details_rendering_provider_address1').value = $('billing_provider_details_billing_provider_address1').value;
        $('rendering_provider_details_rendering_provider_address2').value = $('billing_provider_details_billing_provider_address2').value;
        $('rendering_provider_details_rendering_provider_city').value = $('billing_provider_details_billing_provider_city').value;
        $('rendering_provider_details_rendering_provider_state').value = $('billing_provider_details_billing_provider_state').value;
        $('rendering_provider_details_rendering_provider_zipcode').value = $('billing_provider_details_billing_provider_zipcode').value;
        $('ub04_claim_informations_rendering_providerid').value = $('ub04_claim_informations_billing_providerid1').value;
    }
    else
    {
        $('rendering_provider_details_rendering_provider_last_name').value = "";
        $('rendering_provider_details_rendering_provider_address1').value = "";
        $('rendering_provider_details_rendering_provider_address2').value = "";
        $('rendering_provider_details_rendering_provider_city').value = "";
        $('rendering_provider_details_rendering_provider_state').value = "";
        $('rendering_provider_details_rendering_provider_zipcode').value = "";
        $('ub04_claim_informations_rendering_providerid').value = "";
    }
}

function subscr_self()
{
    if ($('subscriber_self').checked == true)
    {
        $('ub04_claim_informations_subscriber_last_name').value = $('ub04_claim_informations_patient_last_name').value;
        $('ub04_claim_informations_subscriber_first_name').value = $('ub04_claim_informations_patient_first_name').value;
        $('ub04_claim_informations_subscriber_middle_initial').value = $('ub04_claim_informations_patient_middle_initial').value;
        $('ub04_claim_informations_subscriber_address1').value = $('ub04_claim_informations_patient_address1').value;
        $('ub04_claim_informations_subscriber_city').value = $('ub04_claim_informations_patient_city').value;
        $('ub04_claim_informations_subscriber_state').value = $('ub04_claim_informations_patient_state').value;
        $('ub04_claim_informations_subscriber_zipcode').value = $('ub04_claim_informations_patient_zipcode').value;
    }

    else
    {
        $('ub04_claim_informations_subscriber_last_name').value = "";
        $('ub04_claim_informations_subscriber_first_name').value = "";
        $('ub04_claim_informations_subscriber_middle_initial').value = "";
        $('ub04_claim_informations_subscriber_address1').value = "";
        $('ub04_claim_informations_subscriber_city').value = "";
        $('ub04_claim_informations_subscriber_state').value = "";
        $('ub04_claim_informations_subscriber_zipcode').value = "";
    }
}


function subscriber_address1_notprovided()
{
    if ($('ub04_claim_informations_subscriber_address1').value == "NOT PROVIDED" || $('ub04_claim_informations_subscriber_address1').value == "")
    {
        if ($('ub04_claim_informations_subscriber_address2').value != "")
        {
            confirm_sub_addr = confirm("You have left the Address1 field blank / entered as NOT PROVIDED. Are you sure?");
            if (confirm_sub_addr == true)
                return true
            else
            {
                $('ub04_claim_informations_subscriber_address2').focus()
                $('ub04_claim_informations_subscriber_address2').highlight()
                return false
            }
        }
        else
            return true
    }
        return true
}

function makeIncompleteCommentVisible(){
    if ($('proc_comments') != null) {
        if($F('proc_comments') == "Other") {
            if($('comment') != null) {
                $('comment').value = "";
                $('comment').style.display = "block";
                $('comment').focus();
            }
        }
        else {
            if($('comment') != null) {
                $('comment').value = "";
                $('comment').style.display = "none";
            }
        }
    }
}

function isComment() {

    if (($F('proc_comments').match(/^[\s]+$/)) || ($F('proc_comments') == "--"))
    {
        alert("Please enter your reason for incompleting the claim in the Comments field");
        $('proc_comments').focus();
        return false;
    }
    else if($F('proc_comments') == "Other") 
    {
        if($('comment') != null) 
        {
            var comment = $F('comment').trim();
            if(comment == "")
            {
                alert("Please enter other-comments as reason for incompleting the claim");
                $('proc_comments').focus();
                return false;
            }
        }
    }

    if ($F('proc_comments') != "")
    {
        if (count > 0)
        {
            agree_saveclaim = confirm("Do you want to save the claim while incompleting this job?");
            if (agree_saveclaim == true){
                $('save_claim').value = 'true'
            }
            else{
                $('save_claim').value = 'false'
            }
        }
        else
            $('save_claim').value = 'false'

        var status = confirm("Are You Sure you want to continue");
        if (status == true)
            return true;
        else if (status == false)
            return false;
    }
}


function errorcheck() {
    if ($('incorrect') != null)         // To check if it is qa view
    {
        var qa_c = $('qa_comm').value
        var sel_ind = $('status').selectedIndex
        if (sel_ind == 1)
        {
            if (qa_c == '')
            {
                alert('You Must Enter Comments, on Selecting Incomplete or Reject')
                $('qa_comm').focus();
                return false;
            }
            else
                return true
        }
        else
            return true

    }
    else
        return true;
}


function dxcode_admitcode_duplication()
{
    if (($('ub04_claim_informations_dx_version_qualifier').value.length > 1) || ($('ub04_claim_informations_principal_diag').value.length == 1))
    {
        agree = confirm("DX Code(66) must be 1 digit and principal diagnosis code(67) cannot be 1 digit,check this please")
        if (agree == true)
        {
            $('ub04_claim_informations_dx_version_qualifier').focus();
            return false;
        }
        else
            return true;
    }
    else
        return true;
}

function diagnosiscode_duplication()
{
    if ($('ub04_claim_informations_principal_diag').value != "")
    {
        if (($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag1').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag2').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag3').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag4').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag5').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag6').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag7').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag8').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag9').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag10').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag11').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag12').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag13').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag14').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag15').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag16').value) || ($('ub04_claim_informations_principal_diag').value == $('ub04_claim_informations_other_diag17').value))
        {
            alert("Principal diagnosis code and secondary diagnosis codes cannot have same value");
            $('ub04_claim_informations_principal_diag').focus();
            return false;
        }
        else
            return true;
    }
    else
        return true;
}

function specialcharactercheck_svc()
{
    if( $('ub04_serviceline_informations_rev_code').value.match(issplchr) || $('ub04_serviceline_informations_description').value.match(issplchr) || $('ub04_serviceline_informations_hcpcs').value.match(issplchr) || $('ub04_serviceline_informations_rates').value.match(issplchr) || $('ub04_serviceline_informations_hipps_codes').value.match(issplchr) || $('ub04_serviceline_informations_modifier').value.match(issplchr) || $('ub04_serviceline_informations_modifier2').value.match(issplchr) || $('ub04_serviceline_informations_modifier3').value.match(issplchr) || $('ub04_serviceline_informations_modifier4').value.match(issplchr) || $('ub04_serviceline_informations_service_date').value.match(issplchr) || $('ub04_serviceline_informations_service_units').value.match(issplchr) || $('ub04_serviceline_informations_charges').value.match(issplchr) || $('ub04_serviceline_informations_non_covered_charges').value.match(issplchr) || $('ub04_serviceline_informations_unlabel_49').value.match(issplchr))
    {
        alert("Special characters not permitted")
        if ($('ub04_serviceline_informations_rev_code').value.match(issplchr))
            $('ub04_serviceline_informations_rev_code').focus()
        else if ($('ub04_serviceline_informations_description').value.match(issplchr))
            $('ub04_serviceline_informations_description').focus()
        else if ($('ub04_serviceline_informations_hcpcs').value.match(issplchr))
            $('ub04_serviceline_informations_hcpcs').focus()
        else if ($('ub04_serviceline_informations_rates').value.match(issplchr))
            $('ub04_serviceline_informations_rates').focus()
        else if ($('ub04_serviceline_informations_hipps_codes').value.match(issplchr))
            $('ub04_serviceline_informations_hipps_codes').focus()
        else if ($('ub04_serviceline_informations_modifier').value.match(issplchr))
            $('ub04_serviceline_informations_modifier').focus()
        else if ($('ub04_serviceline_informations_modifier2').value.match(issplchr))
            $('ub04_serviceline_informations_modifier2').focus()
        else if ($('ub04_serviceline_informations_modifier3').value.match(issplchr))
            $('ub04_serviceline_informations_modifier3').focus()
        else if ($('ub04_serviceline_informations_modifier4').value.match(issplchr))
            $('ub04_serviceline_informations_modifier4').focus()
        else if ($('ub04_serviceline_informations_service_date').value.match(issplchr))
            $('ub04_serviceline_informations_service_date').focus()
        else if ($('ub04_serviceline_informations_service_units').value.match(issplchr))
            $('ub04_serviceline_informations_service_units').focus()
        else if ($('ub04_serviceline_informations_charges').value.match(issplchr))
            $('ub04_serviceline_informations_charges').focus()
        else if ($('ub04_serviceline_informations_non_covered_charges').value.match(issplchr))
            $('ub04_serviceline_informations_non_covered_charges').focus()
        else if ($('ub04_serviceline_informations_unlabel_49').value.match(issplchr))
            $('ub04_serviceline_informations_unlabel_49').focus()
        else
            $('ub04_serviceline_informations_rev_code').focus();
        return false
    }
    else
        return true
}

function specialcharactercheck()
{
    for (i = 0; i < document.form1.elements.length; i++)
    {
        if ((document.form1.elements[i].value.match(issplchr)) && (document.form1.elements[i].name != 'batchid')&& (document.form1.elements[i].name != 'authenticity_token') && (document.form1.elements[i].name != 'view'))
        {
            alert("Special characters are not permited");
            document.form1.elements[i].focus();
            return false;
        }
//        alert(document.form1.elements[i].value)
//        alert(document.form1.elements[i].name)
    }
    return true;
}

function npilength()
{
    if ((isValidNPI($('ub04_claim_informations_billing_provider_npi').value)) == false)
    {
        $('ub04_claim_informations_billing_provider_npi').focus();
        return false;
    }
    if ((isValidNPI($('ub04_claim_informations_attending_npi').value)) == false)
    {
        $('ub04_claim_informations_attending_npi').focus();
        return false;
    }
    if ((isValidNPI($('ub04_claim_informations_operating_npi').value)) == false)
    {
        $('ub04_claim_informations_operating_npi').focus();
        return false;
    }
    if ((isValidNPI($('ub04_claim_informations_other_npi1').value)) == false)
    {
        $('ub04_claim_informations_other_npi1').focus();
        return false;
    }
    if ((isValidNPI($('ub04_claim_informations_other_npi2').value)) == false)
    {
        $('ub04_claim_informations_other_npi2').focus();
        return false;
    }

    return true;
}

function serviceline_validator(element_id)
{
        if ($F(element_id) == '')
        {
                alert("Service Line element should not be blank");
                $(element_id).focus();
                return false;
        }
        else
           return true
}

function serviceline_revcode_validator(element_id)
{
    if ($F(element_id).match((/(^\d{4}$)/)))
        return true;
    else
    {
      alert("Service line RevCode cannot be blank / should be 4 digits");
      $(element_id).focus();
      return false;
    }
}

function serviceline_futuredate()
{
    servicelinecount = serviceline_count();
    if (servicelinecount > 0)
        {
            for(i=1;i<= servicelinecount;i++){
            if(future_date($('ub04_serviceline_informations_service_date'+i).value))
                {
                    alert("Future date is not permitted");
                    $('ub04_serviceline_informations_service_date'+i).focus();
                    return false;
                }
            }
        }
     return true;
}

function formValidator(batch_type) {

    var stat = $('status');

    if (stat != null)
    {
        if ($F('status') == 'Complete')
        {

            if ((zipcode_mandatory_onsubmit()) && (mandatory(batch_type)) && (IS_billing_provider_last_name()) && (IS_patient_account_number()) && (IS_patient_last_name()) && (IS_patient_first_name()) && (IS_date_mmddyy()) && (IS_statement_from_less_equal_statement_to_future()) && (IS_occurence_from_less_equal_occurence_to_future()) && (IS_provider_id()) && (subscriber_address1_notprovided()) && (errorcheck()) && (federal_tax_id_check()) && (pay_to_provider_check()) && (dxcode_admitcode_duplication()) && (diagnosiscode_duplication()) && (IS_futuredate_creationdate()) && (specialcharactercheck()) && (npilength()) && (atleastoneserviceline()) && typeofbillvalidation() && total_charge_adder() && serviceline_futuredate())
            {
                servicelinecount = serviceline_count();
                if (servicelinecount != 0){
                var agree = confirm("Are you sure you wish to continue?");
                if (agree == true)
                    {
                        if(submitted)
                            return false;
                        else
                        {
                            submitted = true;
                            return true;
                        }
                    }
                else
                    return false;
                }
                else
                {
                    alert("Please add atleast one serviceline");
                    $('ub04_serviceline_informations_rev_code').focus();
                    return false;
                }
            }
            else
                return false
        }
        else if ($F('status') == 'Incomplete')
        {

            if (($F('qa_comm').match(/^[\s]+$/)) || ($F('qa_comm') == ""))
            {
                alert("Please enter your reason for incompleting the claim in the Comments field");
                $('qa_comm').focus();
                return false;
            }

            else if ($F('qa_comm') != "")
            {
                var status = confirm("Are You Sure you want to incomplete");
                if (status == true)
                    {
                        if(submitted)
                            return false;
                        else
                        {
                            submitted = true;
                            return true;
                        }
                    }
                else if (status == false)
                    return false;
            }

        }
        else if ($F('status') == 'Reject')
        {
            var agreereject = confirm("Are you sure you want to reject?");
            if (agreereject == true)
                {
                    if(submitted)
                        return false;
                    else
                    {
                        submitted = true;
                        return true;
                    }
                }
            else
                return false;
        }
    }

    else
    {
        if ((zipcode_mandatory_onsubmit()) && (mandatory(batch_type)) && (IS_billing_provider_last_name()) && (IS_patient_account_number()) && (IS_patient_last_name()) && (IS_patient_first_name()) && (IS_date_mmddyy()) && (IS_statement_from_less_equal_statement_to_future()) && (IS_occurence_from_less_equal_occurence_to_future()) && (IS_provider_id()) && (subscriber_address1_notprovided()) && (errorcheck()) && (federal_tax_id_check()) && (pay_to_provider_check()) && (dxcode_admitcode_duplication()) && (diagnosiscode_duplication()) && (IS_futuredate_creationdate()) && (specialcharactercheck()) && (npilength()) && (atleastoneserviceline()) && typeofbillvalidation() && total_charge_adder() && serviceline_futuredate())
        {
            if ($('view')!= null)
            servicelinecount = serviceline_count();
        else
            servicelinecount = rowcount;
                if (servicelinecount != 0){
            var agree = confirm("Are you sure you wish to continue?");
            if (agree == true)
                {
                    if(submitted)
                        return false;
                    else
                    {
                        submitted = true;
                        return true;
                    }
                }
            else
                return false;
        }
        else
                {
                    alert("Please add atleast one serviceline");
                    $('ub04_serviceline_informations_rev_code').focus();
                    return false;
                }
        }
        else
            return false
    }
}

function formvalidator_completedclaims_ub04(batch_type)
{
     if ((zipcode_mandatory_onsubmit()) && (mandatory(batch_type)) && (IS_billing_provider_last_name()) && (IS_patient_account_number()) && (IS_patient_last_name()) && (IS_patient_first_name()) && total_charge_adder() && (IS_date_mmddyy()) && (IS_statement_from_less_equal_statement_to_future()) && (IS_occurence_from_less_equal_occurence_to_future()) && (IS_provider_id()) && (subscriber_address1_notprovided()) && (federal_tax_id_check()) && (pay_to_provider_check()) && (dxcode_admitcode_duplication()) && (diagnosiscode_duplication()) && (IS_futuredate_creationdate()) && (specialcharactercheck()) && (npilength()) && typeofbillvalidation() && serviceline_futuredate() )
        {
             servicelinecount = serviceline_count();
                if (servicelinecount != 0){
            var agree = confirm("Are you sure you wish to continue?");
            if (agree == true)
                {
                    if(submitted)
                        return false;
                    else
                    {
                        submitted = true;
                        return true;
                    }
                }
            else
                return false;
        }
        else
                {
                    alert("Please add atleast one serviceline");
                    $('ub04_serviceline_informations_rev_code').focus();
                    return false;
                }
        }
        else
            return false
}


function addRow(id) {
    if (service_line_service_date() && (service_line_blank_validator()) && (service_line_validator()) && (rev_code()) && hcpcs_prompt() && specialcharactercheck_svc()) {
        rowcount ++;
        count ++;
        count1 ++;

        if (count <= 1000) {
            addServiceLine(id);
        } else {
            alert('You are Exceeds the Limit')

        }
    }
}

function serviceline_count()
{
    if ($('view')!= null){
        var servicelinecount = $('svc_count').value;
        return servicelinecount;
    }else{
        return 0;
    }

}

function addServiceLine(id) {
    servicelinecount = serviceline_count();
    if ($('view')!= null){
        rowcount = parseInt(servicelinecount)+1
    }
    document.getElementById(1700).value = count
    document.getElementById(1800).value = rowcount
    newcount = count
    newcount1 = count1
    var tbody = document.getElementById(id).getElementsByTagName("TBODY")[0];
    var row = document.createElement("TR")
    row.setAttribute('id', rowcount);
    
    var td = document.createElement("TD")
    var div = document.createElement("DIV")
    div.setAttribute('id',"svc_num_"+rowcount+"")
    radioInput = document.createElement('INPUT')
    radioInput.type = 'radio'
    radioInput.setAttribute('name',"radioInput")
    radioInput.setAttribute('id',"radioInput_"+rowcount+"")
    radioInput.setAttribute('value',"radioInput-"+rowcount+"")
    radioInput.className = "radiobtn"
    if ($('view')== null){
    div.appendChild(document.createTextNode(count))}
    else{
    div.appendChild(document.createTextNode((parseInt(servicelinecount)+1)))
    $('svc_count').value = parseInt(servicelinecount)+1;
}
    td.appendChild(div)
    if ($('view')== null){
    td.appendChild(radioInput)}
    row.appendChild(td);

    var td1 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    ep = document.getElementById('ub04_serviceline_informations_rev_code').value
    textField.setAttribute('width', '42')
    textField.setAttribute('value', ep)
    textField.setAttribute('id', "ub04_serviceline_informations_rev_code" + rowcount + "")
    textField.setAttribute('name', "ub04_serviceline_informations[rev_code" + rowcount + "]")
    textField.setAttribute('size', '4')
    textField.className = "black_text"
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}

    td1.appendChild(textField)
    row.appendChild(td1);


    var td2 = document.createElement("TD")

    textField = document.createElement('INPUT')
    textField.type = 'text'
    ep = document.getElementById('ub04_serviceline_informations_description').value
    textField.setAttribute('width', '210')
    textField.setAttribute('value', ep)
    textField.setAttribute('id', "ub04_serviceline_informations_description" + rowcount + "")
    textField.setAttribute('name', "ub04_serviceline_informations[description" + rowcount + "]")
    textField.setAttribute('size', '20')
    textField.className = "black_text"
   // if ($('view')== null){
    textField.setAttribute('readOnly', true)
//}

    td2.appendChild(textField)
    row.appendChild(td2);


    var td3 = document.createElement("TD")

    textField1 = document.createElement('INPUT')
    textField1.type = 'text'
    hcpcs = document.getElementById('ub04_serviceline_informations_hcpcs').value
    textField1.setAttribute('width', '40')
    textField1.setAttribute('value', hcpcs)
    textField1.setAttribute('id', "ub04_serviceline_informations_hcpcs" + rowcount + "")
    textField1.setAttribute('name', "ub04_serviceline_informations[hcpcs" + rowcount + "]")
    textField1.setAttribute('size', '4')
    textField1.className = "black_text"
    if ($('view')== null){
    textField1.setAttribute('readOnly', true)}
    td3.appendChild(textField1)

    textField2 = document.createElement('INPUT')
    textField2.type = 'text'
    rates = document.getElementById('ub04_serviceline_informations_rates').value
    textField2.setAttribute('width', '40')
    textField2.setAttribute('value', rates)
    textField2.setAttribute('id', "ub04_serviceline_informations_rates" + rowcount + "")
    textField2.setAttribute('name', "ub04_serviceline_informations[rates" + rowcount + "]")
    textField2.setAttribute('size', '4')
    textField2.className = "black_text"
    if ($('view')== null){
    textField2.setAttribute('readOnly', true)}
    td3.appendChild(textField2)

    textField3 = document.createElement('INPUT')
    textField3.type = 'text'
    hipps_codes = document.getElementById('ub04_serviceline_informations_hipps_codes').value
    textField3.setAttribute('width', '40')
    textField3.setAttribute('value', hipps_codes)
    textField3.setAttribute('id', "ub04_serviceline_informations_hipps_codes" + rowcount + "")
    textField3.setAttribute('name', "ub04_serviceline_informations[hipps_codes" + rowcount + "]")
    textField3.setAttribute('size', '4')
    textField3.className = "black_text"
    if ($('view')== null){
    textField3.setAttribute('readOnly', true)}
    td3.appendChild(textField3)

    textField3 = document.createElement('INPUT')
    textField3.type = 'text'
    modifier_codes = document.getElementById('ub04_serviceline_informations_modifier').value
    textField3.setAttribute('width', '40')
    textField3.setAttribute('value', modifier_codes)
    textField3.setAttribute('id', "ub04_serviceline_informations_modifier1" + rowcount + "")
    textField3.setAttribute('name', "ub04_serviceline_informations[modifier1" + rowcount + "]")
    textField3.setAttribute('size', '1')
    textField3.className = "black_text"
    if ($('view')== null){
    textField3.setAttribute('readOnly', true)}
    td3.appendChild(textField3)

    textField3 = document.createElement('INPUT')
    textField3.type = 'text'
    modifier_codes = document.getElementById('ub04_serviceline_informations_modifier2').value
    textField3.setAttribute('width', '40')
    textField3.setAttribute('value', modifier_codes)
    textField3.setAttribute('id', "ub04_serviceline_informations_modifier2" + rowcount + "")
    textField3.setAttribute('name', "ub04_serviceline_informations[modifier2" + rowcount + "]")
    textField3.setAttribute('size', '1')
    textField3.className = "black_text"
    if ($('view')== null){
    textField3.setAttribute('readOnly', true)}
    td3.appendChild(textField3)

    textField3 = document.createElement('INPUT')
    textField3.type = 'text'
    modifier_codes = document.getElementById('ub04_serviceline_informations_modifier3').value
    textField3.setAttribute('width', '40')
    textField3.setAttribute('value', modifier_codes)
    textField3.setAttribute('id', "ub04_serviceline_informations_modifier3" + rowcount + "")
    textField3.setAttribute('name', "ub04_serviceline_informations[modifier3" + rowcount + "]")
    textField3.setAttribute('size', '1')
    textField3.className = "black_text"
    if ($('view')== null){
    textField3.setAttribute('readOnly', true)}
    td3.appendChild(textField3)

    textField3 = document.createElement('INPUT')
    textField3.type = 'text'
    modifier_codes = document.getElementById('ub04_serviceline_informations_modifier4').value
    textField3.setAttribute('width', '40')
    textField3.setAttribute('value', modifier_codes)
    textField3.setAttribute('id', "ub04_serviceline_informations_modifier4" + rowcount + "")
    textField3.setAttribute('name', "ub04_serviceline_informations[modifier4" + rowcount + "]")
    textField3.setAttribute('size', '1')
    textField3.className = "black_text"
    if ($('view')== null){
    textField3.setAttribute('readOnly', true)}
    td3.appendChild(textField3)

    row.appendChild(td3);


    var td4 = document.createElement("TD")

    textField = document.createElement('INPUT')
    textField.type = 'text'
    servicedate = document.getElementById('ub04_serviceline_informations_service_date').value
    textField.setAttribute('width', '60')
    textField.setAttribute('value', servicedate)
    textField.setAttribute('id', "ub04_serviceline_informations_service_date" + rowcount + "")
    textField.setAttribute('name', "ub04_serviceline_informations[service_date" + rowcount + "]")
    textField.setAttribute('size', '9')
    textField.className = "black_text"
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}

    td4.appendChild(textField)
    row.appendChild(td4);


    var td5 = document.createElement("TD")

    textField = document.createElement('INPUT')
    textField.type = 'text'
    serviceunits = document.getElementById('ub04_serviceline_informations_service_units').value
    textField.setAttribute('width', '40')
    textField.setAttribute('value', serviceunits)
    textField.setAttribute('id', "ub04_serviceline_informations_service_units" + rowcount + "")
    textField.setAttribute('name', "ub04_serviceline_informations[service_units" + rowcount + "]")
    textField.setAttribute('size', '5')
    textField.className = "black_text"
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}

    td5.appendChild(textField)
    row.appendChild(td5);


    var td6 = document.createElement("TD")

    textField = document.createElement('INPUT')
    textField.type = 'text'
    infcharges = document.getElementById('ub04_serviceline_informations_charges').value
    textField.setAttribute('width', '67')
    textField.setAttribute('value', infcharges)
    textField.setAttribute('id', "ub04_serviceline_informations_charges" + rowcount + "")
    textField.setAttribute('name', "ub04_serviceline_informations[charges" + rowcount + "]")
    textField.setAttribute('size', '10')
    textField.className = "black_text"
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}

    td6.appendChild(textField)
    row.appendChild(td6);


    var td7 = document.createElement("TD")

    textField = document.createElement('INPUT')
    textField.type = 'text'
    noncovcharges = document.getElementById('ub04_serviceline_informations_non_covered_charges').value
    textField.setAttribute('width', '67')
    textField.setAttribute('value', noncovcharges)
    textField.setAttribute('id', "ub04_serviceline_informations_non_covered_charges" + rowcount + "")
    textField.setAttribute('name', "ub04_serviceline_informations[non_covered_charges" + rowcount + "]")
    textField.setAttribute('size', '10')
    textField.className = "black_text"
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}

    td7.appendChild(textField)
    row.appendChild(td7);


    var td8 = document.createElement("TD")

    textField = document.createElement('INPUT')
    textField.type = 'text'
    infcharges = document.getElementById('ub04_serviceline_informations_unlabel_49').value
    textField.setAttribute('width', '40')
    textField.setAttribute('value', infcharges)
    textField.setAttribute('id', "ub04_serviceline_informations_unlabel_49_" + rowcount + "")
    textField.setAttribute('name', "ub04_serviceline_informations[unlabel_49_" + rowcount + "]")
    textField.setAttribute('size', '4')
    textField.className = "black_text"
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}

    td8.appendChild(textField)
    row.appendChild(td8);

if ($('view')!= null){
    var removesvc = document.createElement("TD");

    remove = document.createElement('input');
    remove.type = 'button';
    remove.setAttribute('name', "removesvc" + rowcount + "");
    remove.setAttribute('id', "removesvc_" + rowcount + "");
    remove.value = "Remove";
    remove.className = "black_text";
    remove.onclick = function removeAddedRowQa()
    {
        row_id = this.id;
        num = row_id.split("_");
           sline_no = num[1]
            var e1 = document.getElementById(sline_no);
                e1.parentNode.removeChild(e1);

                $('svc_count').value = ($('svc_count').value) - 1
    }
    removesvc.appendChild(remove);
    row.appendChild(removesvc);
}


// var editsvc = document.createElement("TD")
//
//    edit = document.createElement('input')
//    edit.type = 'button'
//    edit.setAttribute('name', "editsvc" + count + "")
//    edit.setAttribute('id', "editsvc_" + count + "");
//    edit.value = "Edit"
//    edit.className = "black_text"
//    edit.onclick = unfreeze;
//    editsvc.appendChild(edit)
//    row.appendChild(editsvc);
//
//    var updatesvc = document.createElement("TD")
//
//    update = document.createElement('input')
//    update.type = 'button'
//    update.setAttribute('name', "updatesvc" + count + "")
//    update.setAttribute('id', "updatesvc_" + count + "")
//    update.value = "Update"
//    update.className = "black_text"
//    update.onclick = updateaddedservicelines;
//    updatesvc.appendChild(update)
//    row.appendChild(updatesvc);
//
//    var removesvc = document.createElement("TD")
//
//    remove = document.createElement('input')
//    remove.type = 'button'
//    remove.setAttribute('name', "removesvc" + count + "")
//    remove.setAttribute('id', "removesvc_" + count + "")
//    remove.onclick = removeaddedrow;
//    remove.value = "Remove"
//    remove.className = "black_text"
//    removesvc.appendChild(remove)
//    row.appendChild(removesvc);
//
    tbody.appendChild(row);

// TOTAL CHARGE ADDITION
//    sum = sum + parseFloat(($("ub04_serviceline_informations_charges").value))
//    $('ub04_claim_informations_total_charges').value = sum;
}



  function freeze(svc_num)
{
     $('ub04_serviceline_informations_rev_code'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_hcpcs'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_rates'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_hipps_codes'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_modifier1'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_modifier2'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_modifier3'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_modifier4'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_service_date'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_service_units'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_charges'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_non_covered_charges'+svc_num).readOnly = true;
    $('ub04_serviceline_informations_unlabel_49_'+svc_num).readOnly = true;
    undohighlight(svc_num)
    $('radioInput_'+svc_num).focus();
return true
}

function service_line_blank_validator_svc(svc_num)
{
    if ($('ub04_serviceline_informations_charges'+svc_num).value != '' && $('ub04_serviceline_informations_rev_code'+svc_num).value != '' && $('ub04_serviceline_informations_service_units'+svc_num).value != '')
        return true;

    else if ($('ub04_serviceline_informations_charges'+svc_num).value == '')
    {
        alert("Enter the serviceline with RevCode,Service Units,Charges")
        $('ub04_serviceline_informations_charges'+svc_num).focus()
        $('ub04_serviceline_informations_charges'+svc_num).highlight()

        return false;
    }
    else if ($('ub04_serviceline_informations_rev_code'+svc_num).value == '')
    {
        alert("Enter the serviceline with RevCode,Service Units,Charges")
        $('ub04_serviceline_informations_rev_code'+svc_num).focus()
        $('ub04_serviceline_informations_rev_code'+svc_num).highlight()

        return false;
    }
    else if ($('ub04_serviceline_informations_service_units'+svc_num).value == '')
    {
        alert("Enter the serviceline with RevCode,Service Units,Charges")
        $('ub04_serviceline_informations_service_units'+svc_num).focus()
        $('ub04_serviceline_informations_service_units'+svc_num).highlight()

        return false;
    }
}

function service_line_validator_svc(svc_num)
{
    if (($('ub04_serviceline_informations_charges'+svc_num).value != "") && !($('ub04_serviceline_informations_charges'+svc_num).value.match(decimalamount)))
    {
        alert("Enter numeric value")
        $('ub04_serviceline_informations_charges'+svc_num).focus()
        $('ub04_serviceline_informations_charges'+svc_num).highlight()
        return false
    }
    else
        return true
}

function rev_code_svc(svc_num)
{
    if (!($('ub04_serviceline_informations_rev_code'+svc_num).value.match(revenue_code)) && ($('ub04_serviceline_informations_rev_code'+svc_num).value) != "")
    {
        alert("Revenue Code should be 4 digits");
        $('ub04_serviceline_informations_rev_code'+svc_num).focus()
        $('ub04_serviceline_informations_rev_code'+svc_num).highlight()
        return false
    }
    return true
}

function hcpcs_prompt_svc(svc_num)
{
    if ((($('ub04_serviceline_informations_hcpcs'+svc_num).value != '')) && (!($('ub04_serviceline_informations_hcpcs'+svc_num).value.match(hcpcs_code))))
    {
        alert("Hcpcs code should be 5 characters");
        $('ub04_serviceline_informations_hcpcs'+svc_num).focus();
        $('ub04_serviceline_informations_hcpcs'+svc_num).highlight();
        return false
    }
    else
        return true
}

function service_line_service_date_svc(svc_num)
{

    if (!($('ub04_serviceline_informations_service_date'+svc_num).value.match(mmddyyyy)) && ($('ub04_serviceline_informations_service_date'+svc_num).value) != "")
    {
        alert("Please enter a valid date, year must be greater than 1900");
        $('ub04_serviceline_informations_service_date'+svc_num).focus()
        $('ub04_serviceline_informations_service_date'+svc_num).highlight()
        return false
    }
    else if (($('ub04_serviceline_informations_service_date'+svc_num).value.match(mmddyyyy)) && (($('ub04_serviceline_informations_service_date'+svc_num).value) != ""))
    {
        if (future_date($('ub04_serviceline_informations_service_date'+svc_num).value))
        {
             alert("Future date is not permitted");
                    $('ub04_serviceline_informations_service_date'+svc_num).focus()
                    $('ub04_serviceline_informations_service_date'+svc_num).highlight()
                        return false;
//            agreefuturedate = confirm("You entered a future date. Are you sure to continue?")
//            if(agreefuturedate == true)
//                return true
//            else
//                {
//                    $('ub04_serviceline_informations_service_date').focus()
//                    $('ub04_serviceline_informations_service_date').highlight()
//                    return false
//                }
        }
        else
        {
            month = $('ub04_serviceline_informations_service_date'+svc_num).value.slice(0,2);
            day = $('ub04_serviceline_informations_service_date'+svc_num).value.slice(2,4);
            year = $('ub04_serviceline_informations_service_date'+svc_num).value.slice(4,8);
            threeMonthsPrior = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
            input_date = new Date(year, month, day)
            if(input_date >= threeMonthsPrior)
                  return true
            else
            {
                agree = confirm('Date you entered needs to be confirmed. Are you sure to continue?');
                if(agree == true)
                    return true
                else
                {
                 $('ub04_serviceline_informations_service_date'+svc_num).focus()
                    return false
            }
        }
        }

    }
    return true
}

function updateaddedservicelines()

{
//    checked_radiobutton = $$('input:checked[type="radio"][name="radioInput"]').pluck('value');
checked_radiobutton = getRadioGroupSelectedValue('radioInput')

        if(checked_radiobutton == '')
            alert("Please select a serviceline");
        else
        {
            num = checked_radiobutton.split("-")
            svc_num = num[1]
            if($('ub04_serviceline_informations_rev_code'+svc_num).readOnly == true)
               {
                   alert("Please do remember to EDIT the serviceline before UPDATE");
                   return false;
               }
               else
                   {

                   modifier = 'ub04_serviceline_informations_modifier1'+svc_num
                   modifier2 = 'ub04_serviceline_informations_modifier2'+svc_num
                   modifier3 = 'ub04_serviceline_informations_modifier3'+svc_num
                   modifier4 = 'ub04_serviceline_informations_modifier4'+svc_num
            if(service_line_blank_validator_svc(svc_num) && service_line_validator_svc(svc_num) && rev_code_svc(svc_num) && hcpcs_prompt_svc(svc_num) && service_line_service_date_svc(svc_num) && validate_modifier(modifier) && validate_modifier(modifier2) && validate_modifier(modifier3) && validate_modifier(modifier4) && freeze(svc_num) && enablebuttons())
                return true
            else
                return false
                   }
        }
}

function disablebuttons()
{
    alert("Please update the editted serviceline before accessing any other fields");
    $('svc_remove_btn').disabled = true;
    $('svc_edit_btn').disabled = true;
    $('claim_save_btn').disabled = true;
    $('claim_incomplete_btn').disabled = true;
    $('claim_complete_btn').disabled = true;
    $('svc_add_btn').disabled = true;

}
function enablebuttons()
{
    $('svc_remove_btn').disabled = false;
    $('svc_edit_btn').disabled = false;
    $('claim_save_btn').disabled = false;
    $('claim_incomplete_btn').disabled = false;
    $('claim_complete_btn').disabled = false;
    $('svc_add_btn').disabled = false;
}

function highlightsvc(svcnum)
{
    $('ub04_serviceline_informations_rev_code'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_hcpcs'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_rates'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_hipps_codes'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_modifier1'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_modifier2'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_modifier3'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_modifier4'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_service_date'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_service_units'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_charges'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_non_covered_charges'+svcnum).className = "highlightevc";
    $('ub04_serviceline_informations_unlabel_49_'+svcnum).className = "highlightevc";
}

function undohighlight(svcnum)
{
    $('ub04_serviceline_informations_rev_code'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_hcpcs'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_rates'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_hipps_codes'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_modifier1'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_modifier2'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_modifier3'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_modifier4'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_service_date'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_service_units'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_charges'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_non_covered_charges'+svcnum).className = "black_text";
    $('ub04_serviceline_informations_unlabel_49_'+svcnum).className = "black_text";
}

function getRadioGroupSelectedElement(radioGroupName) {

var radioGroup = document.getElementsByName(radioGroupName);
var radioElement = (radioGroup.length)-1;
for(radioElement; radioElement >= 0; radioElement--) {
    if(radioGroup[radioElement].checked){
        return radioGroup[radioElement];
    }
}
return false;
}

function getRadioGroupSelectedValue(radioGroupName) {

var selectedRadio = getRadioGroupSelectedElement(radioGroupName);
if (selectedRadio !== false) {
    return selectedRadio.value;
}
return false;
}

   function unfreeze()
{
//    checked_radiobutton = $$('input:checked[type="radio"][name="radioInput"]').pluck('value');
checked_radiobutton = getRadioGroupSelectedValue('radioInput')

        if(checked_radiobutton == '')
            alert("Please select a serviceline");
        else
        {
            num = checked_radiobutton.split("-")
            svc_num = num[1]
            $('ub04_serviceline_informations_rev_code'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_hcpcs'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_rates'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_hipps_codes'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_modifier1'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_modifier2'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_modifier3'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_modifier4'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_service_date'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_service_units'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_charges'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_non_covered_charges'+svc_num).readOnly = false;
            $('ub04_serviceline_informations_unlabel_49_'+svc_num).readOnly = false;
            disablebuttons()
            highlightsvc(svc_num)
            $('ub04_serviceline_informations_rev_code'+svc_num).focus()
        }
}

function removeaddedrow()
{

//checked_radiobutton = $$('input:checked[type="radio"][name="radioInput"]').pluck('value');
checked_radiobutton = getRadioGroupSelectedValue('radioInput')
    if(checked_radiobutton == '')
         alert("Please select a serviceline");
    else
    {
agree = confirm("Are you sure deleting this row")

if (agree == true)
    {
    num = checked_radiobutton.split("-")
    row_to_remove = num[1]
// TOTAL CHARGE DEDECTION
//    sum = sum - parseFloat(($("ub04_serviceline_informations_charges" + row_to_remove + "").value))
//    $('ub04_claim_informations_total_charges').value = sum;
    e1 = $(row_to_remove);
    e1.parentNode.removeChild(e1);
    newcount = newcount - 1
    count = newcount
    newcount1 = newcount1 - 1
    count1 = newcount1
    document.getElementById(1700).value = count
    iterateSvcNumber(rowcount);
    }
    else
        return true;
    }
}

function iterateSvcNumber(tot_svc_num)
{
    var j = 1
    for(var i=1;i<=tot_svc_num;i++)
        {
            if($('svc_num_'+i)!= null)
                {
                     $('svc_num_'+i).innerHTML = j;
                     j += 1
                }
        }
}
//function removeRow()
//{
//    agree = confirm("Are you sure deleting the last row")
//
//if (agree == true)
//    {
//    sum = sum - parseFloat(($("ub04_serviceline_informations_charges" + newcount + "").value))
//    $('ub04_claim_informations_total_charges').value = sum;
//
//    var e1 = document.getElementById(newcount);
//    e1.parentNode.removeChild(e1);
//
//    newcount = newcount - 1
//    //count1 = count1-1
//    count = newcount
//    newcount1 = newcount1 - 1
//    count1 = newcount1
//    document.getElementById(1700).value = count
// }
//    else
//        return true;
//}

function typeofbillvalidation() {
    flag = 0;
    bill_type_arr = new Array('0110','0111','0112','0113','0114','0115','0116','0117','0118','0119','011A','011B','011C','011D','011E','011F','011G','011H','011I','011J','011K','011M','011N','011O','011X','011Y','011Z','0120','0121','0122','0123','0124','0125','0126','0127','0128','0129','012A','012B','012C','012D','012E','012F','012G','012H','012I','012J','012K','012M','012N','012O','012X','012Y','012Z','0130','0131','0132','0133','0134','0135','0136','0137','0138','0139','013A','013B','013C','013D','013E','013F','013G','013H','013I','013J','013K','013M','013N','013O','013X','013Y','013Z','0140','0141','0142','0143','0144','0145','0146','0147','0148','0149','014A','014B','014C','014D','014E','014F','014G','014H','014I','014J','014K','014M','014N','014O','014X','014Y','014Z','0150','0151','0152','0153','0154','0155','0156','0157','0158','0159','015A','015B','015C','015D','015E','015F','015G','015H','015I','015J','015K','015M','015N','015O','015X','015Y','015Z','0160','0161','0162','0163','0164','0165','0166','0167','0168','0169','016A','016B','016C','016D','016E','016F','016G','016H','016I','016J','016K','016M','016N','016O','016X','016Y','016Z','0170','0171','0172','0173','0174','0175','0176','0177','0178','0179','017A','017B','017C','017D','017E','017F','017G','017H','017I','017J','017K','017M','017N','017O','017X','017Y','017Z','0180','0181','0182','0183','0184','0185','0186','0187','0188','0189','018A','018B','018C','018D','018E','018F','018G','018H','018I','018J','018K','018M','018N','018O','018X','018Y','018Z','0190','0191','0192','0193','0194','0195','0196','0197','0198','0199','019A','019B','019C','019D','019E','019F','019G','019H','019I','019J','019K','019M','019N','019O','019X','019Y','019Z','0210','0211','0212','0213','0214','0215','0216','0217','0218','0219','021A','021B','021C','021D','021E','021F','021G','021H','021I','021J','021K','021M','021N','021O','021X','021Y','021Z','0220','0221','0222','0223','0224','0225','0226','0227','0228','0229','022A','022B','022C','022D','022E','022F','022G','022H','022I','022J','022K','022M','022N','022O','022X','022Y','022Z','0230','0231','0232','0233','0234','0235','0236','0237','0238','0239','023A','023B','023C','023D','023E','023F','023G','023H','023I','023J','023K','023M','023N','023O','023X','023Y','023Z','0240','0241','0242','0243','0244','0245','0246','0247','0248','0249','024A','024B','024C','024D','024E','024F','024G','024H','024I','024J','024K','024M','024N','024O','024X','024Y','024Z','0250','0251','0252','0253','0254','0255','0256','0257','0258','0259','025A','025B','025C','025D','025E','025F','025G','025H','025I','025J','025K','025M','025N','025O','025X','025Y','025Z','0260','0261','0262','0263','0264','0265','0266','0267','0268','0269','026A','026B','026C','026D','026E','026F','026G','026H','026I','026J','026K','026M','026N','026O','026X','026Y','026Z','0270','0271','0272','0273','0274','0275','0276','0277','0278','0279','027A','027B','027C','027D','027E','027F','027G','027H','027I','027J','027K','027M','027N','027O','027X','027Y','027Z','0280','0281','0282','0283','0284','0285','0286','0287','0288','0289','028A','028B','028C','028D','028E','028F','028G','028H','028I','028J','028K','028M','028N','028O','028X','028Y','028Z','0290','0291','0292','0293','0294','0295','0296','0297','0298','0299','029A','029B','029C','029D','029E','029F','029G','029H','029I','029J','029K','029M','029N','029O','029X','029Y','029Z','0310','0311','0312','0313','0314','0315','0316','0317','0318','0319','031A','031B','031C','031D','031E','031F','031G','031H','031I','031J','031K','031M','031N','031O','031X','031Y','031Z','0320','0321','0322','0323','0324','0325','0326','0327','0328','0329','032A','032B','032C','032D','032E','032F','032G','032H','032I','032J','032K','032M','032N','032O','032X','032Y','032Z','0330','0331','0332','0333','0334','0335','0336','0337','0338','0339','033A','033B','033C','033D','033E','033F','033G','033H','033I','033J','033K','033M','033N','033O','033X','033Y','033Z','0340','0341','0342','0343','0344','0345','0346','0347','0348','0349','034A','034B','034C','034D','034E','034F','034G','034H','034I','034J','034K','034M','034N','034O','034X','034Y','034Z','0350','0351','0352','0353','0354','0355','0356','0357','0358','0359','035A','035B','035C','035D','035E','035F','035G','035H','035I','035J','035K','035M','035N','035O','035X','035Y','035Z','0360','0361','0362','0363','0364','0365','0366','0367','0368','0369','036A','036B','036C','036D','036E','036F','036G','036H','036I','036J','036K','036M','036N','036O','036X','036Y','036Z','0370','0371','0372','0373','0374','0375','0376','0377','0378','0379','037A','037B','037C','037D','037E','037F','037G','037H','037I','037J','037K','037M','037N','037O','037X','037Y','037Z','0380','0381','0382','0383','0384','0385','0386','0387','0388','0389','038A','038B','038C','038D','038E','038F','038G','038H','038I','038J','038K','038M','038N','038O','038X','038Y','038Z','0390','0391','0392','0393','0394','0395','0396','0397','0398','0399','039A','039B','039C','039D','039E','039F','039G','039H','039I','039J','039K','039M','039N','039O','039X','039Y','039Z','0410','0411','0412','0413','0414','0415','0416','0417','0418','0419','041A','041B','041C','041D','041E','041F','041G','041H','041I','041J','041K','041M','041N','041O','041X','041Y','041Z','0420','0421','0422','0423','0424','0425','0426','0427','0428','0429','042A','042B','042C','042D','042E','042F','042G','042H','042I','042J','042K','042M','042N','042O','042X','042Y','042Z','0430','0431','0432','0433','0434','0435','0436','0437','0438','0439','043A','043B','043C','043D','043E','043F','043G','043H','043I','043J','043K','043M','043N','043O','043X','043Y','043Z','0440','0441','0442','0443','0444','0445','0446','0447','0448','0449','044A','044B','044C','044D','044E','044F','044G','044H','044I','044J','044K','044M','044N','044O','044X','044Y','044Z','0450','0451','0452','0453','0454','0455','0456','0457','0458','0459','045A','045B','045C','045D','045E','045F','045G','045H','045I','045J','045K','045M','045N','045O','045X','045Y','045Z','0460','0461','0462','0463','0464','0465','0466','0467','0468','0469','046A','046B','046C','046D','046E','046F','046G','046H','046I','046J','046K','046M','046N','046O','046X','046Y','046Z','0470','0471','0472','0473','0474','0475','0476','0477','0478','0479','047A','047B','047C','047D','047E','047F','047G','047H','047I','047J','047K','047M','047N','047O','047X','047Y','047Z','0480','0481','0482','0483','0484','0485','0486','0487','0488','0489','048A','048B','048C','048D','048E','048F','048G','048H','048I','048J','048K','048M','048N','048O','048X','048Y','048Z','0490','0491','0492','0493','0494','0495','0496','0497','0498','0499','049A','049B','049C','049D','049E','049F','049G','049H','049I','049J','049K','049M','049N','049O','049X','049Y','049Z','0510','0511','0512','0513','0514','0515','0516','0517','0518','0519','051A','051B','051C','051D','051E','051F','051G','051H','051I','051J','051K','051M','051N','051O','051X','051Y','051Z','0520','0521','0522','0523','0524','0525','0526','0527','0528','0529','052A','052B','052C','052D','052E','052F','052G','052H','052I','052J','052K','052M','052N','052O','052X','052Y','052Z','0530','0531','0532','0533','0534','0535','0536','0537','0538','0539','053A','053B','053C','053D','053E','053F','053G','053H','053I','053J','053K','053M','053N','053O','053X','053Y','053Z','0540','0541','0542','0543','0544','0545','0546','0547','0548','0549','054A','054B','054C','054D','054E','054F','054G','054H','054I','054J','054K','054M','054N','054O','054X','054Y','054Z','0550','0551','0552','0553','0554','0555','0556','0557','0558','0559','055A','055B','055C','055D','055E','055F','055G','055H','055I','055J','055K','055M','055N','055O','055X','055Y','055Z','0560','0561','0562','0563','0564','0565','0566','0567','0568','0569','056A','056B','056C','056D','056E','056F','056G','056H','056I','056J','056K','056M','056N','056O','056X','056Y','056Z','0570','0571','0572','0573','0574','0575','0576','0577','0578','0579','057A','057B','057C','057D','057E','057F','057G','057H','057I','057J','057K','057M','057N','057O','057X','057Y','057Z','0580','0581','0582','0583','0584','0585','0586','0587','0588','0589','058A','058B','058C','058D','058E','058F','058G','058H','058I','058J','058K','058M','058N','058O','058X','058Y','058Z','0590','0591','0592','0593','0594','0595','0596','0597','0598','0599','059A','059B','059C','059D','059E','059F','059G','059H','059I','059J','059K','059M','059N','059O','059X','059Y','059Z','0610','0611','0612','0613','0614','0615','0616','0617','0618','0619','061A','061B','061C','061D','061E','061F','061G','061H','061I','061J','061K','061M','061N','061O','061X','061Y','061Z','0620','0621','0622','0623','0624','0625','0626','0627','0628','0629','062A','062B','062C','062D','062E','062F','062G','062H','062I','062J','062K','062M','062N','062O','062X','062Y','062Z','0630','0631','0632','0633','0634','0635','0636','0637','0638','0639','063A','063B','063C','063D','063E','063F','063G','063H','063I','063J','063K','063M','063N','063O','063X','063Y','063Z','0640','0641','0642','0643','0644','0645','0646','0647','0648','0649','064A','064B','064C','064D','064E','064F','064G','064H','064I','064J','064K','064M','064N','064O','064X','064Y','064Z','0650','0651','0652','0653','0654','0655','0656','0657','0658','0659','065A','065B','065C','065D','065E','065F','065G','065H','065I','065J','065K','065M','065N','065O','065X','065Y','065Z','0660','0661','0662','0663','0664','0665','0666','0667','0668','0669','066A','066B','066C','066D','066E','066F','066G','066H','066I','066J','066K','066M','066N','066O','066X','066Y','066Z','0670','0671','0672','0673','0674','0675','0676','0677','0678','0679','067A','067B','067C','067D','067E','067F','067G','067H','067I','067J','067K','067M','067N','067O','067X','067Y','067Z','0680','0681','0682','0683','0684','0685','0686','0687','0688','0689','068A','068B','068C','068D','068E','068F','068G','068H','068I','068J','068K','068M','068N','068O','068X','068Y','068Z','0690','0691','0692','0693','0694','0695','0696','0697','0698','0699','069A','069B','069C','069D','069E','069F','069G','069H','069I','069J','069K','069M','069N','069O','069X','069Y','069Z','0710','0711','0712','0713','0714','0715','0716','0717','0718','0719','071A','071B','071C','071D','071E','071F','071G','071H','071I','071J','071K','071M','071N','071O','071X','071Y','071Z','0720','0721','0722','0723','0724','0725','0726','0727','0728','0729','072A','072B','072C','072D','072E','072F','072G','072H','072I','072J','072K','072M','072N','072O','072X','072Y','072Z','0730','0731','0732','0733','0734','0735','0736','0737','0738','0739','073A','073B','073C','073D','073E','073F','073G','073H','073I','073J','073K','073M','073N','073O','073X','073Y','073Z','0740','0741','0742','0743','0744','0745','0746','0747','0748','0749','074A','074B','074C','074D','074E','074F','074G','074H','074I','074J','074K','074M','074N','074O','074X','074Y','074Z','0750','0751','0752','0753','0754','0755','0756','0757','0758','0759','075A','075B','075C','075D','075E','075F','075G','075H','075I','075J','075K','075M','075N','075O','075X','075Y','075Z','0760','0761','0762','0763','0764','0765','0766','0767','0768','0769','076A','076B','076C','076D','076E','076F','076G','076H','076I','076J','076K','076M','076N','076O','076X','076Y','076Z','0790','0791','0792','0793','0794','0795','0796','0797','0798','0799','079A','079B','079C','079D','079E','079F','079G','079H','079I','079J','079K','079M','079N','079O','079X','079Y','079Z','0810','0811','0812','0813','0814','0815','0816','0817','0818','0819','081A','081B','081C','081D','081E','081F','081G','081H','081I','081J','081K','081M','081N','081O','081X','081Y','081Z','0820','0821','0822','0823','0824','0825','0826','0827','0828','0829','082A','082B','082C','082D','082E','082F','082G','082H','082I','082J','082K','082M','082N','082O','082X','082Y','082Z','0830','0831','0832','0833','0834','0835','0836','0837','0838','0839','083A','083B','083C','083D','083E','083F','083G','083H','083I','083J','083K','083M','083N','083O','083X','083Y','083Z','0840','0841','0842','0843','0844','0845','0846','0847','0848','0849','084A','084B','084C','084D','084E','084F','084G','084H','084I','084J','084K','084M','084N','084O','084X','084Y','084Z','0850','0851','0852','0853','0854','0855','0856','0857','0858','0859','085A','085B','085C','085D','085E','085F','085G','085H','085I','085J','085K','085M','085N','085O','085X','085Y','085Z','0860','0861','0862','0863','0864','0865','0866','0867','0868','0869','086A','086B','086C','086D','086E','086F','086G','086H','086I','086J','086K','086M','086N','086O','086X','086Y','086Z','0890','0891','0892','0893','0894','0895','0896','0897','0898','0899','089A','089B','089C','089D','089E','089F','089G','089H','089I','089J','089K','089M','089N','089O','089X','089Y','089Z','0910','0911','0912','0913','0914','0915','0916','0917','0918','0919','091A','091B','091C','091D','091E','091F','091G','091H','091I','091J','091K','091M','091N','091O','091X','091Y','091Z','0920','0921','0922','0923','0924','0925','0926','0927','0928','0929','092A','092B','092C','092D','092E','092F','092G','092H','092I','092J','092K','092M','092N','092O','092X','092Y','092Z','0930','0931','0932','0933','0934','0935','0936','0937','0938','0939','093A','093B','093C','093D','093E','093F','093G','093H','093I','093J','093K','093M','093N','093O','093X','093Y','093Z','0940','0941','0942','0943','0944','0945','0946','0947','0948','0949','094A','094B','094C','094D','094E','094F','094G','094H','094I','094J','094K','094M','094N','094O','094X','094Y','094Z','0950','0951','0952','0953','0954','0955','0956','0957','0958','0959','095A','095B','095C','095D','095E','095F','095G','095H','095I','095J','095K','095M','095N','095O','095X','095Y','095Z','0960','0961','0962','0963','0964','0965','0966','0967','0968','0969','096A','096B','096C','096D','096E','096F','096G','096H','096I','096J','096K','096M','096N','096O','096X','096Y','096Z','0970','0971','0972','0973','0974','0975','0976','0977','0978','0979','097A','097B','097C','097D','097E','097F','097G','097H','097I','097J','097K','097M','097N','097O','097X','097Y','097Z','0980','0981','0982','0983','0984','0985','0986','0987','0988','0989','098A','098B','098C','098D','098E','098F','098G','098H','098I','098J','098K','098M','098N','098O','098X','098Y','098Z','0990','0991','0992','0993','0994','0995','0996','0997','0998','0999','099A','099B','099C','099D','099E','099F','099G','099H','099I','099J','099K','099M','099N','099O','099X','099Y','099Z');
    temp_value = $('ub04_claim_informations_patient_bill_type').value;

    for (bill_count = 0; bill_count < bill_type_arr.length; bill_count++) {
        
            if (bill_type_arr[bill_count] != temp_value)
               flag = flag + 0;
             else
                flag = flag + 1;
    }
    if (flag > 0)
        return true;
    else
        {
               alert("Invalid entry, Type of bill must be a valid 4 digit entry, it cannot be blank");
               $('ub04_claim_informations_patient_bill_type').focus();
               return false;
               }
}

function validate_modifier(mod_id)
{
    if($(mod_id).value != '')
        {
            if(($(mod_id).value.match(modifierregexp)))
                return true
            else
              {
                  alert("Modifier must be a 2 digit value");
                  $(mod_id).focus();
                  return false
              }
        }
    else
        return true
}
    function validatecompletebutton()
    {
        if(count > 0)
        {
            alert("Please check if you mistakenly clicked Complete instead of Save button")
            return false
        }
        else
        {
            if (($('viewONE').getNumPages() -  $('viewONE').getPage()) == 0 )
            {
                agree = confirm("Are you sure to complete?")
                if (agree == true)
                    return true
                else
                    return false
            }
            else
            {
                alert("You hadn't saved all out of "+$('viewONE').getNumPages()+" pages. Please process all the claims in this jobs")
                $('billing_provider_details_billing_provider_last_name').focus()
                return false
            }
        }
    }

function removeRowQa(row,svccount) {

     var e1 = document.getElementById("removeRow_" + row);
     var remove_row1 = e1.parentNode.parentNode;
     remove_row1.parentNode.removeChild(remove_row1);
     $('svc_count').value = ($('svc_count').value) - 1
        var total_fee = 0
        for (line = 1; line <= svccount; line++) {
        var fee = $('ub04_serviceline_informations_charges'+line)
         if (fee.value.length != 0) {
             total_fee = total_fee + parseFloat(fee.value);
         }
//          $("ub04_claim_informations_total_charges").value = total_fee
     }
    
 }
 
 function isValidDate(datevalue)
 {
   if($(datevalue).value != "")
       {
         if($(datevalue).value.match(mmddyyyy))
             {
                month = $(datevalue).value.slice(0,2);
                day = $(datevalue).value.slice(2,4);
                year = $(datevalue).value.slice(4,8);
                threeMonthsPrior = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
                input_date = new Date(year, month-1, day)
                if(input_date > now)
                    {
                        alert('future date is not permitted');
                        $(datevalue).focus();
                        return false;
                    }
                else
                    {
                        if(input_date >= threeMonthsPrior)
                            return true
                        else
                        {
                            agree = confirm('Date you entered needs to be confirmed. Are you sure to continue?');
                            if(agree == true)
                                return true
                            else
                            {
                                $(datevalue).focus()
                                return false
                            }
                        }
                    }
             }
         else
             {
                alert("Please enter a valid date")
                $(datevalue).focus()
                return false;
             }
       }
       else
           return true
 }

 function isValidDate_dob(datevalue)
 {
   if($(datevalue).value != "")
       {
         if($(datevalue).value.match(mmddyyyy))
             {
                month = $(datevalue).value.slice(0,2);
                day = $(datevalue).value.slice(2,4);
                year = $(datevalue).value.slice(4,8);
                input_date = new Date(year, month-1, day)
                if(input_date > now)
                    {
                        alert('future date is not permitted');
                        $(datevalue).focus();
                        return false;
                    }
             }
         else
             {
                alert("Please enter a valid date")
                $(datevalue).focus()
                return false;
             }
       }
       else
           return true
 }


function convert_case_toupper(textfield_id)
{
    str_lower = $(textfield_id).value
    str_upper = str_lower.toUpperCase();
    $(textfield_id).value = str_upper
}

function enable_textfield(textfield_id)
{
    $(textfield_id).readOnly = false;
}

function code_blank(code_field,date_field)
{
   if($(code_field).value == '')
   {
       $(date_field).value = ''
       $(date_field).readOnly = true;
   }
}



function disable_fields()
{
    disable(occurence_code1,occurence_date1);
    disable(occurence_code2,occurence_date2);
    disable(occurence_code3,occurence_date3);
    disable(occurence_code4,occurence_date4);
    disable(occurence_code5,occurence_date5);
    disable(occurence_code6,occurence_date6);
    disable(occurence_code7,occurence_date7);
    disable(occurence_code8,occurence_date8);
    disable(occurence_span_code1,occurence_span_from_date1);
    disable(occurence_span_code1,occurence_span_through_date1);
    disable(occurence_span_code2,occurence_span_from_date2);
    disable(occurence_span_code2,occurence_span_through_date2);
    disable(occurence_span_code3,occurence_span_from_date3);
    disable(occurence_span_code3,occurence_span_through_date3);
    disable(occurence_span_code4,occurence_span_from_date4);
    disable(occurence_span_code4,occurence_span_through_date4);

    disable(ub04_claim_informations_principal_proc_code,ub04_claim_informations_principal_proc_date);
    disable(ub04_claim_informations_other_proc_code1,ub04_claim_informations_other_proc_date1);
    disable(ub04_claim_informations_other_proc_code2,ub04_claim_informations_other_proc_date2);
    disable(ub04_claim_informations_other_proc_code3,ub04_claim_informations_other_proc_date3);
    disable(ub04_claim_informations_other_proc_code4,ub04_claim_informations_other_proc_date4);
    disable(ub04_claim_informations_other_proc_code5,ub04_claim_informations_other_proc_date5);
}

function disable(code_field,date_field)
{
    if ($(code_field).value == '') {
        $(date_field).readOnly = true;

    }
}