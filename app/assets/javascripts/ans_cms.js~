var balance = 0;
var count = 0;
var rowcount = 0;
var count1 = 4000;
var tot_sum = 0;
var s = 0;
var s1 = 0;
var flag = 0;
var cpt_code = /^[\w]{5}$/;
var temp_flag_cpt = 0;
var org = /^[0-9A-Za-z\-\/\s\&]+$/;
var alphaExp = /^[a-zA-Z]+$/;
var dobRegxp = /^([0-9]){2}(\/){1}([0-9]){2}(\/)([0-9]){4}$/;
var name = /^[A-Za-z\-\s\,]+$/
var ensplan = /^[0-9a-zA-Z|\s|\-]+$/;
var numericExpression = /^[0-9]+$/;
var string = /^[a-zA-Z0-9]+$/;
var char1 = /^[A-Z]+$/;
var float1 = /^[0-9]+\.[0-9]*$/;
var address = /^[a-zA-Z0-9\s\-\/\,\.]+$/;
var city_exp = /^[a-zA-Z\s\-\.]+$/;
var diagonosis = /^[0-9|a-z|A-Z|\.]+\.[0-9]*$/;
var newcount = 0
var newcount1 = 0
var temp_flag = 0
var zipcode_check = /(^\d{5}$)|(^\d{9}$)/
var year_array_from;
var year_array_to;
var i = 0;
var c = 0
var date_of_service_to;
var diagnosis_ptr = /^[1-8]+$/;
var placeofserviceregexp = /^[0-9]{2}$|^[\s]{0,}$/
var modifierregexp = /^\w{2}$/
var now = new Date();
var alphanumeric = /^[a-zA-Z0-9 ]+$/
var submitted = false
//var flag_radiobtn = 0

function serviceLineValidations()
{
    // $$ - getElementsByClassName
    var from = $$(".from")
    var to = $$(".to")
    var placeofservice = $$(".placeofservice")
    var emgz = $$(".emgz")
    var cpthcpcs = $$(".cpthcpcs")
    var modifier1 = $$(".modifier1")
    var modifier2 = $$(".modifier2")
    var diagnosis_pointer = $$(".diagnosis_pointer")
    var days_units = $$(".days_units")
    var minutes = $$(".minutes")
    var charges = $$(".charges")
    var rendering_provider = $$(".rendering_provider")
    var rendering_provider1 = $$(".rendering_provider1")
    var idqual = $$(".idqual")

    var serviceline_count = $('svc_count').value

    for (i = 0; i < serviceline_count; i++)
    {
        if ((from[i].value != '') || (to[i].value != '') || (placeofservice[i].value != '') || (emgz[i].value != '') || (cpthcpcs[i].value != '') || (modifier1[i].value != '') || (modifier2[i].value != '') || (diagnosis_pointer[i].value != '') || (charges[i].value != '') || (rendering_provider[i].value != ''))
        {
            if (from[i].value == '')
            {
                alert("From date is mandatory");
                from[i].focus();
                return false;
            }


            //                 else if(placeofservice[i].value=='')
            //                     {
            //                        alert("Place of service is mandatory");
            //                        placeofservice[i].focus();
            //                        return false;
            //                     }
            else if (emgz[i].value == '')
            {
                alert("emg is mandatory");
                emgz[i].focus();
                return false;
            }
            else if (cpthcpcs[i].value == '')
            {
                alert("cpt/hcpcs is mandatory");
                cpthcpcs[i].focus();
                return false;
            }
            else if (diagnosis_pointer[i].value == '')
            {
                alert("Diagnosis Pointer is mandatory");
                diagnosis_pointer[i].focus();
                return false;
            }

            else if (charges[i].value == '')
            {
                alert("charges is mandatory");
                charges[i].focus();
                return false;
            }
            else if ((minutes[i].value == '') && (days_units[i].value == ''))
            {
                alert("Either Days of units / Minutes is mandatory");
                days_units[i].focus();
                return false;
            }
            else if ((minutes[i].value != "") && (days_units[i].value != ''))
            {
                alert("Either Days of units / Minutes is mandatory");
                days_units[i].focus();
                return false;
            }
            else if (from[i].value != '')
            {
                addSlashes(from[i]);
                year_array_from = from[i].value.split("/");
                var datefrom = new Date(year_array_from[2], year_array_from[0] - 1, year_array_from[1]);
                if ((year_array_from[1] < 1) || (year_array_from[1] > 31) || (year_array_from[0] < 1) || (year_array_from[0] > 12) || (datefrom > now) || (!(from[i].value.match(dobRegxp))))
                {
                    if (datefrom > now)
                    {
                        //                        resp = confirm("You entered a future date. Are you sure to continue?");
                        //                        if (resp== false) {
                        //                            from[i].focus();
                        //                            return false;
                        //                        }
                        alert("Future date is not permitted");
                        from[i].focus();
                        return false;
                    }
                    else
                    {
                        alert('Incorrect date range or format');
                        from[i].focus();
                        return false;
                    }
                }
                if ((placeofservice[i].value != '')||(placeofservice[i].value == ''))
                {
                    if (!(placeofservice[i].value.match(placeofserviceregexp)))
                    {
                        alert("Place of service must be a 2 digit number or blank");
                        placeofservice[i].focus();
                        return false;
                    }
                    else if (emgz[i].value != '')
                    {
                        if ((emgz[i].value != 'Y') && (emgz[i].value != 'N'))
                        {
                            alert("emg must be Y or N");
                            emgz[i].focus();

                            return false;
                        }
                        else if (cpthcpcs[i].value != '')
                        {
                            if (!(cpthcpcs[i].value.match(cpt_code)))
                            {
                                alert("cpt/hcpcs must be 5 digits");
                                cpthcpcs[i].focus();
                                return false;
                            }
                            else if (diagnosis_pointer[i].value != '')
                            {
                                if (!(diagnosis_pointer[i].value.match(diagnosis_ptr)))
                                {
                                    alert("Diagonosis Pointer Not in the Range{1,2,3,4,5,6,7,8}");
                                    diagnosis_pointer[i].focus();
                                    return false;
                                }

                                    //                                    else if (idqual[i].value != '')
                                    //                                        {
                                    //                                        if(!(idqual[i].value.match(string)))
                                    //                                            {
                                    //                                                alert("ID qual must be a string");
                                    //                                                idqual[i].focus()
                                    //                                                return false;
                                    //                                            }
                                    //                                        if(rendering_provider1[i].value == '')
                                    //                                            {
                                    //                                                        alert('rendering provider id is must');
                                    //                                                        rendering_provider1[i].focus();
                                    //                                                        return false;
                                    //                                            }
                                    else if (charges[i].value != '')
                                    {
                                        if (!((charges[i].value.match(float1)) || (charges[i].value.match(numericExpression))))
                                        {
                                            alert("charges must be a real number");
                                            charges[i].focus();
                                            return false;
                                        }
                                        if (rendering_provider[i].value != "")
                                        {
                                            //if((!(rendering_provider[i].value.match(numericExpression))) || ((rendering_provider[i].value.length)!=10))
                                            if ((isValidNPI(rendering_provider[i].value) == false))
                                            {
                                                //alert("Rendering Provider id must be 10 digits");
                                                rendering_provider[i].focus();
                                                return false;
                                            }
                                        }
                                        if (to[i].value != "")
                                        {
                                            addSlashes(to[i]);
                                            //compareDatesFromandTo(from[i],to[i],i);
                                            year_array_to = to[i].value.split("/");
                                            var dateto = new Date(year_array_to[2], year_array_to[0] - 1, year_array_to[1]);
                                            if ((year_array_to[1] < 1) || (year_array_to[1] > 31) || (year_array_to[0] < 1) || (year_array_to[0] > 12) || (dateto > now) || (!(to[i].value.match(dobRegxp))) || (!(compareDatesFromandTo(from[i], to[i], i))))
                                            {
                                                if (!((compareDatesFromandTo(from[i], to[i], i))))
                                                {
                                                    alert('From date cannot be greater than to date');
                                                    to[i].focus();
                                                    return false;
                                                }
                                                if ((dateto > now))
                                                {
                                                    alert('future date is not permitted');
                                                    to[i].focus();
                                                    return false;
                                                }
                                                else
                                                {
                                                    alert('Incorrect date range or format');
                                                    to[i].focus();
                                                    return false;
                                                }
                                            }

                            if (days_units[i].value != '' || minutes[i].value != '')
                                {
                                    if (days_units[i].value != '')
                                        {
                                            if (!((days_units[i].value.match(float1)) || (days_units[i].value.match(numericExpression))))
                                            {
                                                alert("Units must be a real number");
                                                days_units[i].focus();
                                                return false;
                                            }
                                        }
                                        }
                                        if (idqual[i].value != '')
                                        {
                                            if(!(idqual[i].value.match(string)))
                                            {
                                                alert("ID qual must be a string");
                                                idqual[i].focus()
                                                return false;
                                            }
                                            if(rendering_provider1[i].value == '')
                                            {
                                                alert('rendering provider id is must');
                                                rendering_provider1[i].focus();
                                                return false;
                                            }

                                        }
                                    }
                                }
                            }
                        }
                    }
                }

            }

        }
    }
    return true;
}


function placeofservicecheckinocr()
{
    var from = $$(".from")
    var to = $$(".to")
    var placeofservice = $$(".placeofservice")
    var emgz = $$(".emgz")
    var cpthcpcs = $$(".cpthcpcs")
    var modifier1 = $$(".modifier1")
    var modifier2 = $$(".modifier2")
    var diagnosis_pointer = $$(".diagnosis_pointer")
    var days_units = $$(".days_units")
    var charges = $$(".charges")
    var rendering_provider = $$(".rendering_provider")
    var serviceline_count = $('svc_count').value

    for (i = 0; i < serviceline_count; i++)
    {
        if ((from[i].value != '') || (to[i].value != '') || (placeofservice[i].value != '') || (emgz[i].value != '') || (cpthcpcs[i].value != '') || (modifier1[i].value != '') || (modifier2[i].value != '') || (diagnosis_pointer[i].value != '') || (days_units[i].value != '') || (charges[i].value != '') || (rendering_provider[i].value != ''))
        {
            if ((placeofservice[i].value == '') || ((placeofservice[i].value == '00')))
            {
                confirmpos = confirm("Place of service field left blank, do you want to continue?");
                if (confirmpos == true)
                    return true;
                else
                {
                    // $('placeofservice'+i).focus();
                    placeofservice[i].focus();
                    return false;
                }

            }
        }

    }
    return true;
}


// New Validation for NPI


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


function future_date(date)
{
    var now = new Date();
    var day = date.substr(3, 2);
    var month = date.substr(0, 2);
    var year;
    year = date.substr(6, 10);

    var date1 = new Date(year, month - 1, day);
    if (date1 > now)
    {
        return true
    }
    return false
}

//function future_date1(month, day, year)
//{
//    var date1 = new Date(year, month - 1, day);
//    if (date1 > now)
//    {
//        return true
//    }
//    return false
//}


function payer_name()
{
    if ($('payer_name').value == '')
    {
        alert("Payer name cannot be empty");
        $('payer_name').focus();
        return false
    }
    else if ($('payer_name').value.match(alphanumeric) == null)

    {
        alert("Please enter valid payer name");
        $('payer_name').focus();
        return false
    }
    else
        return true;
}
function payer_addrone()
{
    if ($('pay_add_one').value == '')
    {
        alert("Payer address one cannot be empty");
        $('pay_add_one').focus();
        return false
    }
    else if ($('pay_add_one').value.match(alphanumeric) == null)

    {
        alert("Please enter valid payer address");
        $('pay_add_one').focus();
        return false
    }
    else
        return true;
}

function payer_addrtwo()
{
    if ($('pay_add_two').value != '')
    {
        if ($('pay_add_two').value.match(alphanumeric) == null)
        {
            alert("Please enter valid payer address");
            $('pay_add_two').focus();
            return false
        }
        else
            return true;
    }
    else
        return true;
}


function payer_city()
{
    if ($('payer_city').value == '')
    {
        alert("Payer city cannot be empty");
        $('payer_city').focus();
        return false
    }
    else if ($('payer_city').value.match(alphanumeric) == null)

    {
        alert("Please enter valid payer city");
        $('payer_city').focus();
        return false
    }
    else
        return true;
}
function payer_state()
{
    if ($('payer_state').value == '')
    {
        alert("Payer state cannot be empty");
        $('payer_state').focus();
        return false
    }
    else if ($('payer_state').value.length != 2)
    {
        alert("Payer state must be 2 digits");
        $('payer_state').focus();
        return false
    }
    else if ($('payer_state').value.match(alphanumeric) == null)

    {
        alert("Please enter valid payer state");
        $('payer_state').focus();
        return false
    }
    else
        return true;
}
function payer_zipcode()
{
    if ($('payer_zipcode').value == '')
    {
        alert("Payer zipcode cannot be empty");
        $('payer_zipcode').focus();
        return false
    }
    else if ($('payer_zipcode').value.match(zipcode_check))
        return true;
    else {
        alert('Zip Code must be  5 Digits or 9 Digits')
        $('payer_zipcode').focus();
        return false;
    }
}

// Calculating the number of seconds a processor takes to process a job
function countr()
{
    document.getElementById('s').value = c
    c = c + 1
    setTimeout("countr()", 1000)
}

function isHighLighted() {
    display_color_array = ['cms1500_patient_last_name','cms1500_patient_first_name','patient_dob_month','patient_dob_date','patient_dob_year','insureds_id','cms1500_insured_last_name','cms1500_insured_first_name','dateofservicefrom','diagnosis_pointer_id','days_or_units_id','cms1500_billing_provider_last_name','cms1500_billing_provider_first_name','cms1500_billing_provider_name']
    for (colorcount = 0; colorcount < display_color_array.length; colorcount++) {
        if (document.getElementById(display_color_array[colorcount]).value == '')
            document.getElementById(display_color_array[colorcount]).style.backgroundColor = '#FFCC00'
    }

}

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


function isBillingProviderMiddle(facilityName) {
    if (facilityName == 'PCN')
    {
        return true;
    }
else
    {
    bill_prv_middle = document.getElementById('cms1500_billing_provider_suffix').value
    if (bill_prv_middle != '') {
        if (bill_prv_middle.match(name)) {
            if (bill_prv_middle != 'MD')
                return true;
            else
            {
                alert('Billing Provider Suffix does not Support MD');
                document.getElementById('cms1500_billing_provider_suffix').focus();
                return false;


            }

        }
        else
        {
            alert('Please Enter a Valid Sufix');
            document.getElementById('cms1500_billing_provider_suffix').focus();
            return false;

        }
    }
    else
        return true;
}
}

function isBillOrganisationB() {
    if (document.getElementById('bill_b').value != '') {
        if (document.getElementById('bill_b').value.match(string))
            return true;
        else {
            alert('please enter Valid  BILLING PROVIDER INFO  NON-NPI Id');
            document.getElementById('bill_b').focus();
            return false;
        }
    } else {
        return true
    }
}

function isBillOrganisationA() {
    bill_a_length = (document.getElementById('bill_a').value).length
    if (document.getElementById('bill_a').value != '') {
        if (document.getElementById('bill_a').value.match(numericExpression)) {
            if (bill_a_length == 10)
                return true;
            else
                alert('BILLING PROVIDER INFO  NPI Id Must be 10 Digits');
            document.getElementById('bill_a').focus();
            return false;
        }
        else {
            alert('please enter Valid  BILLING PROVIDER INFO  NPI Id');
            document.getElementById('bill_a').focus();
            return false;
        }
    } else {
        return true
    }
}

function isBillingOrganisationTelePhone() {
    if (document.getElementById('cms1500_billing_provider_phone').value != '') {
        document.getElementById('cms1500_billing_provider_phone').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_billing_provider_phone').value.match(numericExpression))
            return true;
        else {
            alert('Organization PhoneNumber  Must be  Numeric');
            document.getElementById('cms1500_billing_provider_phone').focus();
            return false;
        }
    }
    else {
        return true
    }
}


// validation for the Zip code
function isBillingOrganizationZipCode() {
    if (document.getElementById('cms1500_billing_provider_zipcode').value != '') {
        document.getElementById('cms1500_billing_provider_zipcode').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_billing_provider_zipcode').value.match(numericExpression)) {
            if (document.getElementById('cms1500_billing_provider_zipcode').value.match(zipcode_check))
                return true;
            else
            {
                alert('Billing Organization Zipcode must be 5 or 9 Digits');
                document.getElementById('cms1500_billing_provider_zipcode').focus();
                return false;


            }
        } else {
            alert('Please Enter  Valid Organization Zip Code')
            document.getElementById('cms1500_billing_provider_zipcode').focus();
            return false;
        }

    } else {
        alert('Please enter Billing Organization Zipcode')
        isHighLighted();
        document.getElementById('cms1500_billing_provider_zipcode').focus();
        return false
        //return true;
    }
}
//validation for

function isBillingOrganizationState() {

    if ((($('billing_prv_state').value) != '--') && (($('billing_prv_state').value) != '')) {
        return true
    } else {
        alert("If State code is not present, capture XX, otherwise select correct State code");
        $('billing_prv_state').focus();
        return false;
    }
}
function isBillingOrganizationAddress() {
    if (document.getElementById('cms1500_billing_provider_address').value != '')
    {
        document.getElementById('cms1500_billing_provider_address').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_billing_provider_address').value.match(address))
            return true
        else {
            alert('Please enter only string values')
            document.getElementById('cms1500_billing_provider_address').focus()
            return false
        }
    }
    else {
        alert('Please enter Billing Organization Address')
        isHighLighted();
        document.getElementById('cms1500_billing_provider_address').focus();
        return false

    }
}


function isBillingOrganizationName() {

    //org_name = $('radio_choice4343_attribute_org_name').checked;
    //physic_name = $('radio_choice4343_attribute_physic_name').checked;

    if ($('radio_choice4343_attribute_org_name').checked == true)
    {
        if (document.getElementById('cms1500_billing_provider_name').value != '') {
            document.getElementById('cms1500_billing_provider_name').style.backgroundColor = 'white'
            if (document.getElementById('cms1500_billing_provider_name').value.match(org))
                return true;
            else {
                alert('Please enter valid Organization Name')
                document.getElementById('cms1500_billing_provider_name').focus();
                return false;
            }

        } else
        {
            if (document.getElementById('cms1500_billing_provider_name').value == '')
            {

                alert('Billing Organization Name Cannot be Empty')
                isHighLighted();
                document.getElementById('cms1500_billing_provider_name').focus();
                //document.getElementById('cms1500_billing_provider_name').focus();
                return false;
            }
            else
            {
                return true;
            }
        }

    }
    else if ($('radio_choice4343_attribute_physic_name').checked)
    {
        Isbillingphysiciansfirstname()
        if (document.getElementById('cms1500_billing_provider_last_name').value != '')
        {
            //Isbillingphysicianslastname()
            if (Isbillingphysicianslastname() == true)
                return true
            else
                return false

        }
    }
    // Function Billing physician's firstname
    function Isbillingphysiciansfirstname()
    {
        if (document.getElementById('cms1500_billing_provider_last_name').value != '')
        {

            document.getElementById('cms1500_billing_provider_last_name').style.backgroundColor = 'white'
            if (document.getElementById('cms1500_billing_provider_last_name').value.match(name))
            {
                return true;
            }
            else {
                alert('Please enter valid Last name')
                document.getElementById('cms1500_billing_provider_last_name').focus();
                return false;
            }
        }

        else {
            alert('Billing Physician\'s Last Name Cannot be Empty')
            isHighLighted();
            document.getElementById('cms1500_billing_provider_last_name').focus();
            return false
            //return true;
        }

    }

    // Function Billing physician's lastname
    function Isbillingphysicianslastname()
    {
        if (document.getElementById('cms1500_billing_provider_first_name').value != '') {
            document.getElementById('cms1500_billing_provider_first_name').style.backgroundColor = 'white'
            if (document.getElementById('cms1500_billing_provider_first_name').value.match(name)) {
                return true;
            } else {
                alert('Please enter valid First name')
                document.getElementById('cms1500_billing_provider_first_name').focus();
                return false;
            }

        } else {
            alert('Billing Physician\'s First Name Cannot be Empty')
            isHighLighted();
            document.getElementById('cms1500_billing_provider_first_name').focus();
            return false
            //return true;
        }
    }


}


function isBillingOrganizationCity() {

    if (document.getElementById('cms1500_billing_provider_city').value != '') {
        document.getElementById('cms1500_billing_provider_city').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_billing_provider_city').value.match(city_exp))
            return true;
        else {
            alert('Please enter valid Organization City')
            document.getElementById('cms1500_billing_provider_city').focus();
            return false;
        }

    } else
    {
        alert('Please enter Billing Organization City')
        isHighLighted();
        document.getElementById('cms1500_billing_provider_city').focus();
        return false
        //return true
    }
}

//////////////////////////////////////////

function isAmountPaid() {
    if (document.getElementById('cms1500_amount_paid').value != '') {
        document.getElementById('cms1500_amount_paid').style.backgroundColor = 'white'
        if ((document.getElementById('cms1500_amount_paid').value.match(float1)))
            return true;
        else
        //
        if ((document.getElementById('cms1500_amount_paid').value.match(numericExpression)))
            return true;
        else
            alert('Amount Paid Must be A Real Number');
        $('cms1500_amount_paid').focus();
        return false

    }
    else
    {
        return true
    }

}
///////////////////

