<%
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");
String isCommunityEvent=(String)request.getAttribute("isCommunityEvent");
String customcssURL="/ningregister/ticketpagecss.jsp?eid="+eid;
String oid=(String)request.getAttribute("oid");
String domain=(String)request.getAttribute("domain");
String eventpageLink="/event?eid="+eid+"&platform=ning&domain="+domain+"&oid="+oid;
String javascriptURL="/ningregister/ticketpagejs.jsp";
String loginHelpURL="/portal/guesttasks/loginproblem.jsp?entryunitid=13579&UNITID=13579";
String eventname=(String)request.getAttribute("eventName");
String headerContent=(String)request.getAttribute("headerContent");
String serverHTTPAddress=(String)request.getAttribute("serverHTTPAddress");
String pageTitle=(String)request.getAttribute("pageTitle");
String LoggedInMessage=(String)request.getAttribute("LoggedInMessage");
String MemberLoginMessage=(String)request.getAttribute("MemberLoginMessage");
String membersignupURL=(String)request.getAttribute("membersignupURL");
String membershipLinkMessage=(String)request.getAttribute("memberShipLinkMessage");
String membershipDetailsMessage=(String)request.getAttribute("memberShipDetailsMessage");
String termsandconditions=(String)request.getAttribute("termsAndConditions");
String currencySymbol=(String)request.getAttribute("currencySymbol");
String reqTicketsHeaderMessage=(String)request.getAttribute("reqTicketsHeaderMessage");
String TicketsPriceLabel=(String)request.getAttribute("TicketsPriceLabel");
String TicketsFeeLabel=(String)request.getAttribute("TicketsFeeLabel");
String TicketsQtyLabel=(String)request.getAttribute("TicketsQtyLabel");
String optTicketsHeaderMessage=(String)request.getAttribute("optTicketsHeaderMessage");
String RegistrationLabel=(String)request.getAttribute("RegistrationLabel");
String TaxPercentvalue=(String)request.getAttribute("TaxPercentvalue");
String TaxLabel=(String)request.getAttribute("TaxLabel");
String paypalCancelReturnURL=serverHTTPAddress+"/ningregister/paypalcancelreturn.jsp?tid="+tid;
String paypalConfirmReturnURL=serverHTTPAddress+"/ningregister/paypalconfirmreturn.jsp?tid="+tid;
String serverHTTPSAddress=(String)request.getAttribute("serverHTTPSAddress");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">

<title><%=pageTitle%></title>
<link rel="stylesheet" type="text/css" href="/home/customlisting.css" />

<style>
<%@ include file="ticketpagecss.jsp" %>
</style>

<!--------*****************************************BEGIN MANDATORY SECTION DO NOT CHANGE*******************************----->
<script type="text/javascript" language="JavaScript" src="/home/js/ajaxjson.js"></script>
<script type="text/javascript" language="JavaScript" src="<%=javascriptURL%>"></script>
<script type="text/javascript" language="javascript" src="/home/js/numberstowords.js" ></script>
<!--------*****************************************END MANDATORY SECTION *******************************----->

</head>

<body>
<div id="topcontainer">


<!--***********************************Begin Header block*******************************-->
<!--
<div id="header" >
<table width='100%' border='0' cellpadding='0' cellspacing='0' >
<tr><td >
			
