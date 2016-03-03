<%@ page import="java.util.*,com.eventbee.general.*"%>
<%@ page import="com.eventbee.creditcard.PaymentTypes,com.eventbee.general.formatting.*,com.eventregister.*"%>
<%@include file="precheck.jsp"%>
<body>
<%
PaymentDataDetails paydetails=new PaymentDataDetails();
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.eventbee.com");
String eventid=request.getParameter("eid");
String transactionid=newTrnId;
String amount="0.00",tax="0.00";
HashMap paypalMap=paydetails.fillpaypalData(eventid,serveraddress,transactionid);
paydetails.updatePaypalPaymentData(transactionid,eventid,GenUtil.getHMvalue(paypalMap,"paypalmerchantid","0"));
String currencycode=GenUtil.getHMvalue(paypalMap,"currencycode","0");
try{
amount=GenUtil.getHMvalue(paypalMap,"paypalamount","0");
tax=GenUtil.getHMvalue(paypalMap,"paypaltax","0");
if("TWD".equalsIgnoreCase(currencycode) || "JPY".equalsIgnoreCase(currencycode) || "HUF".equalsIgnoreCase(currencycode))
   amount=Double.toString(Math.ceil(Double.parseDouble(amount)+Double.parseDouble(tax)));
}catch(Exception e){
  System.out.println("Exception occured in paymentdata for removing float currency:"+eventid+" :: "+transactionid+" :: "+ e.getMessage());
}
amount=CurrencyFormat.getCurrencyFormat("", amount, false);
System.out.println("In normal paypal case amount is:"+amount);
if("EN".equals(GenUtil.getHMvalue(paypalMap,"paypallang","US"))){
paypalMap.put("paypallang","US");
}
%>
<form name='paypalform' id='paypalform' action="<%=GenUtil.getHMvalue(paypalMap,"paypal_form_url","")%>" method="post" target="_top">
   <input type="hidden" name="cmd" value="_xclick">
   <input type="hidden" name="business" value="<%=GenUtil.getHMvalue(paypalMap,"paypalmerchantid","0")%>">
   <input type="hidden" name="item_name"   value="<%=GenUtil.getHMvalue(paypalMap,"itemname","")%>">
   <input type="hidden" name="item_number"   value="<%=transactionid%>">
    <%if("TWD".equalsIgnoreCase(currencycode) || "JPY".equalsIgnoreCase(currencycode) || "HUF".equalsIgnoreCase(currencycode)){%>
	<input type="hidden" name="amount" value="<%=amount%>">
    <%}else{%>
	<input type="hidden" name="amount" value="<%=amount%>">
    <input type="hidden" name="tax" value="<%=tax%>">
   <%}%>
   <input type="hidden" name="no_shipping" value="1">
   <input type="hidden" name="no_note" value="1">
   <input type="hidden" name="currency_code" value="<%=GenUtil.getHMvalue(paypalMap,"currencycode","0")%>">
   <input type="hidden" name="bn" value="Eventbee_SP">
   <input type="hidden" name="notify_url" value="<%=GenUtil.getHMvalue(paypalMap,"paypal_notify_url","0")%>">
   <input type="hidden" name="lc" value="<%=GenUtil.getHMvalue(paypalMap,"paypallang","US")%>">
   <input type="hidden" name="return" value="<%=serveraddress%>/embedded_reg/paypalsuccessreturn.jsp?id=<%=transactionid%>&source=Paypal&GROUPID=<%=eventid%>">
   <input type="hidden" name="cancel_return" value="<%=serveraddress%>/embedded_reg/paypalcancelreturn.jsp?tid=<%=transactionid%>&source=Paypal&eid=<%=eventid%>">
   <%if("142401792".equals(eventid)){ System.out.println("costcode ::"+eventid);%>  
     <input type="hidden" name="CostCode" value="9018.01.001">
	 <%}%>
</form>
<script>
document.getElementById('paypalform').submit();	
</script>
</body>