function isOrganisationB() {
    if (document.getElementById('cms1500_service_facility_non_npi_id').value != '') {
        if (document.getElementById('cms1500_service_facility_non_npi_id').value.match(string))
            return true;
        else {
            alert('please enter Valid  SERVICE FACILITY LOCATION INFORMATION NON-NPI Id');
            document.getElementById('cms1500_service_facility_non_npi_id').focus();
            return false;
        }
    } else {
        return true;
    }
}

function isOrganisationA() {
    orgn_a_length = (document.getElementById('cms1500_service_facility_npi_id').value).length
    if (document.getElementById('cms1500_service_facility_npi_id').value != '') {
        if (document.getElementById('cms1500_service_facility_npi_id').value.match(numericExpression)) {
            if (orgn_a_length == 10)
                return true;
            else
            {
                alert('SERVICE FACILITY LOCATION INFORMATION NPI Id Must be 10 Digits');
                document.getElementById('cms1500_service_facility_npi_id').focus();
                return false;
            }
        }
        else {
            alert('please enter Valid  SERVICE FACILITY LOCATION INFORMATION NPI Id');
            document.getElementById('cms1500_service_facility_npi_id').focus();
            return false;
        }
    } else {
        return true;
    }
}

function isOrganisationTelePhone() {
    if (document.getElementById('orgn_phone').value != '') {
        if (document.getElementById('orgn_phone').value.match(numericExpression))
            return true;
        else {
            alert('Organization PhoneNumber  Must be  Numeric');
            document.getElementById('orgn_phone').focus();
            return false;
        }
    }
    else {
        return true
    }
}


// validation for the Zip code
function isOrganizationZipCode() {

    if (document.getElementById('cms1500_service_facility_zipcode').value != '')
    {
        document.getElementById('cms1500_service_facility_zipcode').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_service_facility_zipcode').value.match(numericExpression)) {
            if (document.getElementById('cms1500_service_facility_zipcode').value.match(zipcode_check))
                return true;
            else {
                alert('Zipcode must be 5 Digits or 9 Digits')
                document.getElementById('cms1500_service_facility_zipcode').focus();
                return false;
            }
        } else {
            alert('Please enter valid Organization Zip Code')
            document.getElementById('cms1500_service_facility_zipcode').focus();
            return false;
        }

    }

    if (document.getElementById('cms1500_service_facility_name').value != '')
    {
        if (document.getElementById('cms1500_service_facility_zipcode').value == '')
        {
            alert('Please enter Organization Zip Code')
            document.getElementById('cms1500_service_facility_zipcode').focus();
            return false;
        }
    }
    else
        return true;
}
//validation for

function isOrganizationState() {
    if ($('cms1500_service_facility_name').value != '')
    {
        if (($('service_facility_state').value == '--') || ($('service_facility_state').value == ''))
        {
            alert("If State code is not present, capture XX, otherwise select correct State code");
            $('service_facility_state').focus();
            return false
        }
        else
            return true;
    }
    else
        return true;
}
function isOrganizationAddress() {

    if (document.getElementById('cms1500_service_facility_address').value != '')
    {
        document.getElementById('cms1500_service_facility_address').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_service_facility_address').value.match(address))
            return true
        else {
            alert('Please Enter Valid SERVICE FACILITY Address')
            document.getElementById('cms1500_service_facility_address').focus()
            return false
        }
    }

    if (document.getElementById('cms1500_service_facility_name').value != '')
    {
        if (document.getElementById('cms1500_service_facility_address').value == '')
        {
            alert('Please Enter SERVICE FACILITY Address')
            document.getElementById('cms1500_service_facility_address').focus()
            return false
        }
    }
    else
        return true;

}


function isOrganizationName() {

    if (document.getElementById('cms1500_service_facility_name').value != '') {
        document.getElementById('cms1500_service_facility_name').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_service_facility_name').value.match(org)) {
            return true;
        } else {
            alert('Please enter valid SERVICE FACILITY Organization Name')
            document.getElementById('cms1500_service_facility_name').focus();
            return false;
        }

    } else {
        return true;
    }
}

function isOrganizationCity() {

    if (document.getElementById('cms1500_service_facility_city').value != '') {
        document.getElementById('cms1500_service_facility_city').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_service_facility_city').value.match(city_exp)) {
            return true;
        } else {
            alert('Please enter valid Organization City')
            document.getElementById('cms1500_service_facility_city').focus();
            return false;
        }
    }


    if (document.getElementById('cms1500_service_facility_name').value != '')
    {
        if (document.getElementById('cms1500_service_facility_city').value == '') {
            alert('Please enter Organization City')
            document.getElementById('cms1500_service_facility_city').focus();
            return false;
        }
    }
    else
        return true;


}

function isPhySicianDOB() {
    //
    month = document.getElementById('phy_month').value
    date = document.getElementById('phy_date').value
    year = document.getElementById('phy_year').value
    year_length = year.length
    month_length = month.length
    date_length = date.length
    if ((month != '') && (date != '') && (year != '')) {
        if (month.match(numericExpression)) {
            if ((month >= 1) && (month <= 12) && (month_length == 2)) {

                if (date.match(numericExpression)) {
                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {

                        if (year.match(numericExpression)) {
                            if (year_length == 4)
                                return true;
                            else {
                                alert('Year Must be  4 Digit Number');
                                document.getElementById('phy_year').focus();
                                return false;
                            }//check the length of the year <=4

                        }
                        else {
                            alert('Year Must be  4 Digit Number');
                            document.getElementById('phy_year').focus();
                            return false;
                        }// check the year is numeric or not
                    }
                    else {
                        alert('Enter a valid date');
                        document.getElementById('phy_date').focus();
                        return false;
                    }//check the date in between 1 and 31
                }
                else
                {
                    alert('Date Must be Numeric');
                    document.getElementById('phy_date').focus();
                    return false;
                }//check the date is numeric or not

            }
            else {
                alert('Enter a valid Month');
                document.getElementById('phy_month').focus();
                return false;
            }//check the month is in range


        }
        else {
            alert('Month must be Numeric');
            document.getElementById('phy_month').focus();
            return false;
        }//check the month is in range

    }
    else {
        return true;
    }//check year is empty

}

function isPhyOrganizationName() {

    if (document.getElementById('phy_orgnname').value != '') {
        document.getElementById('phy_orgnname').style.backgroundColor = 'white'
        if (document.getElementById('phy_orgnname').value.match(org)) {
            return true;
        } else {
            alert('Please enter valid Physician Organization Name')
            document.getElementById('phy_orgnname').focus();
            return false;
        }

    } else {
        return true;
    }
}

function isPhysicianInitial() {

    if (document.getElementById('phy_initial').value != '') {
        if (document.getElementById('phy_initial').value.match(alphaExp)) {
            return true;
        } else {
            alert('Please enter valid Physician Initial')
            document.getElementById('phy_initial').focus();
            return false;
        }

    } else {
        return true
    }
}


function isPhysicianSuffix(facilityName) {

if (facilityName == 'PCN')
    {
        return true;
    }
else
    {
    if (document.getElementById('phy_suffix').value != '') {
        if (document.getElementById('phy_suffix').value.match(name)) {
            if (document.getElementById('phy_suffix').value != 'MD')
                return true;
            else
            {
                alert('MD Does not Support in Suffix Name');
                document.getElementById('phy_suffix').focus();
                return false;

            }
        } else {
            alert('Please enter valid Physician Suffix')
            document.getElementById('phy_suffix').focus();
            return false;
        }

    } else {
        return true
    }
    }
}

function isPhysicianFirstName() {

    if (document.getElementById('phy_first_name').value != '') {
        if (document.getElementById('phy_first_name').value.match(name)) {
            return true;
        } else {
            alert('Please enter valid Physician First Name')
            document.getElementById('phy_first_name').focus();
            return false;
        }

    } else {
        return true
    }
}

function isPhysicianLastName() {

    if (document.getElementById('phy_last_name').value != '') {
        if (document.getElementById('phy_last_name').value.match(name)) {
            return true;
        } else {
            alert('Please enter valid Physician Last Name')
            document.getElementById('phy_last_name').focus();
            return false;
        }

    } else {
        return true
    }
}


function isReFPRVB() {
    if (document.getElementById('ref_prv_b').value != '') {
        if (document.getElementById('ref_prv_b').value.match(string))
            return true
        else {
            alert('Support only String/Numeric');
            document.getElementById('ref_prv_b').focus();
            return false;
        }
    }
    else {

        return true;
    }

}

function isPatientAccountNumber() {
    patient_account_info = document.getElementById('patient_account_info').value
    code_length = patient_account_info.length
    if (document.getElementById('patient_account_info').value.length != 0) {
        document.getElementById('patient_account_info').style.backgroundColor = 'white'
        if (patient_account_info.match(string)) {
            return true;
        } else {
            alert('Patient Account Number should be Alpha-Numeric');
            document.getElementById('patient_account_info').focus();
            return false;
        }
    }
    else {
        alert("Patient Account Number can't be blank")
        isHighLighted();
        document.getElementById('patient_account_info').focus();
        return false;

    }


}


function isFederalTaxId() {
    federal_tx_id = document.getElementById('federal_tx_id').value
    code_length = federal_tx_id.length
    if (document.getElementById('federal_tx_id').value != '') {
        document.getElementById('federal_tx_id').style.backgroundColor = 'white'
        if (federal_tx_id.match(numericExpression)) {
            if (code_length == 9)
                return true
            else {
                alert('FEDERAL TAX ID  LENGTH SHOULD BE 9')
                document.getElementById('federal_tx_id').focus();
                return false;
            }
        } else {
            alert('Federal TaxId String/Integer');
            document.getElementById('federal_tx_id').focus();
            return false;
        }
    }
    else {
        return true;


    }


}

function IsPriororganizationNumber() {

    prior_auth_number = document.getElementById('prior_auth_number').value
    code_length = prior_auth_number.length
    if (document.getElementById('prior_auth_number').value != '') {
        if (prior_auth_number.match(address)) {
            if (code_length <= 29)
                return true
            else {
                alert('MAXIMUM CODE LENGTH SHOULD BE 18')
                document.getElementById('prior_auth_number').focus();
                return false;
            }
        } else {
            alert('Ref Number String/Integer');
            document.getElementById('prior_auth_number').focus();
            return false;
        }
    }
    else {

        return true;


    }


}

function isOrginalRefNumber() {
    original_ref_number = document.getElementById('original_ref_number').value
    code_length = original_ref_number.length
    if (document.getElementById('original_ref_number').value != '') {
        if (original_ref_number.match(string)) {
            if (code_length <= 18)
                return true
            else {
                alert('MAXIMUM CODE LENGTH SHOULD BE 18')
                document.getElementById('original_ref_number').focus();
                return false;
            }
        } else {
            alert('Ref Number String/Integer');
            document.getElementById('original_ref_number').focus();
            return false;
        }
    }
    else {

        return true;


    }
}


function isMediCode() {
    code1 = document.getElementById('medi_code').value
    code_length = code1.length
    if (document.getElementById('medi_code').value != '') {
        if (code1.match(string)) {
            if (code_length <= 11)
                return true
            else {
                alert('MAXIMUM CODE LENGTH SHOULD BE 11')
                document.getElementById('medi_code').focus();
                return false;
            }
        } else {
            alert('code must be String')
            document.getElementById('medi_code').focus();
            return false;
        }
    }
    else {
        return true;


    }
}


function isLabCharge() {
    if (document.getElementById('lab_charge').value != '') {
        if ((document.getElementById('lab_charge').value.match(float1)))
            return true
        else
        //
        if ((document.getElementById('lab_charge').value.match(numericExpression)))
            return true
        else
            alert('Lab Chrge must be Real Number');
        document.getElementById('lab_charge').focus();
        return false

    }
    else
    {

        return true;
    }


}

// FUNCTIONS TO MERGE isServiceToDate,isServiceFromDate,isOccupationToDate,isOccupationFromDate,iscurrentDate,isIllnessDate,   isOthersInsuredsDOB,isSignedDOB
//function isServiceToDate() {
//    month = document.getElementById('service_to_month').value
//    date = document.getElementById('service_to_date').value
//    year = document.getElementById('service_to_year').value
//    year_length = year.length
//    month_length = month.length
//    date_length = date.length
//    if ((month != '') && (date != '') && (year != '')) {
//        if (month.match(numericExpression)) {
//            if ((month >= 1) && (month <= 12) && (month_length == 2)) {
//
//                if (date.match(numericExpression)) {
//                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {
//
//                        if (year.match(numericExpression)) {
//                            if (year_length == 4 && (year >= 1900))
//                            {
//                                if (future_date1(($('service_to_month').value), ($('service_to_date').value), ($('service_to_year').value)))
//                                {
//                                    alert("HOSPITALIZATION DATES RELATED TO CURRENT SERVICES is a future date")
//                                    $('service_to_month').focus()
//                                    $('service_to_month').highlight()
//                                    return false;
//                                }
//                                else
//                                    return true;
//                            }
//                            else {
//                                alert('Please enter a 4 Digit Year after 1900');
//                                document.getElementById('service_to_year').focus();
//                                return false;
//                            }//check the length of the year <=4
//
//                        }
//                        else {
//                            alert('Year Must be  4 Digit Number');
//                            document.getElementById('service_to_year').focus();
//                            return false;
//                        }// check the year is numeric or not
//                    }
//                    else {
//                        alert('Enter a valid date');
//                        document.getElementById('service_to_date').focus();
//                        return false;
//                    }//check the date in between 1 and 31
//                }
//                else
//                {
//                    alert('Date Must be Numeric');
//                    document.getElementById('service_to_date').focus();
//                    return false;
//                }//check the date is numeric or not
//
//            }
//            else {
//                alert('Enter a valid Month');
//                document.getElementById('service_to_month').focus();
//                return false;
//            }//check the month is in range
//
//
//        }
//        else {
//            alert('Month must be Numeric');
//            document.getElementById('service_to_month').focus();
//            return false;
//        }//check the month is in range
//
//    }
//    else if ((month == '') && (date == '') && (year == '')) {
//        return true;
//    }
//    else
//    {
//        alert("Please enter the date correctly");
//        $('service_to_month').focus();
//        return false;
//    }//check year is empty
//
//
//}

//function isServiceFromDate() {
//    month = document.getElementById('service_from_month').value
//    date = document.getElementById('service_from_date').value
//    year = document.getElementById('service_from_year').value
//    year_length = year.length
//    month_length = month.length
//    date_length = date.length
//    if ((month != '') && (date != '') && (year != '')) {
//        if (month.match(numericExpression)) {
//            if ((month >= 1) && (month <= 12) && (month_length == 2)) {
//
//                if (date.match(numericExpression)) {
//                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {
//
//                        if (year.match(numericExpression)) {
//                            if (year_length == 4 && (year >= 1900))
//                            {
//                                if (future_date1(($('service_from_month').value), ($('service_from_date').value), ($('service_from_year').value)))
//                                {
//                                    alert("HOSPITALIZATION DATES RELATED TO CURRENT SERVICES is a future date")
//                                    $('service_from_month').focus()
//                                    $('service_from_month').highlight()
//                                    return false;
//                                }
//                                else
//                                    return true;
//                            }
//                            else {
//                                alert('Please enter a 4 Digit Year afte 1900');
//                                document.getElementById('service_from_year').focus();
//                                return false;
//                            }//check the length of the year <=4
//
//                        }
//                        else {
//                            alert('Year Must be  4 Digit Number');
//                            document.getElementById('service_from_year').focus();
//                            return false;
//                        }// check the year is numeric or not
//                    }
//                    else {
//                        alert('Enter a valid date');
//                        document.getElementById('service_from_date').focus();
//                        return false;
//                    }//check the date in between 1 and 31
//                }
//                else
//                {
//                    alert('Date Must be Numeric');
//                    document.getElementById('service_from_date').focus();
//                    return false;
//                }//check the date is numeric or not
//
//            }
//            else {
//                alert('Enter a valid Month');
//                document.getElementById('service_from_month').focus();
//                return false;
//            }//check the month is in range
//
//
//        }
//        else {
//            alert('Month must be Numeric');
//            document.getElementById('service_from_month').focus();
//            return false;
//        }//check the month is in range
//
//    }
//    else if ((month == '') && (date == '') && (year == '')) {
//        return true;
//    }
//    else
//    {
//        alert("Please enter the date correctly");
//        $('service_from_month').focus();
//        return false;
//    }//check year is empty
//}


//function isOccupationToDate() {
//    month = document.getElementById('occu_to_month').value
//    date = document.getElementById('occu_to_date').value
//    year = document.getElementById('occu_to_year').value
//    year_length = year.length
//    month_length = month.length
//    date_length = date.length
//    if ((month != '') && (date != '') && (year != '')) {
//        if (month.match(numericExpression)) {
//            if ((month >= 1) && (month <= 12) && (month_length == 2)) {
//
//                if (date.match(numericExpression)) {
//                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {
//
//                        if (year.match(numericExpression)) {
//                            if (year_length == 4 && (year >= 1900))
//                            {
//                                if (future_date1(($('occu_to_month').value), ($('occu_to_date').value), ($('occu_to_year').value)))
//                                {
//                                    alert("DATES PATIENT UNABLE TO WORK IN CURRENT OCCUPATION is a future date")
//                                    $('occu_to_month').focus()
//                                    $('occu_to_month').highlight()
//                                    return false;
//                                }
//                                else
//                                    return true;
//                            }
//                            else {
//                                alert('Please enter a 4 Digit Year after 1900');
//                                document.getElementById('occu_to_year').focus();
//                                return false;
//                            }//check the length of the year <=4
//
//                        }
//                        else {
//                            alert('Year Must be  4 Digit Number');
//                            document.getElementById('occu_to_year').focus();
//                            return false;
//                        }// check the year is numeric or not
//                    }
//                    else {
//                        alert('Enter a valid date');
//                        document.getElementById('occu_to_date').focus();
//                        return false;
//                    }//check the date in between 1 and 31
//                }
//                else
//                {
//                    alert('Date Must be Numeric');
//                    document.getElementById('occu_to_date').focus();
//                    return false;
//                }//check the date is numeric or not
//
//            }
//            else {
//                alert('Enter a valid Month');
//                document.getElementById('occu_to_month').focus();
//                return false;
//            }//check the month is in range
//
//
//        }
//        else {
//            alert('Month must be Numeric');
//            document.getElementById('occu_to_month').focus();
//            return false;
//        }//check the month is in range
//
//    }
//    else if ((month == '') && (date == '') && (year == '')) {
//        return true;
//    }
//    else
//    {
//        alert("Please enter the date correctly");
//        $('occu_to_month').focus();
//        return false;
//    }//check year is empty
//}


//function isOccupationFromDate() {
//    month = document.getElementById('occu_from_month').value
//    date = document.getElementById('occu_from_date').value
//    year = document.getElementById('occu_from_year').value
//    year_length = year.length
//    month_length = month.length
//    date_length = date.length
//    if ((month != '') && (date != '') && (year != '')) {
//        if (month.match(numericExpression)) {
//            if ((month >= 1) && (month <= 12) && (month_length == 2)) {
//
//                if (date.match(numericExpression)) {
//                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {
//
//                        if (year.match(numericExpression)) {
//                            if (year_length == 4 && (year >= 1900))
//                            {
//                                if (future_date1(($('occu_from_month').value), ($('occu_from_date').value), ($('occu_from_year').value)))
//                                {
//                                    alert("DATES PATIENT UNABLE TO WORK IN CURRENT OCCUPATION is a future date")
//                                    $('occu_from_month').focus()
//                                    $('occu_from_month').highlight()
//                                    return false;
//                                }
//                                else
//                                    return true;
//                            }
//                            else {
//                                alert('Please enter a 4 Digit Year after 1900');
//                                document.getElementById('occu_from_year').focus();
//                                return false;
//                            }//check the length of the year <=4
//
//                        }
//                        else {
//                            alert('Year Must be  4 Digit Number');
//                            document.getElementById('occu_from_year').focus();
//                            return false;
//                        }// check the year is numeric or not
//                    }
//                    else {
//                        alert('Enter a valid date');
//                        document.getElementById('occu_from_date').focus();
//                        return false;
//                    }//check the date in between 1 and 31
//                }
//                else
//                {
//                    alert('Date Must be Numeric');
//                    document.getElementById('occu_from_date').focus();
//                    return false;
//                }//check the date is numeric or not
//
//            }
//            else {
//                alert('Enter a valid Month');
//                document.getElementById('occu_from_month').focus();
//                return false;
//            }//check the month is in range
//
//
//        }
//        else {
//            alert('Month must be Numeric');
//            document.getElementById('occu_from_month').focus();
//            return false;
//        }//check the month is in range
//
//    }
//    else if ((month == '') && (date == '') && (year == '')) {
//        return true;
//    }
//    else
//    {
//        alert("Please enter the date correctly");
//        $('occu_from_month').focus();
//        return false;
//    }//check year is empty
//}