<%=headerContent%>
</td></tr>
</table>
</div>-->
<!--***********************************End Header block*******************************-->
<div id="container">
<!--***********************************Begin Task Bar block*******************************-->
<table height='10'><tr><td></td></tr></table>
<table width="100%">
<tr><td class='taskheader'>
<div  style='float:left'>
<a href='<%=eventpageLink%>'><%=eventname%></a> > <%=RegistrationLabel%>
</div>
</td>
</tr>
</table>
<!--***********************************End Task Bar block*******************************-->
<div id="loadingmsg" style="height:300px;display:block">
<br/><br/><div align='center' id='error'>Loading, please wait.</div>
</div>
<div id="center" style='display:none'>
<form name='ticketingpageform' id='ticketingpageform' action='' method='post'>
<input type='hidden' name='tid' value='<%=tid%>' />
<input type='hidden' name='eid' value='<%=eid%>' />
<input type='hidden' name='currentcount' value=0 />
<input type='hidden' name='attribsetid' value=0 />
<%
if(isCommunityEvent!=null)
{
%>
<!--***********************************Begin member login block*******************************-->
<div id='MemberTicketsLoginBlock' style='display:none'>
<div id='communitylogin'>
<table cellspacing="0" class="taskbox" width="99%"  align="center" valign="top" border="0">
<tr><td id="membererror" class="error"></td></tr>
<tr ><td class="subheader"><div id='afterloginmsg' style='display:none;'><%=LoggedInMessage%></div></td></tr>
<tr><td id='hublogin' style='display:block;'>
<table>
<tr ><td class="subheader"><%=MemberLoginMessage%></td></tr>
<tr><td class="inputlabel" >
User Name <input type="text" name="username" id="username" size="15" value="" />   Password  <input type="password" name="password" id="password"  size="15" value="" />   
<input type="button" name="submit" value="Login" onClick="ajaxSubmitMemberLogin();" />
<a HREF="<%=loginHelpURL%>" target="_blank">Login help?</a> 
<br/><a href="<%=membersignupURL%>" target="_blank"><%=membershipLinkMessage%></a>
</td></tr>
<tr><td class="subheader"><%=membershipDetailsMessage%>
<br/><font class='smallestfont'>Member Only Tickets will be enabled after login</font>
</td></tr>
</table></td></tr>
</table>
</div>
</div>
<!--***********************************End member login block*******************************-->
<%
}
%>

<!--***********************************Begin Tickets block*******************************-->
<div id='dynahiddenelements'></div>
<div id='ticketsBlock'>
<div id='ticketserror' class='error'></div>
<div id='requiredTicketsBlock' style='display:none'>
<table  id='reqticketstable' width='100%'>
<tr><td class='medium' colspan='5'> <%=reqTicketsHeaderMessage%></td></tr>
<tr>
<td  class='colheader' width='5%'></td>
<td  class='colheader' width='70%'></td>
<td  class='colheader' width='10%'><%=TicketsPriceLabel%>(<%=currencySymbol%>)</td>
<td  class='colheader' width='10%'><%=TicketsFeeLabel%>(<%=currencySymbol%>)</td>
<td  class='colheader' width='5%'><%=TicketsQtyLabel%></td>
</tr>
</table>
</div>

<div id='optionalTicketsBlock' style='display:none'>
<table  id='optticketstable' width='100%'>
<tr><td class='medium' colspan='5'> <%=optTicketsHeaderMessage%></td></tr>
<tr>
<td  class='colheader' width='5%'></td>
<td  class='colheader' width='70%'></td>
<td  class='colheader' width='10%'><%=TicketsPriceLabel%>(<%=currencySymbol%>)</td>
<td  class='colheader' width='10%'><%=TicketsFeeLabel%>(<%=currencySymbol%>)</td>
<td  class='colheader' width='5%'><%=TicketsQtyLabel%></td>
</tr>
</table>
</div>

</div>

<!--***********************************End Tickets block*******************************-->

<!--***********************************Begin Totals block*******************************-->
<table width="100%">
<tr>
<td width='70%' align="right"></td>
<td width='20%' align="left">Total (<%=currencySymbol%>)</td>
<td align="right" id="totamount">0.00</td>
</tr>
<tr>
<td width='70%' align="right"></td>
<td width='20%' align="left">Discounts (<%=currencySymbol%>)</td>
<td align="right" id="disamount">0.00</td>
</tr>
<tr>
<td width='70%' align="right"></td>
<td width='20%' align="left">Net Amount (<%=currencySymbol%>)</td>
<td align="right" id="netamount">0.00</td>
</tr>
<%if(Double.parseDouble(TaxPercentvalue)>0){ %>
<tr>
<td width='70%' align="right"></td>
<td width='20%' align="left"><%=TaxLabel%>-<%=TaxPercentvalue%>% (<%=currencySymbol%>)</td>
<td align="right" id="taxamount">0.00</td>
</tr>
<tr>
<td width='70%' align="right"></td>
<td width='20%' align="left">Grand Total (<%=currencySymbol%>)</td>
<td align="right" id="grandtotamount">0.00</td>
</tr>
<%}%>

</table>

<!--***********************************End Totals block*******************************-->

