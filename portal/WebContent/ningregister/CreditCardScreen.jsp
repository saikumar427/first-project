<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.creditcard.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>
<%@ include file='/xfhelpers/xffunc.jsp' %>

<script type="text/javascript" language="JavaScript" src="/home/js/popup.js">
        function dummy2() { }
</script>


<%
String eventid=request.getParameter("GROUPID");

%>
<%!



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
			grandtotal=currencyformat+"<span id='grandtotal'>"+grandtotal+"</span>";
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
				sb.append("</td></tr><tr><td  height='30' class='inputlabel'>City *</td><td height='30' class='inputvalue'>");
				sb.append(getXfTextBox(BASE_REF+"/profiledata/city",GenUtil.getEncodedXML(ccm.getProfiledata().getCity() ),"35"));
				sb.append("</td></tr><tr><td height='30' class='inputlabel'>State *</td><td height='30' class='inputvalue'>");
				sb.append(getXfSelectListBox(BASE_REF+"/profiledata/state",EventbeeStrings.getUSStateCodes(),EventbeeStrings.getUSStateNames(),  GenUtil.getEncodedXML(ccm.getProfiledata().getState() )    ));

                                sb.append("</td></tr><tr><td height='30' class='inputlabel'>Country</td><td height='30' class='inputvalue'>");
				sb.append(getXfSelectListBox(BASE_REF+"/profiledata/country",new String[]{"US"},new String[]{"USA"},  GenUtil.getEncodedXML(ccm.getProfiledata().getCountry() )      ));

				sb.append("</td></tr><tr><td  height='30' class='inputlabel'>Zip *</td><td height='30' class='inputvalue'>");
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