function isValidDate(mm,dd,yy) {
    month = $(mm).value
    date = $(dd).value
    year = $(yy).value
    year_length = year.length
    month_length = month.length
    date_length = date.length
    if ((month != '') && (date != '') && (year != '')) {
        if (month.match(numericExpression)) {
            if ((month >= 1) && (month <= 12) && (month_length == 2)) {
                if (date.match(numericExpression)) {
                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {
                        if (year.match(numericExpression)) {
                            if (year_length == 4 && (year >= 1900))
                            {
                                threeMonthsPrior = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
                                current_date = new Date(year, month -1, date)
                                if (current_date >= threeMonthsPrior)
                                    {
                                        if (current_date > now)
                                        {
                                            alert("Future dates not permitted")
                                            $(mm).focus()
                                            $(dd).highlight()
                                            return false;
                                        }
                                        else
                                            return true;
                                    }
                                else
                                {
                                    agree = confirm('Date you entered needs to be confirmed. Are you sure to continue?');
                                    if(agree == true)
                                        return true
                                    else
                                    {
                                        $(mm).focus()
                                        $(mm).highlight()
                                        return false
                                    }
                                }
                            }
                            else {
                                alert('Please enter a 4 Digit Year after 1900');
                                $(yy).focus();
                                return false;
                            }//check the length of the year <=4
                        }
                        else {
                            alert('Year Must be 4 Digit Number');
                            $(yy).focus();
                            return false;
                        }// check the year is numeric or not
                    }
                    else {
                        alert('Enter a valid date');
                        $(dd).focus();
                        return false;
                    }//check the date in between 1 and 31
                }
                else
                {
                    alert('Date Must be Numeric');
                    $(dd).focus();
                    return false;
                }//check the date is numeric or not
            }
            else {
                alert('Enter a valid Month');
                $(mm).focus();
                return false;
            }//check the month is in range
        }
        else {
            alert('Month must be Numeric');
            $(mm).focus();
            return false;
        }//check the month is in range
    }
    else if ((month == '') && (date == '') && (year == '')) {
        return true;
    }
    else
    {
        alert("Please enter the date correctly");
        $(mm).focus();
        return false;
    }//check year is empty
}

function isDiaganosisInjury() {
    if (document.getElementById('injury1').value != '') {
        temp_flag = 1
        document.getElementById('injury1').style.backgroundColor = 'white'

        if (((document.getElementById('injury1').value.match(string))))
            return true


        else {
            alert("must be number/string")
            document.getElementById('injury1').focus();
            return false
        }
    }
    else
    {
        temp_flag = 0
        alert("Field 21 cannot be blank")
        document.getElementById('injury1').focus();
        return false
    }
}


function isDiaganosisInjury2() {

    if (document.getElementById('injury2').value != '') {
        if (document.getElementById('injury2').value.match(string))
            return true

        else {
            alert("must be number/string")
            document.getElementById('injury2').focus();
            return false
        }
    }
    else
    {

        return true
    }
}

function isDiaganosisInjury3() {
    if (document.getElementById('injury3').value != '') {
        if (((document.getElementById('injury3').value.match(string))))
            return true

        else {
            alert("must be number/string")
            document.getElementById('injury3').focus();
            return false
        }
    }
    else
    {

        return true
    }
}


function isDiaganosisInjury4() {
    if (document.getElementById('injury4').value != '') {
        if (((document.getElementById('injury4').value.match(string))))
            return true

        else {
            alert("must be number/string")
            document.getElementById('injury4').focus();
            return false
        }
    }
    else
    {

        return true
    }
}

function isRefPrvName3() {
    if (document.getElementById('ref_prv_name3').value != '') {
        if (document.getElementById('ref_prv_name3').value.match(string))
            return true
        else {
            alert('Support only String for Refferencing provider middle initial Name');
            document.getElementById('ref_prv_name3').focus();
            return false;
        }
    }
    else {

        return true;
    }

}

//FUNCTIONS TO MERGE isRefPrvName2,isRefPrvName
//FUNCTIONS TO MERGE isOtherInsuredsFECANumber,isRefPrvName3
function isRefPrvName2() {
    if (document.getElementById('ref_prv_name2').value != '') {
        if (document.getElementById('ref_prv_name2').value.match(name))
            return true
        else {
            alert('Support only String for Refferencing provider First Name');
            document.getElementById('ref_prv_name2').focus();
            return false;
        }
    }
    else {

        return true;
    }

}
function isRefPrvName1(facilityName) {
    if (document.getElementById('ref_prv_name1').value != '') {
        if (document.getElementById('ref_prv_name1').value.match(name)) {
         if(facilityName != 'PCN')
           {
            if (document.getElementById('ref_prv_name1').value != 'MD')
                return true;
            else
            {
                alert('MD do not Allow in suffix Name');
                document.getElementById('ref_prv_name1').focus();
                return false;
            }
           }
           else if(facilityName == 'PCN')
               return true
        }
        else {
            alert('Support only String for Refferencing provider suffix Name');
            document.getElementById('ref_prv_name1').focus();
            return false;
        }
    }
    else {

        return true;
    }

}

function isRefPrvName() {
    if (document.getElementById('ref_prv_name').value != '') {
        if (document.getElementById('ref_prv_name').value.match(name))
            return true
        else {
            alert('Support only String for Refferencing provider Name');
            document.getElementById('ref_prv_name').focus();
            return false;
        }
    }
    else {

        return true;
    }

}

function isRefPrvNPI() {
    ref_prv_npi_length = (document.getElementById('ref_prv_npi').value).length
    if (document.getElementById('ref_prv_npi').value != '') {
        if (document.getElementById('ref_prv_npi').value.match(numericExpression)) {
            if (ref_prv_npi_length == 10)
                return true
            else {
                alert('Reffering Provider NPI must be 10 Digits ')
                document.getElementById('ref_prv_npi').focus();
                return false;
            }
        }
        else {
            alert('Support only Numeric for NPI');
            document.getElementById('ref_prv_npi').focus();
            return false;
        }
    }
    else {

        return true;
    }

}

function is17a() {
    ref_prv_a_length = (document.getElementById('ref_prv_a').value).length
    if (document.getElementById('ref_prv_a').value != '') {
        if (document.getElementById('ref_prv_a').value.match(string)) {
            if (ref_prv_a_length == 2)
                return true
            else {
                alert('Size must be 2');
                document.getElementById('ref_prv_a').focus();
                return false;
            }
        }
        else {
            alert('Support only String/Numeric');
            document.getElementById('ref_prv_a').focus();
            return false;
        }
    }
    else {
        return true;
    }
}
//function isIllnessDate() {
//    month = document.getElementById('illness_month').value
//    date = document.getElementById('illness_date').value
//    year = document.getElementById('illness_year').value
//    year_length = year.length
//    month_length = month.length
//    date_length = date.length
//    if ((month != '') && (date != '') && (year != '')) {
//        if (month.match(numericExpression)) {
//            if ((month >= 1) && (month <= 12) && (month_length == 2)) {
//
//                if (date.match(numericExpression)) {
//                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {
//
//                        if (year.match(numericExpression)) {
//                            if (year_length == 4 && (year >= 1900))
//                            {
//                                if (future_date1(($('illness_month').value), ($('illness_date').value), ($('illness_year').value)))
//                                {
//                                    alert("Similar Illness date is a future date")
//                                    $('illness_month').focus()
//                                    $('illness_month').highlight()
//                                    return false;
//                                }
//                                else
//                                    return true;
//                            }
//                            else {
//                                alert('Please enter a 4 Digit Year after 1900');
//                                document.getElementById('illness_year').focus();
//                                return false;
//                            }//check the length of the year <=4
//
//                        }
//                        else {
//                            alert('Year Must be 4 Digit Number');
//                            document.getElementById('illness_year').focus();
//                            return false;
//                        }// check the year is numeric or not
//                    }
//                    else {
//                        alert('Enter a valid date');
//                        document.getElementById('illness_date').focus();
//                        return false;
//                    }//check the date in between 1 and 31
//                }
//                else
//                {
//                    alert('Date Must be Numeric');
//                    document.getElementById('illness_date').focus();
//                    return false;
//                }//check the date is numeric or not
//
//            }
//            else {
//                alert('Enter a valid Month');
//                document.getElementById('illness_month').focus();
//                return false;
//            }//check the month is in range
//
//
//        }
//        else {
//            alert('Month must be Numeric');
//            document.getElementById('illness_month').focus();
//            return false;
//        }//check the month is in range
//
//    }
//    else if ((month == '') && (date == '') && (year == '')) {
//        return true;
//    }
//    else
//    {
//        alert("Please enter the date correctly");
//        $('illness_month').focus();
//        return false;
//    }//check year is empty
//
//
//}

//function iscurrentDate() {
//    month = document.getElementById('current_month').value
//    date = document.getElementById('current_date').value
//    year = document.getElementById('current_year').value
//    year_length = year.length
//    month_length = month.length
//    date_length = date.length
//    if ((month != '') && (date != '') && (year != ''))
//    {
//        if (month.match(numericExpression)) {
//            if ((month >= 1) && (month <= 12) && (month_length == 2)) {
//
//                if (date.match(numericExpression)) {
//                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {
//
//                        if (year.match(numericExpression)) {
//                            if (year_length == 4 && (year >= 1900))
//                            {
//                                if (future_date1(($('current_month').value), ($('current_date').value), ($('current_year').value)))
//                                {
//                                    alert("Date of Current is a future date")
//                                    $('current_month').focus()
//                                    $('current_month').highlight()
//                                    return false;
//                                }
//                                else
//                                    return true;
//                            }
//                            else {
//                                alert('Please enter a 4 Digit Year after 1900');
//                                document.getElementById('current_year').focus();
//                                return false;
//                            }//check the length of the year <=4
//
//                        }
//                        else {
//                            alert('Year Must be  4 Digit Number');
//                            document.getElementById('current_year').focus();
//                            return false;
//                        }// check the year is numeric or not
//                    }
//                    else {
//                        alert('Enter a valid date');
//                        document.getElementById('current_date').focus();
//                        return false;
//                    }//check the date in between 1 and 31
//                }
//                else
//                {
//                    alert('Date Must be Numeric');
//                    document.getElementById('current_date').focus();
//                    return false;
//                }//check the date is numeric or not
//
//            }
//            else {
//                alert('Enter a valid Month');
//                document.getElementById('current_month').focus();
//                return false;
//            }//check the month is in range
//
//
//        }
//        else {
//            alert('Month must be Numeric');
//            document.getElementById('current_month').focus();
//            return false;
//        }//check the month is in range
//
//    }
//    else if ((month == '') && (date == '') && (year == '')) {
//
//        return true;
//    }
//    else
//    {
//        alert("Please enter the date correctly");
//        $('current_month').focus();
//        return false;
//    }//check year is empty
//
//
//}
function isSignedDOB() {
    month = document.getElementById('signed_month_101').value
    date = document.getElementById('signed_date_102').value
    year = document.getElementById('signed_year_103').value
    year_length = year.length
    month_length = month.length
    date_length = date.length
    if ((month != '') && (date != '') && (year != '')) {
        if (month.match(numericExpression)) {
            if ((month >= 1) && (month <= 12) && (month_length == 2)) {

                if (date.match(numericExpression)) {
                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {

                        if (year.match(numericExpression)) {
                            if (year_length == 4)
                                return true;
                            else {
                                alert('Year Must be  4 Digit Number');
                                document.getElementById('signed_year_103').focus();
                                return false;
                            }//check the length of the year <=4

                        }
                        else {
                            alert('Year Must be  4 Digit Number');
                            document.getElementById('signed_year_103').focus();
                            return false;
                        }// check the year is numeric or not
                    }
                    else {
                        alert('Enter a valid date');
                        document.getElementById('signed_date_102').focus();
                        return false;
                    }//check the date in between 1 and 31
                }
                else
                {
                    alert('Date Must be Numeric');
                    document.getElementById('signed_date_102').focus();
                    return false;
                }//check the date is numeric or not

            }
            else {
                alert('Enter a valid Month');
                document.getElementById('signed_month_101').focus();
                return false;
            }//check the month is in range


        }
        else {
            alert('Month must be Numeric');
            document.getElementById('signed_month_101').focus();
            return false;
        }//check the month is in range

    }
    else {
        return true;
    }//check year is empty

}


function isOthersInsuredsDOB() {
    month = document.getElementById('other_dob_month').value
    date = document.getElementById('other_dob_date').value
    year = document.getElementById('other_dob_year').value
    year_length = year.length
    month_length = month.length
    date_length = date.length
    if ((month != '') && (year != '') && (date != '')) {
        if (month.match(numericExpression)) {
            if ((month >= 1) && (month <= 12) && (month_length == 2)) {
                if (date.match(numericExpression)) {
                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {
                        if (year.match(numericExpression)) {
                            if (year_length == 4)
                                return true;
                            else {
                                alert('Year Must be  4 Digit Number');
                                document.getElementById('other_dob_year').focus();
                                return false;
                            }//check the length of the year <=4

                        }
                        else {
                            alert('Year Must be  4 Digit Number');
                            document.getElementById('other_dob_year').focus();
                            return false;
                        }// check the year is numeric or not
                    }
                    else {
                        alert('Enter a valid date');
                        document.getElementById('other_dob_date').focus();
                        return false;
                    }//check the date in between 1 and 31
                }
                else
                {
                    alert('Date Must be Numeric');
                    document.getElementById('other_dob_date').focus();
                    return false;
                }//check the date is numeric or not

            }
            else {
                alert('Enter a valid Month');
                document.getElementById('other_dob_month').focus();
                return false;
            }//check the month is in range


        }
        else {
            alert('Month must be Numeric');
            document.getElementById('other_dob_month').focus();
            return false;
        }//check the month is in range
    }
    else
        return true;
}


function IsDateofCurrent()
{
    if ($('cms1500_patient_condition_to_auto_accident_yes').checked == true)
    {
        if (($F('current_month') == '') || ($F('current_date')) == '' || ($F('current_year')) == '')
        {
            alert("Please specify the 'Date of current' as the patient condition related to is due to auto accident");
            $('current_month').focus();
            return false;
        }
        else
            return true;
    }
    else
        return true;

}


// FUNCTIONS TO MERGE isEmpName,isInusrancePlanName,isOtherInsuredsEmpName,isOtherInusrancePlanName
function isOtherInusrancePlanName() {
    if (document.getElementById('cms1500_other_insured_insurance_plan_name').value != '') {
        if (document.getElementById('cms1500_other_insured_insurance_plan_name').value.match(address)) {
            return true;
        } else {
            alert('Please enter valid Insurance Plan name')
            document.getElementById('cms1500_other_insured_insurance_plan_name').focus();
            return false;
        }

    } else {
        return true;
    }

}

function isOtherInsuredsEmpName() {
    if (document.getElementById('cms1500_other_insured_employers_or_school_name').value != '') {
        if (document.getElementById('cms1500_other_insured_employers_or_school_name').value.match(address)) {
            return true;
        } else {
            alert('Please enter valid Other insureds Employ Name/School name')
            document.getElementById('cms1500_other_insured_employers_or_school_name').focus();
            return false;
        }

    } else {
        return true;
    }

}

function isOtherInsuredsFECANumber() {

    if (document.getElementById('cms1500_other_insured_policy_or_group_number').value != '') {
        if (document.getElementById('cms1500_other_insured_policy_or_group_number').value.match(string))
            return true;
        else {
            alert('Other Insureds policy Number Must be String / Numeric');
            document.getElementById('cms1500_other_insured_policy_or_group_number').focus();
            return false;
        }
    }
    else {
        return true;
    }


}

function isOtherInsuredsMiddleName() {
    //alert(document.getElementById('cms1500_other_insured_last_name').value)
    if (document.getElementById('cms1500_other_insured_middle_initial').value != '') {
        if (document.getElementById('cms1500_other_insured_middle_initial').value.match(alphaExp)) {
            return true;
        } else {
            alert('Please enter valid Other Middle First Name')
            document.getElementById('cms1500_other_insured_middle_initial').focus();
            return false;
        }

    } else {

        return true
    }


}

// FUNCTIONS TO MERGE isOtherInsuredsSuffix,isOtherInsuredsFirstName,isOtherInsuredsLastName
function isOtherInsuredsSuffix() {
    //alert(document.getElementById('cms1500_other_insured_last_name').value)
    if (document.getElementById('cms1500_other_insured_suffix').value != '') {
        if (document.getElementById('cms1500_other_insured_suffix').value.match(name)) {
            return true;
        } else {
            alert('Please enter valid Other Suffix')
            document.getElementById('cms1500_other_insured_suffix').focus();
            return false;
        }

    } else {

        return true
    }

}
function isOtherInsuredsFirstName() {
    //alert(document.getElementById('cms1500_other_insured_last_name').value)
    if (document.getElementById('cms1500_other_insured_first_name').value != '') {
        if (document.getElementById('cms1500_other_insured_first_name').value.match(name)) {
            return true;
        } else {
            alert('Please enter valid Other Insureds First Name')
            document.getElementById('cms1500_other_insured_first_name').focus();
            return false;
        }

    } else {
        return true;
    }

}

function isOtherInsuredsLastName() {
    //alert(document.getElementById('cms1500_other_insured_last_name').value)
    if (document.getElementById('cms1500_other_insured_last_name').value != '') {
        if (document.getElementById('cms1500_other_insured_last_name').value.match(name)) {
            return true;
        } else {
            alert('Please enter valid other Insureds Last Name')
            document.getElementById('cms1500_other_insured_last_name').focus();
            return false;
        }

    } else {
        return true;
    }
}
//Validation Insurance PlanName
function isInusrancePlanName() {
    if (document.getElementById('insurance_plan_name').value != '') {
        if (document.getElementById('insurance_plan_name').value.match(address)) {
            return true;
        } else {
            alert('Please enter valid Insurance Plan name')
            document.getElementById('insurance_plan_name').focus();
            return false;
        }

    } else {
        return true
    }

}

function isautoAccidentPlace() {
    auto_accident_place_length = (document.getElementById('auto_accident_place_id').value).length
    if (document.getElementById('auto_accident_place_id').value != '') {
        if (document.getElementById('auto_accident_place_id').value.match(string)) {
            if (auto_accident_place_length == 2)
                return true;
            else
            {
                alert('Auto Accident Place must be 2 Characters Length');
                document.getElementById('auto_accident_place_id').focus();
                return false;

            }
        }
        else
        {
            alert('Auto Accident Place must be String');
            document.getElementById('auto_accident_place_id').focus();
            return false;
        }
    }
    else
    {
        return true;
    }
}
function isEmpName() {
    if (document.getElementById('emp_name').value != '') {
        if (document.getElementById('emp_name').value.match(address)) {
            return true;
        } else {
            alert('Please enter valid Employ Name/School name')
            document.getElementById('emp_name').focus();
            return false;
        }

    } else {
        return true
    }

}

//validation :FECA NUMBER
function isFECANumber(facilityName) {

    if (document.getElementById('feca').value != '') {
        if (document.getElementById('feca').value.match(org))
            return true;
        else {
            alert('FECA Number Must be Numeric');
            document.getElementById('feca').focus()
            return false;
        }
    }
    else {
        if(facilityName != 'PCN')
        return true;
        else
            {
                alert("Payer ID cannot be blank");
                $('feca').focus()
                return false;
            }
    }


}
function isinsuranceplanname(facilityName)
{
    if($('insurance_plan_name').value == '')
        {
            if(facilityName != 'PCN')
            return true;
        else
            {
                alert("Insurance Payer Name cannot be blank");
                $('insurance_plan_name').focus()
                return false;
            }
        }
     else
         return true
}

function isInsuredsTelePhone() {
    if (document.getElementById('cms1500_insured_telephone').value != '') {
        if (document.getElementById('cms1500_insured_telephone').value.match(numericExpression))
            return true;
        else {
            alert('PhoneNumber Must be  Numeric');
            document.getElementById('cms1500_insured_telephone').focus();
            return false;
        }
    }
    else {
        return true;
    }

}

//// validation for the insureds'DOB
//function isInsuredsDOB() {
//    //
//    month = document.getElementById('cms15001_insured_dob_month').value
//    date = document.getElementById('cms15001_insured_dob_date').value
//    year = document.getElementById('cms15001_insured_dob_year').value
//    year_length = year.length
//    month_length = month.length
//    date_length = date.length
//    if ((month != '') && (date != '') && (year != '')) {
//        if (month.match(numericExpression)) {
//            if ((month >= 1) && (month <= 12) && (month_length == 2)) {
//
//                if (date.match(numericExpression)) {
//                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {
//
//                        if (year.match(numericExpression)) {
//                            if ((year_length == 4) && (year >= 1900) && (year <= 2050))
//                            {
//                                threeMonthsPrior = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
//                                current_date = new Date(year, month, date)
//                                if (current_date >= threeMonthsPrior)
//                                    return true
//                                else
//                                {
//                                    agree = confirm('Date you entered needs to be confirmed. Are you sure to continue?');
//                                    if(agree == true)
//                                        return true
//                                    else
//                                    {
//                                        $('cms15001_insured_dob_month').focus()
//                                        $('cms15001_insured_dob_month').highlight()
//                                        return false
//                                    }
//                                }
//                                if (future_date1(($('cms15001_insured_dob_month').value), ($('cms15001_insured_dob_date').value), ($('cms15001_insured_dob_year').value)))
//                                {
//                                    alert("Insured's DOB is a future date")
//                                    $('cms15001_insured_dob_month').focus()
//                                    $('cms15001_insured_dob_month').highlight()
//                                    return false;
//                                }
//                                else
//                                    return true;
//
//                            }
//                            else {
//                                alert('Year Must be  4 Digit Number and Year in between 1900 and 2050');
//                                document.getElementById('cms15001_insured_dob_year').focus();
//                                return false;
//                            }//check the length of the year <=4
//
//                        }
//                        else {
//                            alert('Year Must be  4 Digit Number');
//                            document.getElementById('cms15001_insured_dob_year').focus();
//                            return false;
//                        }// check the year is numeric or not
//                    }
//                    else {
//                        alert('Enter a valid date');
//                        document.getElementById('cms15001_insured_dob_date').focus();
//                        return false;
//                    }//check the date in between 1 and 31
//                }
//                else
//                {
//                    alert('Date Must be Numeric');
//                    document.getElementById('cms15001_insured_dob_date').focus();
//                    return false;
//                }//check the date is numeric or not
//
//            }
//            else {
//                alert('Enter a valid Month');
//                document.getElementById('cms15001_insured_dob_month').focus();
//                return false;
//            }//check the month is in range
//
//
//        }
//        else {
//            alert('Month must be Numeric');
//            document.getElementById('cms15001_insured_dob_month').focus();
//            return false;
//        }//check the month is in range
//
//
//    }
//    else {
//        //alert('Date Field is Empty');
//        //isHighLighted();
//        //document.getElementById('cms15001_insured_dob_date').focus();
//        return true;
//    }//check year is empty
//
//}


