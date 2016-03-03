<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.creditcard.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>
<%@ include file='/xfhelpers/xffunc.jsp' %>

<script type="text/javascript" language="JavaScript" src="/home/js/popup.js">
        function dummy2() { }
</script>
<script>

function changeStates(){
var frm=document.getElementById("form-register-event");
var options=frm.country;
var selectedoption="";
for(var j=0;j<options.length;j++){
if(options[j].selected==true){
selectedoption=options[j].value;
break;
}
}
if(selectedoption=='US'){
document.getElementById('state').style.display='block';
document.getElementById('sstate').style.display='none';
document.getElementById('statelabel').innerHTML='State *';
document.getElementById('zipcodelabel').innerHTML='Zip *';
document.getElementById('citylabel').innerHTML='City *';

}
else
{
document.getElementById('state').style.display='none';
document.getElementById('sstate').style.display='block';
if(selectedoption=='CA'){
document.getElementById('statelabel').innerHTML='Province *';
document.getElementById('zipcodelabel').innerHTML='Postal Code *';
document.getElementById('citylabel').innerHTML='City *';
}
else if(selectedoption=='AU'){
document.getElementById('statelabel').innerHTML='State/Territory *';
document.getElementById('zipcodelabel').innerHTML='Postcode *';
document.getElementById('citylabel').innerHTML='Town/City *';
}
else if(selectedoption=='AL'){
document.getElementById('statelabel').innerHTML='State/Province/Region *';
document.getElementById('zipcodelabel').innerHTML='Postal Code *';
document.getElementById('citylabel').innerHTML='City *';
}

else if(selectedoption=='GB'){
document.getElementById('statelabel').innerHTML='County *';
document.getElementById('zipcodelabel').innerHTML='Postal Code *';
document.getElementById('citylabel').innerHTML='Town/City *';
}


else
{
document.getElementById('statelabel').innerHTML='State / Province / Region *';
document.getElementById('zipcodelabel').innerHTML='Postal Code *';
document.getElementById('citylabel').innerHTML='City *';
}
}
}

</script>

<%
String eventid=request.getParameter("GROUPID");

%>
<%!

String CountryNames[]=new String[]{"USA","Albania","Algeria","Andorra","Angola","Anguilla","Antigua and Barbuda","Armenia","Aruba",
"Argentina","Australia","Austria","Azerbaijan Republic","Bahamas","Bahrain","Barbados","Belgium",
"Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","British Virgin Islands",
"Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Canada","Cape Verde","Cayman Islands","Chad",
"China","Chile","Colombia","Comoros","Costa Rica","Cook Islands","Croatia","Cyprus","Czech Republic",
"Denmark","Democratic Republic of the Congo","Djibouti","Dominica","Dominican Republic","Ecuador",
"El Salvador","Eritrea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Federated States of Micronesia",
"Fiji","Finland","France","French Guiana","French Polynesia","Gabon Republic","Gambia","Germany",
"Gibraltar","Greenland","Greece","Grenada","Guadeloupe","Guatemala","Guinea","Guinea Bissau","Guyana",
"Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Ireland","Israel","Italy","Japan",
"Jamaica","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait","Kyrgyzstan","Laos","Latvia","Lesotho",
"Liechtenstein","Lithuania","Luxembourg","Madagascar","Malaysia","Malawi","Maldives","Mali","Malta",
"Marshall Islands","Martinique","Mauritania","Mauritius","Mayotte","Mexico","Mongolia","Montserrat",
"Morocco","Mozambique","Namibia","Nauru","Nepal","Netherlands","Netherlands Antilles","New Zealand",
"New Caledonia","Nicaragua","Niger","Niue","Norfolk Island","Norway","Oman","Palau","Panama","Papua New Guinea",
"Peru","Philippines","Pitcairn Islands","Poland","Portugal","Qatar","Republic of the Congo","Reunion",
"Romania","Russia","Rwanda","Saint Vincent and the Grenadines","San Marino","Samoa","São Tomé and Príncipe",
"Saudi Arabia","Senegal","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands",
"Somalia","South Africa","South Korea","Spain","Sri Lanka","St. Helena","St. Kitts and Nevis",
"St. Lucia","St. Pierre and Miquelon","Suriname","Svalbard and Jan Mayen Islands","Swaziland","Sweden",
"Switzerland","Taiwan","Tajikistan","Tanzania","Thailand","Togo","Tonga","Trinidad and Tobago","Tunisia",
"Turkey","Turkmenistan","Turks and Caicos Islands","Tuvalu","Uganda","Ukraine","United Arab Emirates",
"United Kingdom","Uruguay","Vanuatu","Vatican City State","Venezuela","Vietnam","Wallis and Futuna Islands",
"Yemen","Zambia"};