<!--***********************************Begin Discount Coupons block*******************************-->
<div id='discountCouponsBox' style='display:block'>
Have a discount code, enter it here: <input type='text' id='discountcode' name='discountcode' value=''/> 
<input type='button' name='applydiscount' id='applydiscount' value='Apply' onClick='ajaxSubmitForDiscountedTotals(true)'/>
<span id='discountmsg'></span>
</div>
<!--***********************************End Discount Coupons block*******************************-->

<!--***********************************Begin Attendee Profile block*******************************-->

<table  width='100%' >
<tr><td class='error' id="msgtab"></td></tr>
<tr><td class='medium'>Attendee Information</td></tr>
<tr><td> 
   <table id='profilestable' >
   <tbody></tbody>
   </table>
</td></tr>
</table>

<!--***********************************End Attendee Profile block*******************************-->

<!--***********************************Begin Terms and Conditions block*******************************-->
<table width='100%'  align='center' cellpadding='0' cellspacing='0'>
	<tr><td class="medium">Refund Policy/Terms & Conditions </td></tr>
	<tr ><td height='10'/></tr>
	<tr><td  class="inform"><table width='100%' cellpadding='5' cellspacing='0'><tr><td> 
	<div id='refundpolicy' STYLE="width: 400px; font-size: 12px; overflow: auto;">
	<%=termsandconditions%>
	</div>
	</td></tr>
	</table></td></tr>
</table>
<!--***********************************End Terms and Conditions block*******************************-->

<!--***********************************Begin Payment Options block*******************************-->


<div id='paymentforms'>
<table width='100%' cellpadding='0' cellspacing='0'>
<tr ><td height='10' /></tr>
<tr><td class="medium">Payment Method</td></tr>
<tr ><td height='10'/></tr>
<tr><td id='paymentBox'></td></tr>
<tr><td  align='center' width='40%'>
<input type='button' name='continue' id='paymentContinueBtn' Value='Continue' onClick="ValidateAndSubmit();return false;"/>
</td></tr>
</table>
</div>
</form>
<!--***********************************End Payment Options block*******************************-->

<!--***********************************Begin hidden payment forms block*******************************-->
<form name='nopaymentform' id='nopaymentform' action='registrationdone.jsp' method='post'>
<input type='hidden' name='tid' value='<%=tid%>' />
<input type='hidden' name='eid' value='<%=eid%>' />
<input type='hidden' name='paytype' id='paytype' value='' />
</form>
<form name='ebeeccform' id='ebeeccform' action='<%=serverHTTPSAddress%>/ningregister/payment.jsp?tid=<%=tid%>&eid=<%=eid%>' method='post'>
<input type="hidden" name="amount" value="">
<input type="hidden" name="currency_code" value="">
</form>

<form name='paypalform' id='paypalform' action='' method='post'  target='_top'>
<input type="hidden" name="cmd" value="_xclick">
<input type="hidden" name="item_number"   value="<%=tid%>">
<input type="hidden" name="no_shipping" value="2">
<input type="hidden" name="no_note" value="1">
<input type="hidden" name="bn" value="IC_Sample">
<input type="hidden" name="lc" value="US">

<input type="hidden" name="business" value="">
<input type="hidden" name="item_name"   value="">
<input type="hidden" name="amount" value="">
<input type="hidden" name="currency_code" value="">
<input type="hidden" name="tax" value="">
<input type="hidden" name="notify_url" value="">
<input type="hidden" name="return" value="<%=paypalConfirmReturnURL%>">
<input type="hidden" name="cancel_return" value="<%=paypalCancelReturnURL%>">
</form>
<form name='googleform' id='googleform' action='googleformaction.jsp' method='post' target='_blank'>
<input type='hidden' name='tid' value='<%=tid%>' />
<input type='hidden' name='eid' value='<%=eid%>' />
</form>
<!--***********************************End hidden payment forms block*******************************-->
</div>  <!--id=center-->
</div>  <!--id=container-->
<script>
ajaxGetTicketPageData('<%=eid%>', '<%=tid%>');
</script>
<div  id='footer' >
<%@ include file="footer.jsp" %>
</div><!--id=footer-->
 </div>  <!--id=topcontainer-->
</body>
</html>