// validation for the insureds Zip code
function isInsuredZipCode() {
    if ($('cms1500_insured_zipcode').value != '') {
        if ($('cms1500_insured_zipcode').value.match(numericExpression)) {
            if ($('cms1500_insured_zipcode').value.match(zipcode_check))
                return true;
            else {
                alert('Zip Code must be  5 Digits or 9 Digits')
                $('cms1500_insured_zipcode').focus();
                return false;
            }

        } else {
            alert('Please enter Numerical values for Zip Code')
            $('cms1500_insured_zipcode').focus();
            return false;
        }

    } else {
        alert('Please enter Insured\'s Zip Code')
        $('cms1500_insured_zipcode').focus();
        return false;
    }

}

// Insureds City
function isInsuredsCity() {
    if ($('cms1500_insured_city').value != '') {
        if ($('cms1500_insured_city').value.match(city_exp))
            return true;
        else {
            alert('Please enter valid Insureds City');
            $('cms1500_insured_city').focus();
            return false;
        }
    }
    else {
        alert('Please enter Insureds City');
        $('cms1500_insured_city').focus();
        return false;
    }

}
// Insureds Address
function isInsuredsAddress() {

    if ($('cms1500_insured_address').value != '')
    {
        if ($('cms1500_insured_address').value.match(address))
            return true
        else {
            alert('Address must be String')
            $('cms1500_insured_address').focus();
            return false
        }
    }
    else
        alert('Please enter Insured\'s Address')
    $('cms1500_insured_address').focus();
    return false
}


function isInsuredsState() {
    if ((($('cms1500_insured_state').value) != '--') && (($('cms1500_insured_state').value) != '')) {
        return true
    } else {
        alert('If State code is not present, capture XX, otherwise select correct State code');
        $('cms1500_insured_state').focus();
        return false;
    }
}


function isInsuredSuffix(facilityName) {
    if (document.getElementById('cms1500_insured_suffix').value != '') {

        document.getElementById('cms1500_insured_suffix').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_insured_suffix').value.match(name)) {
           if(facilityName != 'PCN')
            {
                if (document.getElementById('cms1500_insured_suffix').value != 'MD')
                    return true;
                else
                {
                    alert('MD Do not Allow in Suffix')
                    document.getElementById('cms1500_insured_suffix').focus();
                    return false;
                }
            }
              else if(facilityName == 'PCN')
               return true;
        }
         else {
            alert('Please enter valid Insured suffix')
            document.getElementById('cms1500_insured_suffix').focus();
            return false;
        }

    } else {

        return true
    }
}

//Validation for the Insured Initial
function isInsuredInitial() {
    if (document.getElementById('cms1500_insured_middle_initial').value != '') {
        document.getElementById('cms1500_insured_middle_initial').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_insured_middle_initial').value.match(alphaExp)) {
            return true;
        } else {
            alert('Please enter valid Initial name')
            document.getElementById('cms1500_insured_middle_initial').focus();
            return false;
        }

    } else {

        return true
    }
}

//Validation Insureds's Last Name
function isInsuredLastName() {
    if (document.getElementById('cms1500_insured_last_name').value != '') {
        document.getElementById('cms1500_insured_last_name').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_insured_last_name').value.match(name)) {
            return true;
        } else {
            alert('Please enter valid Last name')
            document.getElementById('cms1500_insured_last_name').focus();
            return false;
        }

    } else {
        alert('Please enter  Insured\'s Last name')
        isHighLighted();
        document.getElementById('cms1500_insured_last_name').focus();
        return false
        //return true;
    }
}

//Validation Insured's First Name
function isInsuredFirstName() {
    if (document.getElementById('cms1500_insured_first_name').value != '') {
        document.getElementById('cms1500_insured_first_name').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_insured_first_name').value.match(name)) {
            return true;
        } else {
            alert('Please enter valid First name')
            document.getElementById('cms1500_insured_first_name').focus();
            return false;
        }

    } else {
        alert('Please enter  Insured\'s First name')
        isHighLighted();
        document.getElementById('cms1500_insured_first_name').focus();
        return false
        //return true
    }
}

///////////////////////insured ////////End


//Validation of the Inusreds ID Number
function isInsuredsNumber() {
    if (document.getElementById('insureds_id').value != '') {
        document.getElementById('insureds_id').style.backgroundColor = 'white'
        if (document.getElementById('insureds_id').value.match(org))
            return true;
        else {
            alert('INSUREDS ID Must be  Numeric');
            document.getElementById('insureds_id').focus();
            return false;
        }
    }
    else {
        alert('Please enter  Insured\'s Id Number')
        isHighLighted();
        document.getElementById('insureds_id').focus();
        return false
        //return true;
    }
}
////////////////validation for Patient Filed//////begin
//Validation for the Patients' Telephone
function isTelePhone() {
    if (document.getElementById('cms1500_patient_telephone').value != '') {
        if (document.getElementById('cms1500_patient_telephone').value.match(numericExpression))
            return true;
        else {
            alert('PhoneNumber Must be  Numeric');
            document.getElementById('cms1500_patient_telephone').focus();
            return false;
        }
    }
    else {

        return true;
    }
}


// validation for the Zip code
function isZipCode() {
    if (document.getElementById('cms1500_patient_zipcode').value != '') {
        document.getElementById('cms1500_patient_zipcode').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_patient_zipcode').value.match(numericExpression)) {
            if (document.getElementById('cms1500_patient_zipcode').value.match(zipcode_check))
                return true;
            else
            {
                alert('Zip Code Must be 5 Digits or 9 Digits')
                $('cms1500_patient_zipcode').focus();
                return false;
            }
        } else {
            alert('Please enter Numerical values for Zip Code')
            $('cms1500_patient_zipcode').focus();
            return false;
        }
    } else {
        alert('Please enter Patient Zip Code')
        $('cms1500_patient_zipcode').focus();
        return false;
    }

}
//validation for the patient's city
function isCity() {
    if (document.getElementById('cms1500_patient_city').value != '') {
        document.getElementById('cms1500_patient_city').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_patient_city').value.match(city_exp))
            return true;
        else {
            alert('Please enter valid Patient City');
            $('cms1500_patient_city').focus();
            return false;
        }
    }
    else {
        alert('Please enter Patient City');
        $('cms1500_patient_city').focus();
        return false;
    }
}

function isPatientState() {
    if ((($('cms1500_patient_state').value) != '--') && (($('cms1500_patient_state').value) != '')) {
        return true
    } else {
        alert('If State code is not present, capture XX, otherwise select correct State code');
        $('cms1500_patient_state').focus();
        return false;
    }
}


//Validation for Patient_address checking the null
function isAddress() {

    if (document.getElementById('cms1500_patient_address').value != '') {
        document.getElementById('cms1500_patient_address').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_patient_address').value.match(address))
            return true
        else {
            alert('Please enter only string values')
            $('cms1500_patient_address').focus()
            return false
        }
    }
    else {
        alert('Please enter Patient Address')
        $('cms1500_patient_address').focus()
        return false
    }

}


//validation for the DOB of the Patient
function isDOB(mm,dd,yy) {
    //
    month = $(mm).value
    date = $(dd).value
    year = $(yy).value

    year_length = year.length
    month_length = month.length
    date_length = date.length
    if ((month != '') && (date != '') && (year != '')) {

        if (month.match(numericExpression)) {
            if ((month >= 1) && (month <= 12) && (month_length == 2)) {

                if (date.match(numericExpression)) {
                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {

                        if (year.match(numericExpression)) {
                            if ((year_length == 4) && (year >= 1900) && (year <= 2050))
                            {
                                var date1 = new Date(year, month - 1, date);
                                if (date1 > now)
                                {
                                    alert("DOB is a future date")
                                    $(mm).focus()
                                    $(mm).highlight()
                                    return false;
                                }
                                else
                                    return true;
                            }

                            else {
                                alert('Year Must be  4 Digit Number/Year Must be in between 1900 and 2050');
                                $(yy).focus();
                                return false;
                            }//check the length of the year <=4

                        }
                        else {
                            alert('Year Must be  4 Digit Number');
                            $(yy).focus();
                            return false;
                        }// check the year is numeric or not
                    }
                    else {
                        alert('Enter a valid date');
                        $(dd).focus();
                        return false;
                    }//check the date in between 1 and 31
                }
                else
                {
                    alert('Date Must be Numeric');
                    $(dd).focus();
                    return false;
                }//check the date is numeric or not

            }
            else {

                alert('Enter a valid Month');
                $(mm).focus();
                return false;
            }//check the month is in range


        }
        else {
            alert('Month must be Numeric');
            $(mm).focus();
            return false;
        }//check the month is in range

    }
    else {
        alert('Please enter the birth date')
        isHighLighted();
        $(mm).focus();
        return false

        //return true;
    }//check year is empty


}
//validation for the DOB for non mandatory fields
function isDOB_nonmandatory(mm,dd,yy) {
    //
    month = $(mm).value
    date = $(dd).value
    year = $(yy).value

    year_length = year.length
    month_length = month.length
    date_length = date.length
    if ((month != '') && (date != '') && (year != '')) {

        if (month.match(numericExpression)) {
            if ((month >= 1) && (month <= 12) && (month_length == 2)) {

                if (date.match(numericExpression)) {
                    if ((date >= 1) && (date <= 31) && (date_length == 2)) {

                        if (year.match(numericExpression)) {
                            if ((year_length == 4) && (year >= 1900) && (year <= 2050))
                            {
                                var date1 = new Date(year, month - 1, date);
                                if (date1 > now)
                                {
                                    alert("DOB is a future date")
                                    $(mm).focus()
                                    $(mm).highlight()
                                    return false;
                                }
                                else
                                    return true;
                            }

                            else {
                                alert('Year Must be  4 Digit Number/Year Must be in between 1900 and 2050');
                                $(yy).focus();
                                return false;
                            }//check the length of the year <=4

                        }
                        else {
                            alert('Year Must be  4 Digit Number');
                            $(yy).focus();
                            return false;
                        }// check the year is numeric or not
                    }
                    else {
                        alert('Enter a valid date');
                        $(dd).focus();
                        return false;
                    }//check the date in between 1 and 31
                }
                else
                {
                    alert('Date Must be Numeric');
                    $(dd).focus();
                    return false;
                }//check the date is numeric or not

            }
            else {

                alert('Enter a valid Month');
                $(mm).focus();
                return false;
            }//check the month is in range


        }
        else {
            alert('Month must be Numeric');
            $(mm).focus();
            return false;
        }//check the month is in range

    }
    else if((month == '') && (date == '') && (year == '')){
        return true;
    }
    else
        {
            alert("Enter a valid date");
            $(mm).focus();
            return false;
        }


}
//Validation for the Initial
function isInitial() {
    if (document.getElementById('cms1500_patient_middle_initial').value != '') {
        document.getElementById('cms1500_patient_middle_initial').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_patient_middle_initial').value.match(alphaExp)) {
            return true;
        } else {
            alert('Please enter valid Initial name')

            document.getElementById('cms1500_patient_middle_initial').focus();
            return false;
        }

    } else {

        return true
    }
}

//Validation Patient's First Name
function isFirstName() {
    if (document.getElementById('cms1500_patient_first_name').value != '') {
        document.getElementById('cms1500_patient_first_name').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_patient_first_name').value.match(name)) {
            return true;
        } else {
            alert('Please enter valid First name')

            document.getElementById('cms1500_patient_first_name').focus();

            return false;
        }

    } else {
        alert('Please enter  First name')
        isHighLighted();
        document.getElementById('cms1500_patient_first_name').focus();
        return false
    }
}
function isSuffix(facilityName) {

    if (document.getElementById('cms1500_patient_suffix').value != '') {
        document.getElementById('cms1500_patient_suffix').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_patient_suffix').value.match(name)) {
             if(facilityName != 'PCN')
           {
            if (document.getElementById('cms1500_patient_suffix').value != 'MD')
                return true;
            else
            {
                alert('Do not allow MD in Suffix name')
                document.getElementById('cms1500_patient_suffix').focus();
                return false;
            }
           }
            else if(facilityName == 'PCN')
               return true
        }
         else {
            alert('Please enter valid Suffix name')
            document.getElementById('cms1500_patient_suffix').focus();
            return false;
        }

    } else {

        return true
    }
}


//Validation Patient's Last Name
function isLastName() {
    if (document.getElementById('cms1500_patient_last_name').value != '') {
        document.getElementById('cms1500_patient_last_name').style.backgroundColor = 'white'
        if (document.getElementById('cms1500_patient_last_name').value.match(name)) {
            return true;
        } else {

            alert('Please enter valid Last name')
            document.getElementById('cms1500_patient_last_name').focus();

            return false;
        }

    } else {
        alert('Please enter Last name')
        isHighLighted();
        document.getElementById('cms1500_patient_last_name').focus();
        return false
    }
}

//////////validation ofr the Patient field///end