String CountryCodes[]=new String[]{"US","AL","DZ","AD","AO","AI","AG","AM","AW","AR","AU","AT","AZ","BS","BH",
"BB","BE","BZ","BJ","BM","BT","BO","BA","BW","BR","VG","BN","BG","BF","BI","KH",
"CA","CV","KY","TD","C2","CL","CO","KM","CR","CK","HR","CY","CZ","DK",
"CD","DJ","DM","DO","EC","SV","ER","EE","ET","FK","FO","FM","FJ","FI","FR","GF","PF",
"GA","GM","DE","GI","GL","GR","GD","GP","GT","GN","GW","GY","HN","HK","HU","IS","IN","ID",
"IE","IL","IT","JP","JM","JO","KZ","KE","KI","KW","KG","LA","LV","LS","LI","LT",
"LU","MG","MY","MW","MV","ML","MT","MH","MQ","MR","MU","YT","MX","MN","MS","MA","MZ","NA","NR",
"NP","NL","AN","NZ","NC","NI","NE","NU","NF","NO","OM","PW","PA","PG","PE","PH","PN","PL","PT","QA",
"CG","RE","RO","RU","RW","VC","SM","WS","ST","SA","SN","SC","SL","SG","SK","SI","SB","SO","ZA","KR",
"ES","LK","SH","KN","LC","PM","SR","SJ","SZ","SE","CH","TW","TJ","TZ","TH","TG","TO","TT","TN",
"TR","TM","TC","TV","UG","UA","AE","GB","UY","VU","VA","VE","VN","WF","YE","ZM"};


		String YEARS[]=new String[]{"2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020"};
		String getCardScreen(CreditCardModel ccm,String eventid){
			StringBuffer sb=new StringBuffer("");
			String BASE_REF=ccm.BASE_REF;
			String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{eventid});
                        if(currencyformat==null)
		        currencyformat="$";
			String grandtotal=ccm.getGrandtotal();
			CurrencyFormat cf=new CurrencyFormat();
			grandtotal=cf.getCurrency2decimal(grandtotal);

			grandtotal=currencyformat+""+grandtotal;

			sb.append("<table class='inform' cellpading='0'><tr><td>Amount: ");
			sb.append(grandtotal);
			sb.append(" (NOTE: CC processing is done by Eventbee. Eventbee appears on your credit card statement)</td></tr>");
			sb.append("</table>");
                        sb.append("<br/>");
			sb.append("<table class='block'><tr><td width='40%' height='30' class='inputlabel'>Card Type *</td><td  width='240' height='30' class='inputvalue'>");
			sb.append(getXfSelectOneCombo(BASE_REF+"/cardtype",EventbeeStrings.cardtypes,EventbeeStrings.carddisplaytypes, ccm.getCardtype() ));
			sb.append("</td></tr><tr><td  height='30' class='inputlabel'>Card Number *</td><td height='30' class='inputvalue'>");
			sb.append(getXfTextBox(BASE_REF+"/cardnumber",GenUtil.getEncodedXML(ccm.getCardnumber() ),"25"));
			sb.append("</td></tr>");
			String CVV2_ENABLE=EbeeConstantsF.get("CVV2_ENABLE1","yes");
			String cardvendor=EbeeConstantsF.get("cardvendor","");
			//if("yes".equals(CVV2_ENABLE)){
			if("yes".equals(CVV2_ENABLE)&&"PAYPALPRO".equals(cardvendor)){
			String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";
			String helplink="(<a href=\"javascript:popupwindow('"+linkpath+"/cvvcodehelp.html','Tags','600','400')\">Where is my CVV Code?</a>)";							
			
				sb.append("<tr><td  height='30' class='inputlabel'>CVV Code *<br/>"+helplink+"</td><td height='30' valign='top' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/cvvcode",GenUtil.getEncodedXML(ccm.getCvvcode() ),"25"));
				sb.append("</td></tr>");
			}
			sb.append("<tr><td height='30' class='inputlabel'>Expiration Month</td><td height='30' class='inputvalue'>");
			sb.append(getXfSelectOneCombo(BASE_REF+"/expmonth",EventbeeStrings.monthvals,EventbeeStrings.months, GenUtil.getEncodedXML(ccm.getExpmonth() )    ));

			sb.append("</td></tr><tr><td height='30' class='inputlabel'>Expiration Year</td><td height='30' class='inputvalue'>");
			sb.append(getXfSelectOneCombo(BASE_REF+"/expyear",YEARS,YEARS, GenUtil.getEncodedXML(ccm.getExpyear() )    ));


			sb.append("</td></tr>");
			sb.append("</table>");
                        sb.append("<br/>");
			if(ccm.getProfiledata()!=null){
				sb.append("<table class='block'>");
				sb.append("<tr><td colspan='2' class='medium'>Credit Card Billing Address</td></tr><tr><td width='240' height='30' class='inputlabel'>First Name *</td><td   width='240' height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/firstName",GenUtil.getEncodedXML(ccm.getProfiledata().getFirstName() ),"25"));
				sb.append("</td></tr><tr><td width='40%' height='30' class='inputlabel'>Last Name *</td><td height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/lastName",GenUtil.getEncodedXML(ccm.getProfiledata().getLastName() ),"25"));
				sb.append("</td></tr><tr><td height='30' class='inputlabel'>Email *</td><td height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/email",GenUtil.getEncodedXML(ccm.getProfiledata().getEmail() ),"30"));
				sb.append("</td></tr><tr><td  height='30' class='inputlabel'>Organization</td><td height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/company",GenUtil.getEncodedXML(ccm.getProfiledata().getCompany() ),"35"));
				sb.append("</td></tr><tr><td  height='30' class='inputlabel'>Street *</td><td height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/street1",GenUtil.getEncodedXML(ccm.getProfiledata().getStreet1() ),"35"));
				sb.append("</td></tr><tr><td  height='30' class='inputlabel'>Apt/Suite</td><td height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/street2",GenUtil.getEncodedXML(ccm.getProfiledata().getStreet2() ),"35"));
				sb.append("</td></tr><tr><td  height='30' class='inputlabel' id='citylabel'>City *</td><td height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/city",GenUtil.getEncodedXML(ccm.getProfiledata().getCity() ),"35"));
				sb.append("</td></tr><tr><td height='30' id='statelabel' class='inputlabel'>State *</td><td height='30' class='inputvalue'><div id='state' style='display:block'>");
				sb.append(getXfSelectListBox(BASE_REF+"/profiledata/state",EventbeeStrings.getUSStateCodes(),EventbeeStrings.getUSStateNames(),  GenUtil.getEncodedXML(ccm.getProfiledata().getState() )    ));
				sb.append("</div><div id='sstate' style='display:none'>"+getXfTextBox(BASE_REF+"/profiledata/non_us_state",GenUtil.getEncodedXML(ccm.getProfiledata().getState() ),"25"));
				sb.append("</div></td></tr><tr><td height='30' class='inputlabel'>Country</td><td height='30' class='inputvalue'>");
				sb.append(getXfSelectListBox("country",CountryNames,CountryCodes,GenUtil.getEncodedXML(ccm.getProfiledata().getCountry() )," onChange='changeStates();'"      ));
                             	sb.append("</td></tr><tr><td  height='30' class='inputlabel' id='zipcodelabel'>Zip *</td><td height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/zip",GenUtil.getEncodedXML(ccm.getProfiledata().getZip() ),"10"));
				sb.append("</td></tr><tr><td  height='30' class='inputlabel'>Phone * <br/>(10 digits)</td><td height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/phone",GenUtil.getEncodedXML(ccm.getProfiledata().getPhone() ),"10"));
				sb.append("</td></tr><tr><td>");
				sb.append("</td></tr><tr><td>");
				sb.append("</td></tr></table>");
				sb.append("<input type='hidden' name='BASE_REF' value='"+BASE_REF+"' />");
			}
			return sb.toString();

	}


%>

<%
	if(request.getAttribute("ccm")!=null)
	out.println(getCardScreen(  (CreditCardModel)request.getAttribute("ccm"),eventid )  ) ;
%>


<script>

changeStates();

</script>