/// Validation In Javascript Main Function Start////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function iscount()
{
    if (count == 0)
    {
        alert('Atleast one service line must be added')
        document.getElementById('dateofservicefrom').focus();
        return false;
    }
    else
    {
        return true
    }
}
function errorcheck() {
    var incorrect = document.getElementById('incorrect').value
    var qa_c = document.getElementById('qa_comm').value
    var sel_ind = document.getElementById('status').selectedIndex
    if (incorrect == '') {
        alert('Incorrect Field is Empty')
        $('incorrect').focus();
        return false;
    }
    else {
        if (sel_ind == 2 || sel_ind == 1) {
            if ((qa_c.match(/^[\s]+$/)) || (qa_c == "")) {
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

}

function checkIndex() {
    var selected_index = document.getElementById('status').selectedIndex
    if (selected_index == 0)
        document.getElementById('incorrect').value = 0;
    else
        document.getElementById('incorrect').value = document.getElementById('incorrect').value;
}


function diagnosisorinjury_duplication()
{

    /*
     if((($('injury1').value != "")&&($('injury2').value != "")&&($('injury1').value == $('injury2').value))||(($('injury1').value != "")&&($('injury3').value != "")&&($('injury1').value == $('injury3').value))||(($('injury1').value != "")&&($('injury4').value != "")&&($('injury1').value == $('injury4').value))||(($('injury2').value != "")&&($('injury3').value != "")&&($('injury2').value == $('injury3').value))||(($('injury2').value != "")&&($('injury4').value != "")&&($('injury2').value == $('injury4').value))||(($('injury3').value != "")&&($('injury4').value != "")&&($('injury3').value == $('injury4').value)))

     // if(($('injury1').value == $('injury2').value) || ($('injury1').value == $('injury3').value) || ($('injury1').value == $('injury4').value)|| ($('injury2').value == $('injury3').value)|| ($('injury2').value == $('injury4').value)||($('injury3').value ==  $('injury4').value))
     {   
     alert("Diagnosis codes cannot have same value");
     $('injury1').focus();
     return false;
     }
     else
     return true;
     */
    if (($('injury1').value != "") && ($('injury2').value != "") && ($('injury1').value == $('injury2').value))
    {
        alert("Diagnosis codes cannot have same value");
        $('injury2').focus();
        return false;
    }


    else if (($('injury1').value != "") && ($('injury3').value != "") && ($('injury1').value == $('injury3').value))
    {
        alert("Diagnosis codes cannot have same value");
        $('injury3').focus();
        return false;
    }


    else if (($('injury1').value != "") && ($('injury4').value != "") && ($('injury1').value == $('injury4').value))
    {
        alert("Diagnosis codes cannot have same value");
        $('injury4').focus();
        return false;
    }

    else if (($('injury2').value != "") && ($('injury3').value != "") && ($('injury2').value == $('injury3').value))
    {
        alert("Diagnosis codes cannot have same value");
        $('injury3').focus();
        return false;
    }


    else if (($('injury2').value != "") && ($('injury4').value != "") && ($('injury2').value == $('injury4').value))
    {
        alert("Diagnosis codes cannot have same value");
        $('injury4').focus();
        return false;
    }


    else if (($('injury3').value != "") && ($('injury4').value != "") && ($('injury3').value == $('injury4').value))
    {
        alert("Diagnosis codes cannot have same value");
        $('injury4').focus();
        return false;
    }
    else
        return true;
}


function npivalidation()
{
    if ((isValidNPI($('ref_prv_npi').value)) == false)
    {
        //alert("NPI Number must be 10 digits");
        $('ref_prv_npi').focus();
        return false;
    }
    if ((isValidNPI($('cms1500_service_facility_npi_id').value)) == false)
    {
        //alert("NPI Number must be 10 digits");
        $('cms1500_service_facility_npi_id').focus();
        return false;
    }
    if ((isValidNPI($('bill_a').value)) == false)
    {
        //alert("NPI Number must be 10 digits");
        $('bill_a').focus();
        return false;
    }
    return true;
}
function batch_type()
{
    batch_name = $F('batch_type');
    if (batch_name.include('PCN'))
    type = 'PCN';
    else
    type = 'AMLI';
    return type;
}

function batch_id()
{
    batch_name = $F('batchid');
    if (batch_name.include('PCN'))
    type = 'PCN';
    else
    type = 'AMLI';
    return type;
}

function formValidator_qa() {

    var selected_index = document.getElementById('status').selectedIndex
    var facilityName = batch_id();
    if (document.getElementById('status').selectedIndex == 0)
    {

        if (flag == 1) {
            if ((serviceLineValidations()) && (isPatientState()) && (isInsuredsState()) && (isOrganizationName()) && (isRenderingProviderIdPresent()) && (IS_patient_relationship()) && (Compare_Totalcharge_With_Chargessum())  && (payer_name()) && (payer_addrone()) && (payer_addrtwo())  && (payer_city()) && (payer_state()) && (payer_zipcode()) && (placeofservicecheckinocr()) && (isBillingOrganizationState()) && (isLastName()) && (isFirstName()) && (isSuffix(facilityName)) && (isInitial()) && (isAddress()) && (isCity())  && (isZipCode()) && (isTelePhone()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isInsuredsTelePhone()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) &&(isEmpName()) && (isInusrancePlanName()) && (isOtherInsuredsLastName()) && (isOtherInsuredsSuffix()) && (isOtherInsuredsFirstName()) && (isOtherInsuredsMiddleName()) && (isOtherInsuredsFECANumber()) && (isDOB_nonmandatory('other_dob_month','other_dob_date','other_dob_year')) && (isOtherInsuredsEmpName()) && (isOtherInusrancePlanName()) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillingOrganisationTelePhone()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (errorcheck()) && (IsDateofCurrent()) && (isRenderingProviderNPI()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (npivalidation()) && (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')) && (isfromdateempty('occu_from_month','occu_from_date','occu_from_year','occu_to_month','occu_to_date','occu_to_year')) && (isfromdateempty('service_from_month','service_from_date','service_from_year','service_to_month','service_to_date','service_to_year')))
            {
                servicelinecount = serviceline_count();
                if (servicelinecount != 0){
                    var agree = confirm("Are you sure you wish to continue?");
                    if (agree == true)
                        if(submitted)
                            return false;
                        else
                        {
                            submitted = true;
                            return true;
                        }
                    else
                        return false;
                }
                else
                {
                    alert("Please add atleast one serviceline");
                    $('dateofservicefrom').focus();
                    return false;
                }
            }
            else
                return false
        }
        else if ((serviceLineValidations()) && (isPatientState()) && (isInsuredsState()) && (IS_patient_relationship()) && (Compare_Totalcharge_With_Chargessum()) && (payer_name()) && (payer_addrone()) && (payer_addrtwo()) && (payer_city()) && (payer_state()) && (payer_zipcode()) && (placeofservicecheckinocr()) && (isBillingOrganizationState()) && (isLastName()) && (isSuffix(facilityName)) && (isFirstName()) && (isInitial()) && (isAddress()) && (isCity()) && (isZipCode()) && (isTelePhone()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isInsuredsTelePhone()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) && (isEmpName()) && (isInusrancePlanName()) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (isServiceLinePlaceOfservice()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationName()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillingOrganisationTelePhone()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (errorcheck()) && (IsDateofCurrent()) && (isRenderingProviderNPI()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (npivalidation()) && (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')) && (isfromdateempty('occu_from_month','occu_from_date','occu_from_year','occu_to_month','occu_to_date','occu_to_year')) && (isfromdateempty('service_from_month','service_from_date','service_from_year','service_to_month','service_to_date','service_to_year')))

        {
            servicelinecount = serviceline_count();
            if (servicelinecount != 0){
                var agree = confirm("Are you sure you wish to continue?");
                if (agree == true)
                    if(submitted)
                        return false;
                    else
                    {
                        submitted = true;
                        return true;
                    }
                else
                    return false;

            }
            else
            {
                alert("Please add atleast one serviceline");
                $('dateofservicefrom').focus();
                return false;
            }
        }

        else
            return false

    }

    else
    {
        if (errorcheck()) {

            return true
        }
        else
            return false
    }
// End
}

function formvalidator_completedclaim()
{
    var facilityName = batch_id();
    if (flag == 1) {
            if ((serviceLineValidations()) && (isPatientState()) && (isInsuredsState()) && (isOrganizationName()) && (isRenderingProviderIdPresent()) && (IS_patient_relationship()) && (Compare_Totalcharge_With_Chargessum())  && (payer_name()) && (payer_addrone()) && (payer_addrtwo())  && (payer_city()) && (payer_state()) && (payer_zipcode()) && (placeofservicecheckinocr()) && (isBillingOrganizationState()) && (isLastName()) && (isFirstName()) && (isSuffix(facilityName)) && (isInitial()) && (isAddress()) && (isCity())  && (isZipCode()) && (isTelePhone()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isInsuredsTelePhone()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) && (isEmpName()) && (isInusrancePlanName()) && (isOtherInsuredsLastName()) && (isOtherInsuredsSuffix()) && (isOtherInsuredsFirstName()) && (isOtherInsuredsMiddleName()) && (isOtherInsuredsFECANumber()) && (isDOB_nonmandatory('other_dob_month','other_dob_date','other_dob_year')) && (isOtherInsuredsEmpName()) && (isOtherInusrancePlanName()) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillingOrganisationTelePhone()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (errorcheck()) && (IsDateofCurrent()) && (isRenderingProviderNPI()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (npivalidation()) && (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')) && (isfromdateempty('occu_from_month','occu_from_date','occu_from_year','occu_to_month','occu_to_date','occu_to_year')) && (isfromdateempty('service_from_month','service_from_date','service_from_year','service_to_month','service_to_date','service_to_year')))
            {
                servicelinecount = serviceline_count();
                if (servicelinecount != 0){
                var agree = confirm("Are you sure you wish to continue?");
                if (agree == true)
                    if(submitted)
                    return false;
                else
                {
                    submitted = true;
                    return true;
                }
                else
                    return false;
            }
            else
                {
                    alert("Please add atleast one serviceline");
                    $('dateofservicefrom').focus();
                    return false;
                }
            }
            else
                return false
        }
        else if ((serviceLineValidations()) && (isPatientState()) && (isInsuredsState()) && (IS_patient_relationship()) && (Compare_Totalcharge_With_Chargessum()) && (payer_name()) && (payer_addrone()) && (payer_addrtwo()) && (payer_city()) && (payer_state()) && (payer_zipcode()) && (placeofservicecheckinocr()) && (isBillingOrganizationState()) && (isLastName()) && (isSuffix(facilityName)) && (isFirstName()) && (isInitial()) && (isAddress()) && (isCity()) && (isZipCode()) && (isTelePhone()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isInsuredsTelePhone()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) && (isEmpName()) && (isInusrancePlanName()) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationName()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillingOrganisationTelePhone()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (IsDateofCurrent()) && (isRenderingProviderNPI()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (npivalidation()) && (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')) && (isfromdateempty('occu_from_month','occu_from_date','occu_from_year','occu_to_month','occu_to_date','occu_to_year')) && (isfromdateempty('service_from_month','service_from_date','service_from_year','service_to_month','service_to_date','service_to_year')))
        {
                            servicelinecount = serviceline_count();
                if (servicelinecount != 0){
            var agree = confirm("Are you sure you wish to continue?");
            if (agree == true)
                if(submitted)
                    return false;
                else
                {
                    submitted = true;
                    return true;
                }
            else
                return false;
                }
                else
                {
                    alert("Please add atleast one serviceline");
                    $('dateofservicefrom').focus();
                    return false;
                }
        }
        else
            return false
}

function IS_patient_relationship()
{
    if (($('cms1500_patient_relationship_to_insured_self').checked == false) && ($('cms1500_patient_relationship_to_insured_spouse').checked == false) && ($('cms1500_patient_relationship_to_insured_child').checked == false) && ($('cms1500_patient_relationship_to_insured_others').checked == false) && ($('cms1500_patient_relationship_to_insured_none').checked) == false)
    {
        alert("Select one from Patient relationship to insured");
        $('cms1500_patient_relationship_to_insured_self').focus();
        return false;
    }
    else
        return true;
}


function Compare_Totalcharge_With_Chargessum() {
    charge_sum = 0.00;
    for (k = 1; k <= 200;k++)
    {
        if ($('lineinformation_charges'+k) != null) {
            if($('lineinformation_charges'+k).value != "")
                {
            charge_sum += parseFloat($('lineinformation_charges'+k).value)
                }

        }
    }
    total_charges = $('cms1500_total_charge').value;
    charge_round = (Math.round(charge_sum * 100) / 100);
    if (charge_round == total_charges)
    {
        return true;
    }
    else
    {
        alert("Total Charge is not matching with sum of service line charges");
//        $('cms1500_total_charge').value = charge_round;                       Commented this line as per ticket #14413
        $('cms1500_total_charge').focus()
        return false
    }
}


function IS_Place_Of_Service(line)
{
    if ($('lineinformation_placeof_service' + line).value == '')
    {
        alert("Place of service field cannot be blank");
        ($('lineinformation_placeof_service' + line)).focus();
        return false;
    }
    else if (($('lineinformation_placeof_service' + line).value != '') && ($('lineinformation_placeof_service' + line).value.match(placeofserviceregexp)))
    {
        return true;
    }
    else
    {
        alert("Place of service must be 2 digit numbers");
        ($('lineinformation_placeof_service' + line)).focus();
        return false;
    }
}

function add()
{
    amountpaid = document.getElementById('cms1500_amount_paid').value;
    //totalcharge = document.getElementById(22).value;
    balance = parseFloat(document.getElementById("cms1500_total_charge").value) - parseFloat(amountpaid);
    if (isNaN(balance))
        document.getElementById('cms1500_balance_due').value = '';
    else
        document.getElementById('cms1500_balance_due').value = balance;

}


function formValidator() {
    //return true
    //alert(flag)

facilityName = batch_type();
    if (flag == 1) {
        if ((isLastName()) && (isFirstName()) && (isSuffix(facilityName)) && (isInitial()) && (isAddress()) && (isCity()) && (isZipCode()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isInsuredsTelePhone()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) && (isOtherInsuredsLastName()) && (isOtherInsuredsFirstName()) && (isDOB_nonmandatory('other_dob_month','other_dob_date','other_dob_year')) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (iscount()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationName()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillingOrganisationTelePhone()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (isBillingOrganizationState()) && (IS_patient_relationship()) && (IsDateofCurrent()) && (isPatientState()) && (isInsuredsState()) && (payer_name()) && (payer_addrone()) && (payer_addrtwo()) && (payer_city()) && (payer_state()) && (payer_zipcode()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (tot_charge_nonocr()) && (npivalidation()) && (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')) && (isfromdateempty('occu_from_month','occu_from_date','occu_from_year','occu_to_month','occu_to_date','occu_to_year')) && (isfromdateempty('service_from_month','service_from_date','service_from_year','service_to_month','service_to_date','service_to_year'))&&(accept_assignment()))
        
        {
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
            return false
    }
    else if ((isLastName()) && (isSuffix(facilityName)) && (isFirstName()) && (isInitial()) && (isAddress()) && (isCity()) && (isZipCode()) && (isTelePhone()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isInsuredsTelePhone()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (iscount()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationName()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillingOrganisationTelePhone()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (isBillingOrganizationState()) && (IS_patient_relationship()) && (IsDateofCurrent()) && (isPatientState()) && (isInsuredsState()) && (payer_name()) && (payer_addrone()) && (payer_addrtwo()) && (payer_city()) && (payer_state()) && (payer_zipcode()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (tot_charge_nonocr()) && (npivalidation()) && (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')) && (isfromdateempty('occu_from_month','occu_from_date','occu_from_year','occu_to_month','occu_to_date','occu_to_year')) && (isfromdateempty('service_from_month','service_from_date','service_from_year','service_to_month','service_to_date','service_to_year')) && (accept_assignment()))
    // deleted (isRefPrvNPI()) , (isOrganisationA()) , (isBillOrganisationA())
    {
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
        return false
}

// End
function formValidatorOCR() {
    //return true
    //alert(flag)
var facilityName = batch_type()

    if (flag == 1) {

        if ((serviceLineValidations()) && (isLastName()) && (isFirstName()) && (isSuffix(facilityName)) && (isInitial()) && (isAddress()) && (isCity()) && (isZipCode()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) && (isOtherInsuredsLastName()) && (isOtherInsuredsFirstName()) && (isDOB_nonmandatory('other_dob_month','other_dob_date','other_dob_year')) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationName()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillingOrganizationState()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (isRenderingProviderIdPresent()) && (family1()) && (isRenderingProviderNPI()) && (IS_patient_relationship()) && (Compare_Totalcharge_With_Chargessum()) && (IsDateofCurrent()) && (isPatientState()) && (isInsuredsState()) && (payer_name()) && (payer_addrone()) && (payer_addrtwo()) && (payer_city()) && (payer_state()) && (payer_zipcode()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (placeofservicecheckinocr()) && (npivalidation()) && (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')) && (isfromdateempty('occu_from_month','occu_from_date','occu_from_year','occu_to_month','occu_to_date','occu_to_year')) && (isfromdateempty('service_from_month','service_from_date','service_from_year','service_to_month','service_to_date','service_to_year')))
        {
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
            return false
    }
    else if ((serviceLineValidations()) && (isLastName()) && (isSuffix(facilityName)) && (isFirstName()) && (isInitial()) && (isAddress()) && (isCity()) && (isZipCode()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationName()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillingOrganizationState()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (isRenderingProviderIdPresent()) && (family1()) && (isRenderingProviderNPI()) && (IS_patient_relationship()) && (Compare_Totalcharge_With_Chargessum()) && (IsDateofCurrent()) && (isPatientState()) && (isInsuredsState()) && (payer_name()) && (payer_addrone()) && (payer_addrtwo()) && (payer_city()) && (payer_state()) && (payer_zipcode()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (placeofservicecheckinocr()) && (npivalidation()) && (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')) && (isfromdateempty('occu_from_month','occu_from_date','occu_from_year','occu_to_month','occu_to_date','occu_to_year')) && (isfromdateempty('service_from_month','service_from_date','service_from_year','service_to_month','service_to_date','service_to_year')))
    {
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
        return false
}


function checkDiagonosis() {
    var temp_flag1 = 0;
    temp_value = document.getElementById('diagnosis_pointer_id').value
    for (count_i = 0; count_i < temp_value.length; count_i++) {
        x = parseInt(temp_value / 10);
        temp_value = temp_value % 10;
        if (temp_value == 0) {
            temp_flag1 = 1;
            break;
        }
        else if (temp_value > 4) {
            temp_flag1 = 1;
            break;


        }
        temp_value = x;
    }
    return temp_flag1;
}
/*
 function isDiganosis_ServiceLine(){
 if(document.getElementById('diagnosis_pointer_id').value!=''){
 document.getElementById('diagnosis_pointer_id').style.backgroundColor = 'white'
 if(document.getElementById('diagnosis_pointer_id').value.match(numericExpression)){
 if(checkDiagonosis()==0)
 return true
 else{
 alert('Diagonosis Pointer Not in the Range{1,2,3,4}')
 return false;
 }
 }
 else
 {
 alert('Service Line Diganosis Pointer must be Numeric');
 document.getElementById('diagnosis_pointer_id').focus();
 return false;
 }
 }else{
 alert("Diaganosis Pointer Cannot be Empty");
 document.getElementById('diagnosis_pointer_id').focus();
 return false;

 }
 }    */


function epstd11()
{
    if ((document.getElementById('epsdt_familycharge_id1').value != '' ))
    {
        if (!(document.getElementById('epsdt_familycharge_id1').value.match(string))) {
            alert('Epst must be a string')
            document.getElementById('epsdt_familycharge_id1').focus();
            return false

        }
        else
        {
            return true
        }
    }
    else
    {
        return true
    }
}
//function equateCharges(){
//    var charges = document.getElementsByClassName("collect_charges")
//    var value_of_total_charge = $F('cms1500_total_charge');
//    var total_charges = 0;
//    for(i=0;i < charges.length;i++){
//        //                            alert(charges[i].value);
//        total_charges = total_charges + parseFloat(charges[i].value);
//    }
//                        
//    if(value_of_total_charge == total_charges)
//    {
//        return true
//        }
//    else
//    {
//        alert("Total Charge is not matching with service line charges");return false
//        }
//}
function tot_charge_nonocr() {
    var charges = $$(".amount")
    var value_of_total_charge = $F('cms1500_total_charge');
    var total_charges = 0;
    for (i = 0; i < charges.length; i++) {
        //                            alert(charges[i].value);
        total_charges = total_charges + parseFloat(charges[i].value);
    }
    if (value_of_total_charge != '')
    {
            // check if the total charge is an integer or float
            if (parseInt(total_charges) === total_charges)
                {
                  if (value_of_total_charge == total_charges)
                    {
                        return true;
                    }
                    else
                    {
                        alert("Total Charge is not matching with sum of service line charges");
                        $('cms1500_total_charge').focus()
                        return false
                    }
                }
                // checking if the number is a floating point number
             else if ((typeof(total_charges)==="number") && (parseInt(total_charges) !== total_charges))
                {
                    if (parseFloat(value_of_total_charge).toFixed(2) == total_charges.toFixed(2))
                    {
                        return true
                    }
                    else
                    {
                        alert("Total Charge is not matching with sum of service line charges");
                //      $('cms1500_total_charge').value = total_charges;                      Commented this line as per ticket #14413
                        $('cms1500_total_charge').focus()
                        return false
                    }
                }
                else
                    {alert('Total charge is neither integer nor a floating point number');
                    $('cms1500_total_charge').focus()
                    return false;}
    }
else
    {
        alert("Please enter Total charges");
        $('cms1500_total_charge').focus()
                    return false;
    }
}
function idq()
{
    if ((document.getElementById('id_qua1').value != ''))
    {
        document.getElementById('id_qua1').style.backgroundColor = 'white'
        if ((document.getElementById('id_qua1').value.match(string))) {
            return true
        }
        else {
            alert('id_qua1 must be a string')
            document.getElementById('id_qua1').focus();
            return false

        }
    }
    else
    {
        return true
    }
}

function rend()
{
    if ((document.getElementById('rendering_provider1').value != ''))
    {
        document.getElementById('rendering_provider1').style.backgroundColor = 'white'
        if ((document.getElementById('rendering_provider1').value.match(string))) {
            return true
        }
        else {
            alert('rendering_provider1 must be a string')
            document.getElementById('rendering_provider1').focus();
            return false

        }
    }
    else
    {

        return true

    }
}
function dateservicefrom1()
{

    text_value = document.getElementById('dateofservicefrom').value;
    year_array = text_value.split("/");
    if ((document.getElementById('dateofservicefrom').value != '' ))
    {
        document.getElementById('dateofservicefrom').style.backgroundColor = 'white'
        if ((document.getElementById('dateofservicefrom').value.match(dobRegxp))) {
            if (future_date($('dateofservicefrom').value))
            {
                        alert("Future date is not permitted");
                        $('dateofservicefrom').focus();
                        $('dateofservicefrom').highlight();
                        return false;
            }

            if ((year_array[1] >= 1) && (year_array[1] <= 31)) {
                if ((year_array[0] >= 1) && (year_array[0] <= 12)) {
                    current_date = new Date(year_array[2], year_array[0], year_array[1])
                    threeMonthsPrior = new Date(now.getFullYear(), now.getMonth() - 2, now.getDate());
                    if (year_array[2] >= 1900)
                        {
                        if (current_date >= threeMonthsPrior)
                            return true
                        else {
                                agree = confirm('Date you entered needs to be confirmed. Are you sure to continue?');
                                if(agree == true)
                                    return true
                                else
                                {
                                 document.getElementById('dateofservicefrom').focus();
                                return false
                                }
                            }
                        }
                   else
                        {
                            alert("Year must be greater than 1900")
                            document.getElementById('dateofservicefrom').focus();
                        return false
                        }
                }
                else {
                    alert('Enter a Valid month');
                    document.getElementById('dateofservicefrom').focus();
                    return false
                }
            }
            else
            {
                alert('Enter a Valid date');
                document.getElementById('dateofservicefrom').focus();
                return false
            }

        }
        else {
            alert('Date of service from date format is wrong')
            document.getElementById('dateofservicefrom').focus();
            return false

        }
    }
    else
    {
        alert('Date of service required');
        document.getElementById('dateofservicefrom').focus();
        return false;
    }

}

function dateserviceTo()
{
    text_date_of_service_to = document.getElementById('dateofserviceto').value;
    date_of_service_to = text_date_of_service_to.split("/");
    if (document.getElementById('dateofserviceto').value != '')
    {
        document.getElementById('dateofserviceto').style.backgroundColor = 'white'
        if ((document.getElementById('dateofserviceto').value.match(dobRegxp))) {
            if (future_date($('dateofserviceto').value))
            {
                alert("Future date is not permitted");
                        $('dateofserviceto').focus();
                        $('dateofserviceto').highlight();
                        return false;
//                agreefuturedate = confirm("You entered a future date. Are you sure to continue?")
//                if(agreefuturedate == true)
//                    return true
//                else
//                    {
//                         $('dateofserviceto').focus()
//                         $('dateofserviceto').highlight()
//                         return false
//                    }
            }

            if ((date_of_service_to[1] >= 1) && (date_of_service_to[1] <= 31)) {
                if ((date_of_service_to[0] >= 1) && (date_of_service_to[0] <= 12)) {
                    current_date = new Date(date_of_service_to[2], date_of_service_to[0], date_of_service_to[1])
                    threeMonthsPrior = new Date(now.getFullYear(), now.getMonth() - 2, now.getDate());
                    if(date_of_service_to[2] >= 1900)
                        {
                            if (current_date >= threeMonthsPrior)
                                return true
                            else
                                {
                                    agree = confirm('Date you entered needs to be confirmed. Are you sure to continue?');
                                    if(agree == true)
                                        return true
                                    else
                                    {
                                     document.getElementById('dateofserviceto').focus();
                                    return false
                                    }
                                }
                            }
                      else
                          {
                              alert("Year must be greater than 1900");
                              document.getElementById('dateofserviceto').focus();
                              return false
                          }
                        }
                else
                {
                    alert('Please Enter a Valid month');
                    document.getElementById('dateofserviceto').focus();
                    return false;
                }
            }
            else
            {
                alert('Please Enter a Valid date');
                document.getElementById('dateofserviceto').focus();
                return false;
            }

        }
        else {
            alert('Date of service to date format is wrong')
            document.getElementById('dateofserviceto').focus();
            return false

        }
    }
    else {

        return true
    }
}


//function compareDate() {
//    if (year_array[2] == date_of_service_to[2]) {
//        if (year_array[0] == date_of_service_to[0]) {
//            if (year_array[1] == date_of_service_to[1])
//                return true
//            else if (year_array[1] < date_of_service_to[1])
//                return true
//            else
//                return false
//
//        } else if (year_array[0] < date_of_service_to[0])
//            return true
//        else
//            return false
//
//    } else if (year_array[2] < date_of_service_to[2])
//        return true
//    else
//        return false
//
//
//}

function compareDates_occupation()
{
    frm_y = $('occu_from_year').value;
    frm_m = $('occu_from_month').value;
    frm_d = $('occu_from_date').value;
    to_y = $('occu_to_year').value;
    to_m = $('occu_to_month').value;
    to_d = $('occu_to_date').value;
    date1 = new Date(frm_y, frm_m - 1, frm_d);
    date2 = new Date(to_y, to_m - 1, to_d);

    if ((to_y != "") && (to_m != "") && (to_d != "")) {
        if (date2 < date1)
        {
            alert("From date cannot be greater than to date");
            $('occu_to_month').focus();
            return false;
        }
        else
            return true;
    }
    //   else if(((to_y == "")||(to_m == "")||(to_d == ""))&&((to_y != "")||(to_m != "")||(to_d != "")))
    //       {
    //           alert("Incorrect to date");
    //           $('occu_to_month').focus();
    //           return false
    //       }
    else
        return true;

}

function compareDates_service()
{
    frm_y = $('service_from_year').value;
    frm_m = $('service_from_month').value;
    frm_d = $('service_from_date').value;
    to_y = $('service_to_year').value;
    to_m = $('service_to_month').value;
    to_d = $('service_to_date').value;
    date1 = new Date(frm_y, frm_m - 1, frm_d);
    date2 = new Date(to_y, to_m - 1, to_d);
    if ((to_y != "") && (to_m != "") && (to_d != "")) {
        if (date2 < date1)
        {
            alert("From date cannot be greater than to date");
            $('service_to_month').focus();
            return false;
        }
        else
            return true;
    }
    //   else if(((to_y == "")||(to_m == "")||(to_d == ""))&&((to_y != "")||(to_m != "")||(to_d != "")))
    //       {
    //           alert("Incorrect to date");
    //           $('service_to_month').focus();
    //           return false
    //       }
    else
        return true;
}

function compareDatesFromandTo(from, to)
{
    date_from = from.value.split("/");
    date_to = to.value.split("/");
    date1 = new Date(date_from[2], date_from[0], date_from[1]);
    date2 = new Date(date_to[2], date_to[0], date_to[1]);
    if (date2 < date1)
        return false;
    else
        return true;
}

function compareDatesFromandTononocr()
{
    date_from = $('dateofservicefrom').value.split("/");
    date_to = $('dateofserviceto').value.split("/");
    date1 = new Date(date_from[2], date_from[0], date_from[1]);
    date2 = new Date(date_to[2], date_to[0], date_to[1]);
    if (date2 < date1)
    {
        alert("From date cannot be greater than to date");
        $("dateofserviceto").focus();
        return false;
    }
    else
        return true;
}





//function placeof1() {
//    if ((document.getElementById('placeofservice1').value != '' ))
//    {
//        document.getElementById('placeofservice1').style.backgroundColor = 'white'
//        if ((document.getElementById('placeofservice1').value.match(numericExpression))) {
//            return true
//        }
//        else {
//            alert('Place of Service is  a number')
//            document.getElementById('placeofservice1').focus();
//            return false
//
//        }
//
//    }
//    else
//    {
//        alert("place of service Required");
//        $('placeofservice1').focus();
//        return false;
//    }
//}

function emz()
{
    var emz_y = document.getElementById('emgz').value

    if ((document.getElementById('emgz').value.length != 0))
    {

        if ((emz_y == 'Y') || (emz_y == 'N')) {
            emz_y = ''
            return true
        }
        else {
            alert('EMG Y or N')
            document.getElementById('emgz').focus();
            emz_y = ''
            return false
        }


    }
    else
        alert('EMG cant be Empty')
    document.getElementById('emgz').focus();
    emz_y = ''
    return false
}


function charges1()
{
    if (($('charges_id').value == ''))
    {
        alert("Charges Required");
        $('charges_id').focus();
        return false;
    }
    else
    {
        return true;
    }
}

function charges1_ocr(val)
{

    if (($(val).value == ''))
    {
        alert("Charges can't be blank");
        $(val).focus();
        return false;
    }

    else
    {
        return true;
    }

}


function charges2()
{
    if ((document.getElementById('charges_id').value != '' ))
    {
        document.getElementById('charges_id').style.backgroundColor = 'white'
        if ((document.getElementById('charges_id').value.match(float1)) || (document.getElementById('charges_id').value.match(numericExpression)))
        {
            return true
        }
        else {
            alert('charge is not a float number')
            document.getElementById('charges_id').focus();
            return false
        }

    }
    else
    {
        return false
    }
}

function charges2_ocr()
{
    alert("In charges2");
    for (i = 1; i <= 50; i++)
    {
        if ((document.getElementById('i').value != '' ))
        {
            document.getElementById('i').style.backgroundColor = 'white'
            if ((document.getElementById('i').value.match(float1)) || (document.getElementById('i').value.match(numericExpression)))
            {
                return true
            }
            else {
                alert('charge is not a float number')
                document.getElementById('i').focus();
                return false
            }

        }
        else
        {
            return false
        }
    }
}


///cHECK FUNCTION FOR CPT CODE

function check_cpt_char(v)
{
    char_list = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    var new_char_count = 0;

    if ((char_list.indexOf(v.charAt(0))) != -1) {
        for (newi = 0; newi < 5; newi++) {
            var c1 = v.charAt(newi);
            if (char_list.indexOf(c1) != -1)
                new_char_count++;

        }
    }

    return new_char_count
}

function check_cpt_int(v) {
    var new_int_count = 0
    {
        for (newj = 0; newj < 5; newj++) {
            var c1 = v.charAt(newj);
            if (((c1 > 0) || (c1 < 9)))
                new_int_count++;

        }


    }


    return new_int_count;
}
function isCPTCPCD() {
    //
    cptcode = document.getElementById('cpthcpcd_id').value
    cptcpcd_length = cptcode.length
    if (document.getElementById('cpthcpcd_id').value != '') {
        document.getElementById('cpthcpcd_id').style.backgroundColor = 'white'
        if (cptcode.match(string)) {

            if (cptcpcd_length == 5) {
                /*
                 if(((check_cpt_char(cptcode))!=5) || ((check_cpt_int(cptcode))==5)){
                 //alert('INT COUNT:..'+(check_cpt_int(cptcode)));
                 //if((check_cpt(cptcode)!=5))
                 return true;
                 }
                 else
                 {
                 alert('Please Enter a Valid CPT CODE');
                 document.getElementById('cpthcpcd_id').focus()
                 return false;
                 }
                 */

                return true
            }
            else {
                //
                alert('CPT/HCPCS must be 5 digits')
                document.getElementById('cpthcpcd_id').focus()
                return false;
            }

        }
        else {
            alert('CPT/HCPCS Must be String/Number')
            document.getElementById('cpthcpcd_id').focus()
            return false;
        }
    }
    else
    {
        alert('CPT/HCPCS Cannot be Empty')
        document.getElementById('cpthcpcd_id').focus()
        return false;
    }
}
function dayofunits()
{

    if(document.getElementById('minutes_id').value == ""){
        if ((document.getElementById('days_or_units_id').value != '' ))
        {
            document.getElementById('days_or_units_id').style.backgroundColor = 'white'
            if ((document.getElementById('days_or_units_id').value.match(float1)) || (document.getElementById('days_or_units_id').value.match(numericExpression)))
            {
                return true
            }
            else {
                alert(' Units must be a real number')
                document.getElementById('days_or_units_id').focus();
                return false
            }
        }
        else
        {
            alert('Either Service Line Days of Units or Minutes cannot be Empty')
            document.getElementById('days_or_units_id').focus();
            return false;
        }
    }
    else
    {
        if(document.getElementById('days_or_units_id').value != ''){
         alert('Either days or units / minutes need to be present');
         document.getElementById('days_or_units_id').focus();
         return false;
        }
        else{
            return true;
        }

    }
}
function family1()
{
    var family_chrg = document.getElementById('epsdt_familycharge_id').value
    if (family_chrg != '')
    {

        if ((family_chrg == 'Y') || (family_chrg == 'N')) {
            return true
        }
        else
        {
            alert('Family plan should be Y or N')
            document.getElementById('epsdt_familycharge_id').focus();
            return false
        }
    }
    else
    {
        return true
    }
}


function isRenderingProviderIdPresent() {
    var id_q = document.getElementById('id_qua1').value
    var rend_prv_id = document.getElementById('rendering_provider1').value
    if (id_q != '')
    {
        if (rend_prv_id != '')
            return true
        else
        {
            alert('rendering provider id is must');
            document.getElementById('rendering_provider1').focus();
            return false;
        }
    }
    else
        return true

}

function isRenderingProviderNPI() {
    rendering_prv_npi = document.getElementById('rendering_provider_id2_id').value
    if (rendering_prv_npi != '') {
        if (rendering_prv_npi.match(numericExpression)) {
            if ((rendering_prv_npi.length) == 10)
                return true;
            else
            {
                alert('Rendering Provider NPI id Must be 10 Digits');
                document.getElementById('rendering_provider_id2_id').focus();
                return false;
            }
        }
        else
        {
            alert('Rendering Provider NPI id Must be Numeric');
            document.getElementById('rendering_provider_id2_id').focus();
            return false;
        }
    }
    else
    {
        return true;
    }
}

function isModifierValid() {
    modifier1 = (document.getElementById('modifier_id').value)
    modifier2 = (document.getElementById('modifier_id1').value)
    modifier3 = (document.getElementById('modifier_id2').value)
    modifier4 = (document.getElementById('modifier_id3').value)
    if ((modifier1 != '') && (modifier2 != '') && (modifier3 != '') && (modifier4 != '')) {
        if ((modifier1.length == 2) && (modifier2.length == 2) && (modifier3.length == 2) && (modifier4.length == 2))
            return true;
        else
        {
            alert('Modifier Field Must be 2 Characters');
            return false;
        }
    }
    else
        return false;
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

function nonocr_serviceline_npivalidation()
{
    if ((isValidNPI($('rendering_provider_id2_id').value)) == false)
    {
        //alert("NPI Number must be 10 digits");
        $('rendering_provider_id2_id').focus();
        return false;
    }
    return true;
}


function addRow(id) {
    
    if (dateservicefrom1() && dateserviceTo() && (epstd11()) && (idq()) && (rend()) && (isRenderingProviderIdPresent()) && (emz()) && (isCPTCPCD()) && (charges1()) && (charges2()) && (family1()) && (dayofunits()) && (isDiganosis_ServiceLine()) && (placeofservicecheck()) && (nonocr_serviceline_npivalidation())) {
        rowcount ++;
        count ++;
        count1 ++;

        if (count <= 1000) {
            if (count == 51 || count == 52) {
                confirm_service = "The service line count has reached " + (count - 1) + ". Are you sure to continue?"
                var agree = confirm(confirm_service);
                if (agree == true) {
                    addServiceLine(id);
                }
                else {
                    count = count - 1
                    count1 = count1 - 1
                }
            }
            else {
                addServiceLine(id);
            }

        } else {
            alert('You are Exceeds the Limit')

        }
        // var a=(document.getElementById('charges_id').value)
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

    var row1 = document.createElement("TR")
    row1.setAttribute('id', rowcount);
    var td11 = document.createElement("TD")

    textField = document.createElement('INPUT')
    textField.type = 'text'
    ep = document.getElementById('epsdt_familycharge_id1').value
    textField.setAttribute('width', '18')
    textField.setAttribute('value', ep)
    textField.setAttribute('name', "lineinformation[epsdt" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_epsdt" + rowcount + "")
    textField.setAttribute('size', '4')
    textField.className = "black_text"
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}

    td11.appendChild(textField)

    var td13 = document.createElement("TD")

    textField = document.createElement('INPUT')
    textField.type = 'text'
    qa1 = document.getElementById('id_qua1').value
    textField.setAttribute('value', qa1)
    textField.setAttribute('width', '18')
    textField.setAttribute('name', "lineinformation[id_qual1" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_id_qual1" + rowcount + "")
    textField.setAttribute('size', '4')
    textField.className = "black_text idqual"
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td13.appendChild(textField)

    var td12 = document.createElement("TD")
    textField = document.createElement('INPUT')
    rend1 = document.getElementById('rendering_provider1').value
    textField.type = 'text'

    textField.setAttribute('value', rend1)
    textField.setAttribute('name', "lineinformation[rendering_provider_id1" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_rendering_provider_id1" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    textField.setAttribute('size', '10')
    textField.setAttribute('width', '70')
    textField.className = "black_text rendering_provider1"
    td12.appendChild(textField)

    var td1 = document.createElement("TD")
    var div = document.createElement("DIV")
    div.setAttribute('id',"svc_num_"+rowcount+"")
    radioInput = document.createElement('INPUT')
    radioInput.type = 'radio'
    radioInput.setAttribute('name',"radioInput")
//    radioInput.setAttribute('tabindex','86')
    radioInput.setAttribute('id',"radioInput_"+rowcount+"")
    radioInput.setAttribute('value',"radioInput-"+rowcount+"")
//     radioInput.setAttribute('onchange',"javascript:this.checked=true;document.getElementById('svc_edit_btn').focus();")
//    radioInput.onblur = function changeFocus() {$('svc_edit_btn').focus();}
//    radioInput.onblur = function changeFocus() { if (flag_radiobtn == 0) { $('svc_edit_btn').focus()}; flag_radiobtn = 1; alert(flag_radiobtn) }
//   radioInput.setAttribute('onblur',"javascript:$('svc_edit_btn').focus();")
    radioInput.className = "radiobtn"

   //Code which displays the count in the dynamically created svc
   if ($('view')== null){
    div.appendChild(document.createTextNode(count))}
   else{
       div.appendChild(document.createTextNode((parseInt(servicelinecount)+1)))
       $('svc_count').value = parseInt(servicelinecount)+1;
}

    td1.appendChild(div)
    if ($('view')== null){
    td1.appendChild(radioInput)}
    row.appendChild(td1);
    for (i = 10; i >= 1; i--)
    {
        var td = 'td' + i

        td = document.createElement("TD")
        td.appendChild(document.createTextNode("-"))
        row.appendChild(td);
    }

    row.appendChild(td11);
    row.appendChild(td13);
    row.appendChild(td12);
    // row.appendChild(td25);
    tbody.appendChild(row);

    var td17 = document.createElement("TD")

    row1.appendChild(td17);

    var td16 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    dateservicefrom = document.getElementById('dateofservicefrom').value
    textField.setAttribute('width', '70')
    textField.setAttribute('size', '8')
    textField.className = "black_text from"
    textField.setAttribute('value', dateservicefrom)
    textField.setAttribute('name', "lineinformation[dateofservice_from" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_dateofservice_from" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td16.appendChild(textField)
    row1.appendChild(td16);

    var td15 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    dateserviceto = document.getElementById('dateofserviceto').value
    textField.setAttribute('value', dateserviceto)
    textField.setAttribute('width', '70')
    textField.setAttribute('size', '8')
    textField.className = "black_text to"
    textField.setAttribute('name', "lineinformation[dateofservice_to" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_dateofservice_to" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td15.appendChild(textField)
    row1.appendChild(td15);

    var td14 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    placeofservice = document.getElementById('placeofservice').value
    textField.setAttribute('value', placeofservice)
    textField.setAttribute('width', '18')
    textField.setAttribute('size', '1   ')
    textField.className = "black_text placeofservice"
    textField.setAttribute('name', "lineinformation[placeof_service" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_placeof_service" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td14.appendChild(textField)
    row1.appendChild(td14);

    var td13 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    emg = document.getElementById('emgz').value
    textField.setAttribute('value', emg)
    textField.setAttribute('width', '20')
    textField.setAttribute('size', '1')
    textField.className = "black_text emgz"
    textField.setAttribute('name', "lineinformation[emg" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_emg" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}

    td13.appendChild(textField)
    row1.appendChild(td13);

    var td12 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    cpthcpcd_id = document.getElementById('cpthcpcd_id').value
    textField.setAttribute('width', '40')
    textField.setAttribute('value', cpthcpcd_id)
    textField.setAttribute('size', '5')
    textField.className = "black_text cpthcpcs"
    textField.setAttribute('name', "lineinformation[cpthcpcs" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_cpthcpcs" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td12.appendChild(textField)
    row1.appendChild(td12);

    var td11 = document.createElement("TD")
     td11.setAttribute('style', "min-width: 150px;")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    modifier_id = document.getElementById('modifier_id').value

    textField.setAttribute('value', modifier_id)
    // textField.setAttribute('style', "width=18px")

    textField.setAttribute('size', '1')
    textField.setAttribute('width', '20')
    textField.className = "black_text modifier1"
    textField.setAttribute('name', "lineinformation[modifier1" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_modifier1" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td11.appendChild(textField)
    textField1 = document.createElement('INPUT')
    textField1.type = 'text'
    modifier_id1 = document.getElementById('modifier_id1').value
    textField1.setAttribute('value', modifier_id1)
    textField1.setAttribute('size', '1')
    textField1.setAttribute('width', '20')
    textField1.className = "black_text modifier2"
    textField1.setAttribute('name', "lineinformation[modifier2" + rowcount + "]")
    textField1.setAttribute('id', "lineinformation_modifier2" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField1.setAttribute('readOnly', true)}
    td11.appendChild(textField1)
    textField2 = document.createElement('INPUT')
    textField2.type = 'text'
    modifier_id2 = document.getElementById('modifier_id2').value
    textField2.setAttribute('value', modifier_id2)
    textField2.setAttribute('size', '1')
    textField2.setAttribute('width', '20')
    textField2.className = "black_text modifier3"
    textField2.setAttribute('name', "lineinformation[modifier3" + rowcount + "]")
    textField2.setAttribute('id', "lineinformation_modifier3" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField2.setAttribute('readOnly', true)}
    td11.appendChild(textField2)
    textField3 = document.createElement('INPUT')
    textField3.type = 'text'
    modifier_id3 = document.getElementById('modifier_id3').value
    textField3.setAttribute('value', modifier_id3)
    textField3.setAttribute('size', '1')
    textField3.setAttribute('width', '20')
    textField3.className = "black_text modifier4"
    textField3.setAttribute('name', "lineinformation[modifier4" + rowcount + "]")
    textField3.setAttribute('id', "lineinformation_modifier4" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField3.setAttribute('readOnly', true)}
    td11.appendChild(textField3)
    row1.appendChild(td11);

    var td10 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    diagnosis_pointer_id = document.getElementById('diagnosis_pointer_id').value
    textField.setAttribute('value', diagnosis_pointer_id)
    textField.setAttribute('size', '5')
    textField.setAttribute('maxLength',4)
    textField.className = "black_text diagnosis_pointer"
    textField.setAttribute('name', "lineinformation[diagnosis_pointer" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_diagnosis_pointer" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td10.appendChild(textField)
    row1.appendChild(td10);
    var td9 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    charges_id = document.getElementById('charges_id').value
    textField.setAttribute('width', '60')
    //textField.style = "text-align:right"
    textField.setAttribute('style', 'text-align:right')
    textField.setAttribute('id', "lineinformation_charges"+rowcount+"")
    textField.setAttribute('class', 'collect_charges')
    textField.setAttribute('value', charges_id)
    textField.setAttribute('size', '5')
    textField.className = "amount charges"
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
//    textField.onchange = function() {
//        call1()
//    }
    textField.setAttribute('name', "lineinformation[charges" + rowcount + "]")

    td9.appendChild(textField)
    row1.appendChild(td9);

    var td8 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    days_or_units_id = document.getElementById('days_or_units_id').value
    textField.setAttribute('width', '22')
    textField.setAttribute('value', days_or_units_id)
    textField.setAttribute('size', '2')
    textField.className = "black_text days_units"
    textField.setAttribute('name', "lineinformation[days_or_units" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_days_or_units" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td8.appendChild(textField)
    row1.appendChild(td8);

    var td_minutes = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    minutes_id = document.getElementById('minutes_id').value
    textField.setAttribute('width', '22')
    textField.setAttribute('value', minutes_id)
    textField.setAttribute('size', '2')
    textField.className = "black_text minutes"
    textField.setAttribute('name', "lineinformation[minutes" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_minutes" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td_minutes.appendChild(textField)
    row1.appendChild(td_minutes);

    var td7 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    epsdt_familycharge_id = document.getElementById('epsdt_familycharge_id').value
    textField.setAttribute('value', epsdt_familycharge_id)
    textField.setAttribute('width', '18')
    textField.setAttribute('size', '2')
    textField.className = "black_text"
    textField.setAttribute('name', "lineinformation[epsdt_familycharge2" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_epsdt_familycharge2" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td7.appendChild(textField)
    row1.appendChild(td7);

    var td6 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    textField.setAttribute('value', 'NPI')
    textField.setAttribute('width', '30')
    textField.setAttribute('size', '2')
    textField.className = "black_text"
    textField.setAttribute('name', "lineinformation[id_qual2" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_id_qual2" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td6.appendChild(textField)
    row1.appendChild(td6);

    var td5 = document.createElement("TD")
    textField = document.createElement('INPUT')
    textField.type = 'text'
    rendering_provider_id2_id = document.getElementById('rendering_provider_id2_id').value
    textField.setAttribute('value', rendering_provider_id2_id)
    textField.setAttribute('size', '10')
    textField.setAttribute('width', '70')

    textField.className = "black_text rendering_provider"
    textField.setAttribute('name', "lineinformation[rendering_provider_id2" + rowcount + "]")
    textField.setAttribute('id', "lineinformation_rendering_provider_id2" + rowcount + "")
    // for add servicleline in QA and completed claims view, the fields are not readonly
    if ($('view')== null){
    textField.setAttribute('readOnly', true)}
    td5.appendChild(textField)
    row1.appendChild(td5);


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
            var e2 = document.getElementById(sline_no);
            e2.parentNode.removeChild(e2);

           $('svc_count').value = ($('svc_count').value) - 1
//           iterateSvcNumber($('svc_count').value)
    }
    removesvc.appendChild(remove);
    row1.appendChild(removesvc);
}


//   var editsvc = document.createElement("TD");
//
//    edit = document.createElement('input');
//    edit.type = 'button';
//    edit.setAttribute('name', "editsvc" + count + "");
//    edit.setAttribute('id', "editsvc_" + count + "");
//    edit.value = "Edit";
//    edit.className = "black_text";
//    //edit.setAttribute('onclick',unfreeze)
//    edit.onclick = unfreeze;
//    editsvc.appendChild(edit);
//    row1.appendChild(editsvc);
//
//    var updatesvc = document.createElement("TD");
//
//    update = document.createElement('input');
//    update.type = 'button';
//    update.setAttribute('name', "updatesvc" + count + "");
//    update.setAttribute('id', "updatesvc_" + count + "");
//    update.value = "Update";
//    update.className = "black_text";
//    update.setAttribute('onclick', updateaddedservicelines);
//    updatesvc.appendChild(update);
//    row1.appendChild(updatesvc);
//
//    var removesvc = document.createElement("TD");
//
//    remove = document.createElement('input');
//    remove.type = 'button';
//    remove.setAttribute('name', "removesvc" + count + "");
//    remove.setAttribute('id', "removesvc_" + count + "");
//    remove.value = "Remove";
//    remove.className = "black_text";
//    remove.onclick = removeaddedrow;
//    removesvc.appendChild(remove);
//    row1.appendChild(removesvc);

    tbody.appendChild(row1);
//TOTAL CHARGE ADDITION
//    for (i = 1; i <= count; i++)
//    {
//        s1 = parseFloat(s1) + parseFloat(document.getElementById('charges_'+i).value)
//        //alert(i)
//        var cordec = Math.pow(10, 2);
//        s1 = Math.round(s1 * cordec) / cordec;
//        document.getElementById("cms1500_total_charge").value = s1
//
//    }
    s1 = 0
}
function disblebuttons()
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
    $('lineinformation_dateofservice_from'+svcnum).className = "highlightevc";
    $('lineinformation_dateofservice_to'+svcnum).className = "highlightevc";
    $('lineinformation_placeof_service'+svcnum).className = "highlightevc";
    $('lineinformation_emg'+svcnum).className = "highlightevc";
    $('lineinformation_cpthcpcs'+svcnum).className = "highlightevc";
    $('lineinformation_modifier1'+svcnum).className = "highlightevc";
    $('lineinformation_modifier2'+svcnum).className = "highlightevc";
    $('lineinformation_modifier3'+svcnum).className = "highlightevc";
    $('lineinformation_modifier4'+svcnum).className = "highlightevc";
    $('lineinformation_diagnosis_pointer'+svcnum).className = "highlightevc";
    $('lineinformation_charges'+svcnum).className = "highlightevc";
    $('lineinformation_days_or_units'+svcnum).className = "highlightevc";
    $('lineinformation_minutes'+svcnum).className = "highlightevc";
    $('lineinformation_epsdt_familycharge2'+svcnum).className = "highlightevc";
    $('lineinformation_id_qual2'+svcnum).className = "highlightevc";
    $('lineinformation_rendering_provider_id2'+svcnum).className = "highlightevc";
    $('lineinformation_epsdt'+svcnum).className = "highlightevc";
    $('lineinformation_id_qual1'+svcnum).className = "highlightevc";
    $('lineinformation_rendering_provider_id1'+svcnum).className = "highlightevc";
}

function undohighlight(svcnum)
{
    $('lineinformation_dateofservice_from'+svcnum).className = "black_text";
    $('lineinformation_dateofservice_to'+svcnum).className = "black_text";
    $('lineinformation_placeof_service'+svcnum).className = "black_text";
    $('lineinformation_emg'+svcnum).className = "black_text";
    $('lineinformation_cpthcpcs'+svcnum).className = "black_text";
    $('lineinformation_modifier1'+svcnum).className = "black_text";
    $('lineinformation_modifier2'+svcnum).className = "black_text";
    $('lineinformation_modifier3'+svcnum).className = "black_text";
    $('lineinformation_modifier4'+svcnum).className = "black_text";
    $('lineinformation_diagnosis_pointer'+svcnum).className = "black_text";
    $('lineinformation_charges'+svcnum).className = "amount";
    $('lineinformation_days_or_units'+svcnum).className = "black_text";
    $('lineinformation_minutes'+svcnum).className = "black_text";
    $('lineinformation_epsdt_familycharge2'+svcnum).className = "black_text";
    $('lineinformation_id_qual2'+svcnum).className = "black_text";
    $('lineinformation_rendering_provider_id2'+svcnum).className = "black_text";
    $('lineinformation_epsdt'+svcnum).className = "black_text";
    $('lineinformation_id_qual1'+svcnum).className = "black_text";
    $('lineinformation_rendering_provider_id1'+svcnum).className = "black_text";

}
 function unfreeze()
{

checked_radiobutton = getRadioGroupSelectedValue('radioInput')

    if(checked_radiobutton == '')
        alert("Please select a serviceline")
    else 
    {
        num = checked_radiobutton.split("-")
        svc_num = num[1]
        $('lineinformation_dateofservice_from'+svc_num).readOnly = false;
        $('lineinformation_dateofservice_to'+svc_num).readOnly = false;
        $('lineinformation_placeof_service'+svc_num).readOnly = false;
        $('lineinformation_emg'+svc_num).readOnly = false;
        $('lineinformation_cpthcpcs'+svc_num).readOnly = false;
        $('lineinformation_modifier1'+svc_num).readOnly = false;
        $('lineinformation_modifier2'+svc_num).readOnly = false;
        $('lineinformation_modifier3'+svc_num).readOnly = false;
        $('lineinformation_modifier4'+svc_num).readOnly = false;
        $('lineinformation_diagnosis_pointer'+svc_num).readOnly = false;
        $('lineinformation_charges'+svc_num).readOnly = false;
        $('lineinformation_days_or_units'+svc_num).readOnly = false;
        $('lineinformation_minutes'+svc_num).readOnly = false;
        $('lineinformation_epsdt_familycharge2'+svc_num).readOnly = false;
        $('lineinformation_id_qual2'+svc_num).readOnly = false;
        $('lineinformation_rendering_provider_id2'+svc_num).readOnly = false;
        $('lineinformation_epsdt'+svc_num).readOnly = false;
        $('lineinformation_id_qual1'+svc_num).readOnly = false;
        $('lineinformation_rendering_provider_id1'+svc_num).readOnly = false;
        disblebuttons()
        highlightsvc(svc_num)
        $('lineinformation_dateofservice_from'+svc_num).focus()
    }
}

  function freeze(svc_num)
{
    $('lineinformation_dateofservice_from'+svc_num).readOnly = true;
    $('lineinformation_dateofservice_to'+svc_num).readOnly = true;
    $('lineinformation_placeof_service'+svc_num).readOnly = true;
    $('lineinformation_emg'+svc_num).readOnly = true;
    $('lineinformation_cpthcpcs'+svc_num).readOnly = true;
    $('lineinformation_modifier1'+svc_num).readOnly = true;
    $('lineinformation_modifier2'+svc_num).readOnly = true;
    $('lineinformation_modifier3'+svc_num).readOnly = true;
    $('lineinformation_modifier4'+svc_num).readOnly = true;
    $('lineinformation_diagnosis_pointer'+svc_num).readOnly = true;
    $('lineinformation_charges'+svc_num).readOnly = true;
    $('lineinformation_days_or_units'+svc_num).readOnly = true;
    $('lineinformation_minutes'+svc_num).readOnly = true;
    $('lineinformation_epsdt_familycharge2'+svc_num).readOnly = true;
    $('lineinformation_id_qual2'+svc_num).readOnly = true;
    $('lineinformation_rendering_provider_id2'+svc_num).readOnly = true;
    $('lineinformation_epsdt'+svc_num).readOnly = true;
    $('lineinformation_id_qual1'+svc_num).readOnly = true;
    $('lineinformation_rendering_provider_id1'+svc_num).readOnly = true;
    undohighlight(svc_num);
    $('radioInput_'+svc_num).focus();
return true
}

function epstd11_svc(svc_num)
{
    if (($('lineinformation_epsdt'+svc_num).value != '' ))
    {
        if (!($('lineinformation_epsdt'+svc_num).value.match(string))) {
            alert('Epst must be a string')
            $('lineinformation_epsdt'+svc_num).focus();
            return false

        }
        else
        {
            return true
        }
    }
    else
    {
        return true
    }
}

function idq_svc(svc_num)
{

    if (($('lineinformation_id_qual1'+svc_num).value != ''))
    {
        if (($('lineinformation_id_qual1'+svc_num).value.match(string))) {
            return true
        }
        else {
            alert('id_qua1 must be a string')
            $('lineinformation_id_qual1'+svc_num).focus();
            return false

        }
    }
    else
    {
        return true
    }
}
function rend_svc(svc_num)
{
    if (($('lineinformation_rendering_provider_id1'+svc_num).value != ''))
    {
        if (($('lineinformation_rendering_provider_id1'+svc_num).value.match(string))) {
            return true
        }
        else {
            alert('rendering_provider1 must be a string')
            $('lineinformation_rendering_provider_id1'+svc_num).focus();
            return false
        }
    }
    else
    {
        return true
    }
}

function isRenderingProviderIdPresent_svc(svc_num) {
    var id_q = $('lineinformation_id_qual1'+svc_num).value
    var rend_prv_id = $('lineinformation_rendering_provider_id1'+svc_num).value
    if (id_q != '')
    {
        if (rend_prv_id != '')
            return true
        else
        {
            alert('rendering provider id is must');
            $('lineinformation_rendering_provider_id1'+svc_num).focus();
            return false;
        }
    }
    else
        return true

}

function dateservicefrom1_svc(svc_num)
{

    text_value = $('lineinformation_dateofservice_from'+svc_num).value;
    year_array = text_value.split("/");
    if ($('lineinformation_dateofservice_from'+svc_num).value != '' )
    {
        if (($('lineinformation_dateofservice_from'+svc_num).value.match(dobRegxp))) {
            if (future_date($('lineinformation_dateofservice_from'+svc_num).value))
            {
                        alert("Future date is not permitted");
                        $('lineinformation_dateofservice_from'+svc_num).focus()
                        $('lineinformation_dateofservice_from'+svc_num).highlight()
                        return false;
                
//                 agreefuturedate = confirm("You entered a future date. Are you sure to continue?")
//                if(agreefuturedate == true)
//                    return true
//                else
//                    {
//                        $('lineinformation_dateofservice_from'+svc_num).focus()
//                        $('lineinformation_dateofservice_from'+svc_num).highlight()
//                        return false
//                    }
            }

            if ((year_array[1] >= 1) && (year_array[1] <= 31)) {
                if ((year_array[0] >= 1) && (year_array[0] <= 12)) {
                    current_date = new Date(year_array[2], year_array[0], year_array[1])
                    threeMonthsPrior = new Date(now.getFullYear(), now.getMonth() - 2, now.getDate());
                    if(year_array[2] >= 1900)
                        {
                        if (current_date >= threeMonthsPrior)
                            return true
                        else {
                                 agree = confirm('Date you entered needs to be confirmed. Are you sure to continue?');
                                if(agree == true)
                                    return true
                                else
                                {
                                 $('lineinformation_dateofservice_from'+svc_num).focus();
                                 return false
                                }
                            }
                        }
                        else
                            {
                                alert("Year must be greater than 1900")
                                $('lineinformation_dateofservice_from'+svc_num).focus();
                                 return false
                            }
                }
                else {
                    alert('Enter a Valid month');
                    $('lineinformation_dateofservice_from'+svc_num).focus();
                    return false
                }
            }
            else
            {
                alert('Enter a Valid date');
                $('lineinformation_dateofservice_from'+svc_num).focus();
                return false
            }
        }
        else {
            alert('Date of service from date format is wrong')
            $('lineinformation_dateofservice_from'+svc_num).focus();
            return false
        }
    }
    else
    {
        alert('Date of service required')
        $('lineinformation_dateofservice_from'+svc_num).focus();
        return false;
    }

}

function dateserviceTo_svc(svc_num)
{
    text_date_of_service_to = $('lineinformation_dateofservice_to'+svc_num).value;
    date_of_service_to = text_date_of_service_to.split("/");
    if ($('lineinformation_dateofservice_to'+svc_num).value != '')
    {
        if (($('lineinformation_dateofservice_to'+svc_num).value.match(dobRegxp))) {
            if (future_date($('lineinformation_dateofservice_to'+svc_num).value))
            {
                        alert("Future date is not permitted");
                        $('lineinformation_dateofservice_to'+svc_num).focus()
                        $('lineinformation_dateofservice_to'+svc_num).highlight()
                        return false;
//                 agreefuturedate = confirm("You entered a future date. Are you sure to continue?")
//                if(agreefuturedate == true)
//                    return true
//                else
//                    {
//                        $('lineinformation_dateofservice_to'+svc_num).focus()
//                        $('lineinformation_dateofservice_to'+svc_num).highlight()
//                        return false
//                    }
            }

            if ((date_of_service_to[1] >= 1) && (date_of_service_to[1] <= 31)) {
                if ((date_of_service_to[0] >= 1) && (date_of_service_to[0] <= 12)) {
                    current_date = new Date(date_of_service_to[2], date_of_service_to[0], date_of_service_to[1])
                    threeMonthsPrior = new Date(now.getFullYear(), now.getMonth() - 2, now.getDate());
                     if(date_of_service_to[2] >= 1900)
                     {
                        if (current_date >= threeMonthsPrior)
                            return true
                        else
                        {
                            agree = confirm('Date you entered needs to be confirmed. Are you sure to continue?');
                            if(agree == true)
                                return true
                            else
                            {
                             $('lineinformation_dateofservice_to'+svc_num).focus();
                             return false
                            }
                        }
                     }
                     else
                         {
                             alert("Year must be greater than 1900");
                             $('lineinformation_dateofservice_to'+svc_num).focus();
                             return false
                         }
                }
                else
                {
                    alert('Please Enter a Valid month');
                    $('lineinformation_dateofservice_to'+svc_num).focus();
                    return false;
                }
            }
            else
            {
                alert('Please Enter a Valid date');
                $('lineinformation_dateofservice_to'+svc_num).focus();
                return false;
            }

        }
        else {
            alert('Date of service to date format is wrong')
            $('lineinformation_dateofservice_to'+svc_num).focus();
            return false

        }
    }
    else {

        return true
    }
}

function emz_svc(svc_num)
{
    var emz_y = $('lineinformation_emg'+svc_num).value

    if (($('lineinformation_emg'+svc_num).value.length != 0))
    {

        if ((emz_y == 'Y') || (emz_y == 'N')) {
            emz_y = ''
            return true
        }
        else {
            alert('EMG Y or N')
            $('lineinformation_emg'+svc_num).focus();
            emz_y = ''
            return false
        }


    }
    else
        alert('EMG cant be Empty')
    $('lineinformation_emg'+svc_num).focus();
    emz_y = ''
    return false
}

function isCPTCPCD_svc(svc_num) {
    cptcode = $('lineinformation_cpthcpcs'+svc_num).value
    cptcpcd_length = cptcode.length
    if ($('lineinformation_cpthcpcs'+svc_num).value != '') {
        if (cptcode.match(string)) {

            if (cptcpcd_length == 5) {
                return true
            }
            else {
                alert('CPT/HCPCS must be 5 digits')
                $('lineinformation_cpthcpcs'+svc_num).focus()
                return false;
            }

        }
        else {
            alert('CPT/HCPCS Must be String/Number')
            $('lineinformation_cpthcpcs'+svc_num).focus()
            return false;
        }
    }
    else
    {
        alert('CPT/HCPCS Cannot be Empty')
        $('lineinformation_cpthcpcs'+svc_num).focus()
        return false;
    }
}

function charges2_svc(svc_num)
{
    if (($('lineinformation_charges'+svc_num).value != '' ))
    {
        if (($('lineinformation_charges'+svc_num).value.match(float1)) || ($('lineinformation_charges'+svc_num).value.match(numericExpression)))
        {
            return true
        }
        else {
            alert('charge is not a float number')
            $('lineinformation_charges'+svc_num).focus();
            return false
        }

    }
    else
    {
        alert("Charges Required");
        $('lineinformation_charges'+svc_num).focus();
        return false
    }
}

function family1_svc(svc_num)
{
    var family_chrg = $('lineinformation_epsdt_familycharge2'+svc_num).value
    if (family_chrg != '')
    {

        if ((family_chrg == 'Y') || (family_chrg == 'N')) {
            return true
        }
        else
        {
            alert('Family plan should be Y or N')
            $('lineinformation_epsdt_familycharge2'+svc_num).focus();
            return false
        }
    }
    else
    {
        return true
    }
}

function dayofunits_svc(svc_num)
{

    if($('lineinformation_minutes'+svc_num).value == ""){
        if (($('lineinformation_days_or_units'+svc_num).value != '' ))
        {
            if (($('lineinformation_days_or_units'+svc_num).value.match(float1)) || ($('lineinformation_days_or_units'+svc_num).value.match(numericExpression)))
            {
                return true
            }
            else {
                alert(' Units must be a real number')
                $('lineinformation_days_or_units'+svc_num).focus();
                return false
            }
        }
        else
        {
            alert('Either Service Line Days of Units or Minutes cannot be Empty')
            $('lineinformation_days_or_units'+svc_num).focus();
            return false;
        }
    }
    else
    {
        if($('lineinformation_days_or_units'+svc_num).value != ''){
         alert('Either days or units / minutes need to be present');
         $('lineinformation_days_or_units'+svc_num).focus();
         return false;
        }
        else{
            return true;
        }

    }
}

function isDiganosis_ServiceLine_svc(svc_num) {
    if ($('lineinformation_diagnosis_pointer'+svc_num).value != '') {
        if ($('lineinformation_diagnosis_pointer'+svc_num).value.match(diagnosis_ptr)) {

            if (checkDiagonosis() == 0) {
                return true;
            }
            else {
                //                alert('Diagonosis Pointer must be related to nature of illness or injury');
                $('lineinformation_diagnosis_pointer'+svc_num).focus();
                return true;
            }
        }
        else
        {
            alert('Diganosis Pointer must be Numeric in the Range{1,2,3,4,5,6,7,8}');
            $('lineinformation_diagnosis_pointer'+svc_num).focus();
            return false;
        }
    } else {
        //
        alert("Diaganosis Pointer Cannot be Empty");
        $('lineinformation_diagnosis_pointer'+svc_num).focus();
        return false;

    }
}

function placeofservicecheck_svc(svc_num)
{
    if (($('lineinformation_placeof_service'+svc_num).value == '0') || ($('lineinformation_placeof_service'+svc_num).value == ''))
    {
        var confirmblank = confirm("Place of service field is blank, are you sure to continue?");
        if (confirmblank == true)
            return true;
        else
        {
            $('lineinformation_placeof_service'+svc_num).focus();
            return false;
        }
    }
    else
        {
        if (!($('lineinformation_placeof_service'+svc_num).value.match(placeofserviceregexp)))
                    {
                        alert("Place of service must be a 2 digit number or blank");
                        $('lineinformation_placeof_service'+svc_num).focus();
                        return false;
                    }
        else
            return true
        }
}

function nonocr_serviceline_npivalidation_svc(svc_num)
{
    if ((isValidNPI($('lineinformation_rendering_provider_id2'+svc_num).value)) == false)
    {
        $('lineinformation_rendering_provider_id2'+svc_num).focus();
        return false;
    }
    return true;
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

function updateaddedservicelines()
{
checked_radiobutton = getRadioGroupSelectedValue('radioInput')

    if(checked_radiobutton == '')
        alert("Please select a serviceline");
    else
    {
        num = checked_radiobutton.split("-")
        sline_no = num[1]
        if($('lineinformation_dateofservice_from'+sline_no).readOnly == true)
        {
            alert("Please do remember to EDIT the serviceline before UPDATE");
            return false;
        }
        else
        {
            modifier1 = 'lineinformation_modifier1'+sline_no
            modifier2 = 'lineinformation_modifier2'+sline_no
            modifier3 = 'lineinformation_modifier3'+sline_no
            modifier4 = 'lineinformation_modifier4'+sline_no
            if(epstd11_svc(sline_no) && idq_svc(sline_no) && rend_svc(sline_no) && isRenderingProviderIdPresent_svc(sline_no) && dateservicefrom1_svc(sline_no) && dateserviceTo_svc(sline_no) && placeofservicecheck_svc(sline_no) && emz_svc(sline_no) && isCPTCPCD_svc(sline_no) && dayofunits_svc(sline_no) && isDiganosis_ServiceLine_svc(sline_no) && family1_svc(sline_no) && nonocr_serviceline_npivalidation_svc(sline_no) && charges2_svc(sline_no) && validate_modifier(modifier1) && validate_modifier(modifier2) && validate_modifier(modifier3) && validate_modifier(modifier4)&& freeze(sline_no) && enablebuttons() )
                return true
            else
                return false
        }
    }
}

function removeaddedrow()
{
 checked_radiobutton = getRadioGroupSelectedValue('radioInput')

    if(checked_radiobutton == '')
         alert("Please select a serviceline");
    else
    {
agree = confirm("Are you sure deleting this row")
if (agree == true)
    {
    num = checked_radiobutton.split("-")
    sline_no = num[1]

    newcount = newcount - 1
    //count1 = count1-1
    count = newcount
    newcount1 = newcount1 - 1
    count1 = newcount1
    document.getElementById(1700).value = count
// TOTAL CHARGE DEDUCTION
//    for (i = 1; i < count; i++)
//    {
//        s1 = parseFloat(s1) + parseFloat(document.getElementById('charges_'+i).value)
//        //alert(i)
//        var cordec = Math.pow(10, 2);
//        s1 = Math.round(s1 * cordec) / cordec;
//        document.getElementById("cms1500_total_charge").value = s1
//    }
    s1 = 0

    var e1 = document.getElementById(sline_no);
    e1.parentNode.removeChild(e1);
    var e2 = document.getElementById(sline_no);
    e2.parentNode.removeChild(e2);
   iterateSvcNumber(rowcount);
}
else
    return true
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
//    if (agree == true)
//    {
//        var e1 = document.getElementById(newcount);
//        e1.parentNode.removeChild(e1);
//
//        var e2 = document.getElementById(newcount);
//        e2.parentNode.removeChild(e2);
//
//        newcount = newcount - 1
//        count = newcount
//        newcount1 = newcount1 - 1
//        count1 = newcount1
//        document.getElementById(1700).value = count
//        for (i = 1; i <= count; i++)
//        {
//            s1 = parseFloat(s1) + parseFloat(document.getElementById('charges_'+i).value)
//            //alert(i)
//            var cordec = Math.pow(10, 2);
//            s1 = Math.round(s1 * cordec) / cordec;
//            document.getElementById("cms1500_total_charge").value = s1
//
//        }
//        s1 = 0
//    }
//    else
//        return true;
//}
function call1() {
    //alert(t)
    //alert(document.getElementById(count).value);


    //count21='charge_id' + count1
    for (i = 1; i < count; i++)
    {
        s1 = parseFloat(s1) + parseFloat($('lineinformation_charges'+i).value)

        var cordec = Math.pow(10, 2);
        //
        s1 = Math.round(s1 * cordec) / cordec;
        //
        $("cms1500_total_charge").value = s1

    }
    s1 = 0
}

function displayinfo() {
    //alert('Inside self');
    $('cms1500_insured_last_name').value = $('cms1500_patient_last_name').value
    $('cms1500_insured_first_name').value = $('cms1500_patient_first_name').value
    $('cms1500_insured_middle_initial').value = $('cms1500_patient_middle_initial').value
    $('cms1500_insured_address').value = $('cms1500_patient_address').value
    $('cms1500_insured_city').value = $('cms1500_patient_city').value
    $('cms1500_insured_zipcode').value = $('cms1500_patient_zipcode').value
    $('cms1500_insured_telephone').value = $('cms1500_patient_telephone').value
    $('insured_dob_month').value = $('patient_dob_month').value
    $('insured_dob_date').value = $('patient_dob_date').value
    $('insured_dob_year').value = $('patient_dob_year').value
    $('cms1500_insured_suffix').value = $('cms1500_patient_suffix').value
    $('cms1500_insured_state').selectedIndex = $('cms1500_patient_state').selectedIndex
    //alert(document.getElementById(cms1500_patient_sex_f).checked);
    /*if (document.getElementById(cms1500_patient_sex_f).status ==true)
     {
     document.getElementById(cms1500_insured_sex_f).setAttribute("checked", "false");



     }*/
    if ($('cms1500_patient_sex_m').checked == true)
    {
        $('cms1500_insured_sex_m').checked = true;
    }
    else if ($('cms1500_patient_sex_f').checked == true)
    {
        $('cms1500_insured_sex_f').checked = true;
    }
    else if ($('cms1500_patient_sex_u').checked == true)
    {
        $('cms1500_insured_sex_u').checked = true;
    }

    //document.getElementById(cms1500_patient_sex_f).selectedItem = document.getElementById(cms1500_insured_sex_f).selectedItem
}


function clearinfo() {

    $('cms1500_insured_last_name').value = "";
    $('cms1500_insured_first_name').value = "";
    $('cms1500_insured_middle_initial').value = "";
    $('cms1500_insured_address').value = "";
    $('cms1500_insured_city').value = "";
    $('cms1500_insured_zipcode').value = "";
    $('cms1500_insured_telephone').value = "";
    $('insured_dob_month').value = "";
    $('insured_dob_date').value = "";
    $('insured_dob_year').value = "";
    $('cms1500_insured_suffix').value = "";

    //    for(j=201;j<=210;j++)
    //    {
    //        document.getElementById(j).value = ""
    //    }


}

function fieldenable()
{
    $('cms1500_billing_provider_last_name').disabled = false
    $('cms1500_billing_provider_suffix').disabled = false
    $('cms1500_billing_provider_first_name').disabled = false
    $('cms1500_billing_provider_middle_initial').disabled = false

    //    for(j=73;j<=76;j++)
    //    {
    //        document.getElementById(j).disabled=false
    //    }
    $('cms1500_billing_provider_name').value = ''
    $('cms1500_billing_provider_name').disabled = true


}

function fielddisable()
{
    $('cms1500_billing_provider_last_name').disabled = true
    $('cms1500_billing_provider_suffix').disabled = true
    $('cms1500_billing_provider_first_name').disabled = true
    $('cms1500_billing_provider_middle_initial').disabled = true

    //    for(j=73;j<=76;j++)
    //    {
    //        document.getElementById(j).disabled=true
    //    }

    
    $('cms1500_billing_provider_last_name').value = ''
    $('cms1500_billing_provider_suffix').value = ''
    $('cms1500_billing_provider_first_name').value = ''
    $('cms1500_billing_provider_middle_initial').value = ''
    $('cms1500_billing_provider_name').disabled = false
}
/*  function textboxenable()
 //  {
 //      flag = 1;
 //     document.getElementById(cms1500_other_insured_last_name).disabled=false
 //   document.getElementById(cms1500_other_insured_first_name).disabled=false
 //   document.getElementById(cms1500_other_insured_middle_initial).disabled=false
 //  document.getElementById(cms1500_other_insured_policy_or_group_number).disabled=false
 //  document.getElementById(cms15001_other_dob_month).disabled=false
 //   document.getElementById(cms15001_other_dob_date).disabled=false
 //  document.getElementById(cms15001_other_dob_year).disabled=false
 //  document.getElementById(cms1500_other_insured_employers_or_school_name).disabled=false
 //   document.getElementById(cms1500_other_insured_insurance_plan_name).disabled=false
 //  document.getElementById(cms1500_other_insured_suffix).disabled=false

 //  document.getElementById("disablem").disabled=false
 // document.getElementById("disablef").disabled=false

 //  }*/

/* function textboxdisable()
 {

 flag = 0;
 document.getElementById(cms1500_other_insured_last_name).disabled=true
 document.getElementById(cms1500_other_insured_first_name).disabled=true
 document.getElementById(cms1500_other_insured_middle_initial).disabled=true
 document.getElementById(cms1500_other_insured_policy_or_group_number).disabled=true
 document.getElementById(cms15001_other_dob_month).disabled=true
 document.getElementById(cms15001_other_dob_date).disabled=true
 document.getElementById(cms15001_other_dob_year).disabled=true
 document.getElementById(cms1500_other_insured_employers_or_school_name).disabled=true
 document.getElementById(cms1500_other_insured_insurance_plan_name).disabled=true
 document.getElementById(cms1500_other_insured_suffix).disabled=true

 document.getElementById("disablem").disabled=true
 document.getElementById("disablef").disabled=true

 }*/

function fieldenablephyl() {
    document.getElementById("phy_last_name").disabled = false
    document.getElementById("phy_suffix").disabled = false
    document.getElementById("phy_first_name").disabled = false
    document.getElementById("phy_initial").disabled = false
    document.getElementById("phy_orgnname").value = ''
    document.getElementById("phy_orgnname").disabled = true
}

function fieldphyorg() {
    
    document.getElementById("phy_last_name").value = ''
    document.getElementById("phy_suffix").value = ''
    document.getElementById("phy_first_name").value = ''
    document.getElementById("phy_initial").value = ''

    document.getElementById("phy_last_name").disabled = true
    document.getElementById("phy_suffix").disabled = true
    document.getElementById("phy_first_name").disabled = true
    document.getElementById("phy_initial").disabled = true
    document.getElementById("phy_orgnname").disabled = false
}

function fieldenablerefprvl() {
    document.getElementById("ref_prv_name2").disabled = false
    document.getElementById("ref_prv_name3").disabled = false
    document.getElementById("ref_prv_name").disabled = false
    document.getElementById("ref_prv_name1").disabled = false

    document.getElementById("refprv_orgnname").value = ''
    document.getElementById("refprv_orgnname").disabled = true
}

function fieldrefprvorg() {
    

    document.getElementById("ref_prv_name2").value = ''
    document.getElementById("ref_prv_name3").value = ''
    document.getElementById("ref_prv_name").value = ''
    document.getElementById("ref_prv_name1").value = ''

    document.getElementById("ref_prv_name2").disabled = true
    document.getElementById("ref_prv_name3").disabled = true
    document.getElementById("ref_prv_name").disabled = true
    document.getElementById("ref_prv_name1").disabled = true
    
    document.getElementById("refprv_orgnname").disabled = false


}

function tot_charge() {
    tot_sum = 0;
    for (i = 1; i <= 40; i++) {

        if (document.getElementById(i).value != '') {
            tot_sum = tot_sum + parseFloat(document.getElementById(i).value)
            var cordec = Math.pow(10, 2);
            tot_sum = Math.round(tot_sum * cordec) / cordec;
            document.getElementById('cms1500_total_charge').value = tot_sum

        }

    }

}


function formValidator_admin() {
    // var selected_index = document.getElementById('status').selectedIndex
    var facilityName = batch_type()
    if (flag == 1) {
        if ((isLastName()) && (isFirstName()) && (isSuffix(facilityName)) && (isInitial()) && (isAddress()) && (isCity()) && (isZipCode()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isInsuredsTelePhone()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) && (isOtherInsuredsLastName()) && (isOtherInsuredsFirstName()) && (isDOB_nonmandatory('other_dob_month','other_dob_date','other_dob_year')) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationName()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (isBillingOrganizationState()) && (IS_patient_relationship()) && (IsDateofCurrent()) && (isPatientState()) && (isInsuredsState()) && (payer_name()) && (payer_addrone()) && (payer_addrtwo()) && (payer_city()) && (payer_state()) && (payer_zipcode()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (tot_charge_nonocr()) && (npivalidation())&& (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')))
            {
            var agree = confirm("Are you sure you wish to continue?");
            if (agree == true)
                if(submitted)
                    return false;
                else
                {
                    submitted = true;
                    return true;
                }
            else
                return false;

        }
        else
            return false
    }
     else if ((isLastName()) && (isSuffix(facilityName)) && (isFirstName()) && (isInitial()) && (isAddress()) && (isCity()) && (isZipCode()) && (isTelePhone()) && (isInsuredsNumber()) && (isInsuredLastName()) && (isInsuredSuffix(facilityName)) && (isInsuredFirstName()) && (isInsuredInitial()) && (isInsuredsAddress()) && (isInsuredsCity()) && (isInsuredZipCode()) && (isautoAccidentPlace()) && (isInsuredsTelePhone()) && (isFECANumber(facilityName)) && isinsuranceplanname(facilityName) && (isSignedDOB()) && (isValidDate('current_month','current_date','current_year')) && (isValidDate('illness_month','illness_date','illness_year')) && (isReFPRVB()) && (is17a()) && (isRefPrvName()) && (isRefPrvName1(facilityName)) && (isRefPrvName2()) && (isRefPrvName3()) && (isDiaganosisInjury()) && (isDiaganosisInjury2()) && (isDiaganosisInjury3()) && (isDiaganosisInjury4()) && (isValidDate('occu_from_month','occu_from_date','occu_from_year')) && (isValidDate('occu_to_month','occu_to_date','occu_to_year')) && (isValidDate('service_from_month','service_from_date','service_from_year')) && (isValidDate('service_to_month','service_to_date','service_to_year')) && (isLabCharge()) && (isMediCode()) && (isOrginalRefNumber()) && (IsPriororganizationNumber()) && (isFederalTaxId()) && (isPatientAccountNumber()) && (isPhysicianLastName()) && (isPhysicianSuffix(facilityName)) && (isPhysicianFirstName()) && (isPhysicianInitial()) && (isPhyOrganizationName()) && (isPhySicianDOB()) && (isOrganizationName()) && (isOrganizationAddress()) && (isOrganizationCity()) && (isOrganizationState()) && (isOrganizationZipCode()) && (isOrganisationB()) && (isAmountPaid()) && (isBillingOrganizationName()) && (isBillingOrganizationAddress()) && (isBillingOrganizationCity()) && (isBillingOrganizationZipCode()) && (isBillOrganisationB()) && (isBillingProviderMiddle(facilityName)) && (isBillingOrganizationState()) && (IS_patient_relationship()) && (IsDateofCurrent()) && (isPatientState()) && (isInsuredsState()) && (payer_name()) && (payer_addrone()) && (payer_addrtwo()) && (payer_city()) && (payer_state()) && (payer_zipcode()) && (diagnosisorinjury_duplication()) && (compareDates_occupation()) && (compareDates_service()) && (tot_charge_nonocr()) && (npivalidation())&& (isDOB('patient_dob_month','patient_dob_date','patient_dob_year')) && (isDOB_nonmandatory('insured_dob_month','insured_dob_date','insured_dob_year')) )
        {
            var agree = confirm("Are you sure you wish to continue?");
            if (agree == true)
                if(submitted)
                    return false;
                else
                {
                    submitted = true;
                    return true;
                }
            else
                return false;

        }
    else
        return false
}

//showing text area comment box for QA/processor view
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


//Confirmation when processor press incomplete
function isCountinue() {

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
//        var serviceline_count = $('svc_count').value;
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

            var agree_proc_incomplete = confirm("Are you sure, You want to Incomplete the Claim?");
            if (agree_proc_incomplete == true)
            return true;
        else
            return false;
    }
}

function placeofservicecheck()
{

    if (($('placeofservice').value == '0') || ($('placeofservice').value == ''))
    {
        var confirmblank = confirm("Place of service field is blank, are you sure to continue?");
        if (confirmblank == true)
            return true;
        else
        {
            $('placeofservice').focus();
            return false;
        }
    }
    else
        return true
}


//Checking the Place of Service is Valid in QA View
//Complicated code - Need to remove this
function isServiceLinePlaceOfservice() {
    var dd = 0;
    var bb = 0;
    var temp_value_arr = new Array();
    var newl = 0;
    var newk = 0;
    place_of_service_arr = new Array(11, 12, 20, 21, 22, 23, 24, 25, 26, 31, 32, 33, 34, 41, 42, 49, 51, 52, 53, 54, 55, 56, 50, 60, 61, 62, 65, 71, 72, 81, 99);
    var serviceline_count = $('svc_count').value
    for (l = 1; l <= serviceline_count; l++) {
        temp_value = document.getElementById('lineinformation_placeof_service' + l).value;
        if (temp_value != '') {
            temp_value_arr[newl] = temp_value
            newl++;
        }
    }
    for (place_of_service_count = 0; place_of_service_count < place_of_service_arr.length; place_of_service_count++) {
        for (newk = 0; newk < temp_value_arr.length; newk++) {
            if (place_of_service_arr[place_of_service_count] == temp_value_arr[newk])
                bb++;

        }
    }

    if ((temp_value_arr.length == bb) && (dd == 0))
        return true
    else {
        alert('In Service Line Information One of the Place of Service Incorrect');
        return false;
    }

}


//Function to add default slashes in date of service field.

function addSlashToDate(service_date) {
    if (((document.getElementById(service_date).value).indexOf("/") == -1) && ((document.getElementById(service_date).value).length == 8)) {
        document.getElementById(service_date).value = (document.getElementById(service_date).value).substring(0, 2) + "/" + (document.getElementById(service_date).value).substring(2, 4) + "/" + (document.getElementById(service_date).value).substring(4, 8);
    }
    else if (((document.getElementById(service_date).value).charAt(2) == "/") && ((document.getElementById(service_date).value).charAt(5) != "/") && (((document.getElementById(service_date).value).length == 9) || ((document.getElementById(service_date).value).length == 5))) {
        date_str = (document.getElementById(service_date).value);
        date_val = date_str.slice(0, 2) + date_str.slice(3, 5) + date_str.slice(5, 9);
        document.getElementById(service_date).value = date_val.substring(0, 2) + "/" + date_val.substring(2, 4) + "/" + date_val.substring(4, 8);
    }
    else if (((document.getElementById(service_date).value).charAt(4) == "/") && ((document.getElementById(service_date).value).charAt(2) != "/") && ((document.getElementById(service_date).value).length == 9)) {
        date_str = (document.getElementById(service_date).value);
        date_val = date_str.slice(0, 2) + date_str.slice(2, 4) + date_str.slice(5, 9);
        document.getElementById(service_date).value = date_val.substring(0, 2) + "/" + date_val.substring(2, 4) + "/" + date_val.substring(4, 8);
    }
}


function addSlashes(field) {
    if (((field.value).indexOf("/") == -1) && ((field.value).length == 8)) {
        field.value = (field.value).substring(0, 2) + "/" + (field.value).substring(2, 4) + "/" + (field.value).substring(4, 8);
    }
    else if (((field.value).charAt(2) == "/") && ((field.value).charAt(5) != "/") && (((field.value).length == 9) || ((field.value).length == 5))) {
        date_str = (field.value);
        date_val = date_str.slice(0, 2) + date_str.slice(3, 5) + date_str.slice(5, 9);
        field.value = date_val.substring(0, 2) + "/" + date_val.substring(2, 4) + "/" + date_val.substring(4, 8);
    }
    else if (((field.value).charAt(4) == "/") && ((field.value).charAt(2) != "/") && ((field.value).length == 9)) {
        date_str = (field.value);
        date_val = date_str.slice(0, 2) + date_str.slice(2, 4) + date_str.slice(5, 9);
        field.value = date_val.substring(0, 2) + "/" + date_val.substring(2, 4) + "/" + date_val.substring(4, 8);
    }
}


function disableAutoaccident() {
    document.getElementById("auto_accident_place_id").disabled = true;
}

function enableAutoaccident() {
    document.getElementById("auto_accident_place_id").disabled = false;
}

function getPosition(arrayName, arrayItem)
{
    for (i = 0; i < arrayName.length; i++) {
        if (arrayName[i] == arrayItem)
            return i;
    }
}

function checkDiagonosis() {
    var injury_match = 0;
    var injury_value = 0;
    var injury_indx = 0;
    var old_value = 0;
    var j = 0;
    var m = 0;
    var injury_indx_arr = new Array();
    var match_arr = new Array();
    for (i = 1; i < 5; i++) {
        injury_value_inj = document.getElementById('injury' + i).value;
        injury_indx = i;
        if (injury_value_inj != '') {
            injury_indx_arr[j] = injury_indx
            j++;
        }
    }
    injury_value = document.getElementById('diagnosis_pointer_id').value
    injury_limit = injury_value.length
    for (count_i = 0; count_i < injury_limit; count_i++) {
        x = parseInt(injury_value / 10);
        injury_value_new = injury_value % 10;
        for (k = 0; k < injury_indx_arr.length; k++) {
            if ((injury_value_new == injury_indx_arr[k]) && (injury_value_new != old_value)) {
                match_arr[m] = "true";
                m++;
                break;
            }
            else {
                if (k == injury_indx_arr.length - 1) {
                    match_arr[m] = "false";
                    m++;
                }
            }
        }
        old_value = injury_value_new;
        injury_value = x;
    }
    if (getPosition(match_arr, "false") >= 0)
        injury_match = 1;
    else
        injury_match = 0;
    return injury_match;
}


function isDiganosis_ServiceLine() {
    if (document.getElementById('diagnosis_pointer_id').value != '') {
        if (document.getElementById('diagnosis_pointer_id').value.match(diagnosis_ptr)) {

            if (checkDiagonosis() == 0) {
                return true;
            }
            else {
                //                alert('Diagonosis Pointer must be related to nature of illness or injury');
                document.getElementById('diagnosis_pointer_id').focus();
                return true;
            }
        }
        else
        {
            alert('Diganosis Pointer must be Numeric in the Range{1,2,3,4,5,6,7,8}');
            document.getElementById('diagnosis_pointer_id').focus();
            return false;
        }
    } else {
        //        
        alert("Diaganosis Pointer Cannot be Empty");
        document.getElementById('diagnosis_pointer_id').focus();
        return false;

    }
}

function samePatientNameDetails(){
	$('cms1500_insured_last_name').value = $F('cms1500_patient_last_name');   
	$('cms1500_insured_suffix').value = $F('cms1500_patient_suffix'); 
	$('cms1500_insured_first_name').value = $F('cms1500_patient_first_name'); 
	$('cms1500_insured_middle_initial').value = $F('cms1500_patient_middle_initial');
}

function samePatientAddressDetails(){
	$('cms1500_insured_address').value = $F('cms1500_patient_address');   
	$('cms1500_insured_city').value = $F('cms1500_patient_city'); 
	$('cms1500_insured_state').value = $F('cms1500_patient_state'); 
	$('cms1500_insured_zipcode').value = $F('cms1500_patient_zipcode');
	$('cms1500_insured_telephone').value = $F('cms1500_patient_telephone');
	           
}


 function patient_Details_Popup(){
     fname = $F('cms1500_patient_first_name');
     lname = $F('cms1500_patient_last_name');
     insuredid = $F('insureds_id');
     jobid = $F('jobid');
     batchid = $F('batchid');
     batchtype = $F('batch_type');
    var pop_patient_details = window.open("patient_details_from_csv?firstname="+fname+"&lastname="+lname+"&batchid="+batchid+"&jobid="+jobid+"&insuredid="+insuredid+"&batch_type="+batchtype, "mywindow", "top=500,left=200,width=900,height=300");
 }

function submit_patient_info(batchtype,batchid,jobid,patientid)
{
    self.close();
    window.opener.location.href = "claim?batchid="+batchid+"&jobid="+jobid+"&patientid="+patientid+"&batch_type="+batchtype;
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
            $('payer_name').focus()
            return false
        }
    }
}
function removeRowQa(row,svccount) {
        var e1 = document.getElementById("removeRow_" + row);
        var remove_row1 = e1.parentNode.parentNode;
        remove_row1.parentNode.removeChild(remove_row1);

        var e2 = document.getElementById("rendering_provider1" + row);
        var remove_row2 = e2.parentNode.parentNode;
        remove_row2.parentNode.removeChild(remove_row2);
        $('svc_count').value = ($('svc_count').value) - 1
// Need to decrement the svccount by 1 and pass it to datacapture_controller
//        var total_fee = 0
//        for (line = 1; line <= svccount; line++) {
//        var fee = $(line)
//         if (fee.value.length != 0) {
//             total_fee = total_fee + parseFloat(fee.value);
//         }
//     }
// $("cms1500_total_charge").value = total_fee
 }

 function isfromdateempty(f_mm,f_dd,f_yy,t_mm,t_dd,t_yy)
 {
     if(($F(f_mm)=='')&&($F(f_dd)=='')&&($F(f_yy)=='')&&($F(t_mm)!='')&&($F(t_dd)!='')&&($F(t_yy)!=''))
       {
            alert("Please enter from date");
            $(f_mm).focus()
            return false
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

function incorrect_mandatory()
{
    alert($('incorrect').value);
    if ($('incorrect').value == '')
    {
        alert("Incorrect field cannot be blank");
        $('incorrect').focus();
    }
}

function accept_assignment()
{
    if (($('cms1500_accept_assignment_yes').checked == false) && ($('cms1500_accept_assignment_no').checked == false))
    {
        alert("Select one accept assignment");
        $('cms1500_accept_assignment_yes').focus();
        return false;
    }
    else
        return true;
}

