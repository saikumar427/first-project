<%@ page import="java.util.*,com.eventbee.general.*,java.lang.Math"%>
<%@ page import="com.eventbee.creditcard.PaymentTypes,com.eventbee.general.formatting.*,com.eventregister.*"%>
<%@ page import="adaptivepayments.AdaptivePayments"%>
<%@ page import="com.paypal.svcs.types.ap.*"%>
<%@ page import="com.paypal.svcs.types.common.*"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="common.com.paypal.platform.sdk.exceptions.*"%>
<%@ page import="com.paypal.svcs.services.*"%>
<%@ page import="java.io.IOException"%>
<%@ page import="src.paypalsamples.utils.*"%>
<%@ page language="java"%>
<%@include file="precheck.jsp"%>
<%@ include file="PaypalXPaymentDetails.jsp" %>

<body>

<%
PaypalXPaymentDetails paypalxdetails=new PaypalXPaymentDetails();
PaymentDataDetails paydetails=new PaymentDataDetails();
String  SSLProtocol=EbeeConstantsF.get("SSLProtocol","https");
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.eventbee.com");
String sslserveraddress=SSLProtocol+"://"+EbeeConstantsF.get("sslserveraddress","www.eventbee.com");
String eventid=request.getParameter("eid");
String transactionid=newTrnId;
HashMap attribmap=paypalxdetails.fillpaypalxData(eventid,serveraddress,transactionid);
paydetails.updatePaypalPaymentData(transactionid,eventid,GenUtil.getHMvalue(attribmap,"paypalmerchantid","0"));
String itemName=GenUtil.getHMvalue(attribmap,"itemname","Event Registration Charges");
String ebee_paypal_mailid=EbeeConstantsF.get("eventbee.paypalx.account.email","support@eventbee.com");
String paypal_merchantid=GenUtil.getHMvalue(attribmap,"paypalmerchantid",""); 
HashMap hm=paypalxdetails.getPaypalxFeedetails(eventid);
String paypalfeepayer="PRIMARYRECEIVER";
String paypal_payment_option=GenUtil.getHMvalue(hm,"paymentoption","chained");
String servicefee=GenUtil.getHMvalue(hm,"servicefee","");
String paypal_form_url=(String)attribmap.get("paypal_form_url");
String paypal_notify_url=(String)attribmap.get("paypal_notify_url");
String paypallang=(String)attribmap.get("paypallang");
String currencycode=DbUtil.getVal("select currency_code from event_currency where eventid=?", new String []{eventid});
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=CAST(? AS BIGINT)", new String []{eventid});
if(currencycode==null||"".equals(currencycode))
currencycode="USD";
StatusObj statobjn=null;
List receiverEmailItems=new ArrayList();
List amountItems=new ArrayList();
List primaryItems=new ArrayList();
String nextUrl="";
String paykey=null;
try {
StringBuilder url = new StringBuilder();
String useragent = request.getHeader("User-Agent");
String serverid=request.getRemoteHost();
String returnURL=serveraddress+"/embedded_reg/paypalsuccessreturn.jsp?id="+transactionid+"&source=Paypal&GROUPID="+eventid;
String cancelURL = serveraddress+"//embedded_reg/paypalcancelreturn.jsp?tid="+transactionid+"&source=Paypal&eid="+eventid;	
String originalServiceFee="0.00";
String collectingServiceFee="0";
String grandtotal="";
String ntscommission="0.00";
String amtsQry="select grandtotal,ebeefee,collected_servicefee,nts_commission  from event_reg_details_temp where tid=?";
DBManager dbmanager1=new DBManager();
StatusObj statobj1=null;
statobj1=dbmanager1.executeSelectQuery(amtsQry,new String []{transactionid});
System.out.println("paypalxpaymentdata.jsp"+statobj1.getStatus());
if(statobj1.getStatus()){
grandtotal=dbmanager1.getValue(0,"grandtotal","0.00");
originalServiceFee=dbmanager1.getValue(0,"ebeefee","0.00");
collectingServiceFee=dbmanager1.getValue(0,"collected_servicefee","0.00");
ntscommission=dbmanager1.getValue(0,"nts_commission","0.00");
}
System.out.println("paypalxpaymentdata-"+transactionid+": checking manager credits...");
String haveCredits=DbUtil.getVal("select 'yes' from mgr_available_credits where mgr_id in (select mgr_id from eventinfo where eventid=?::INTEGER) and available_credits>=?::NUMERIC",new String[]{eventid,originalServiceFee});
if("yes".equals(haveCredits)){
	System.out.println("paypalxpaymentdata-"+transactionid+": credits available. Changing paypalxmode to simple");
	paypal_payment_option="";
}else
	System.out.println("paypalxpaymentdata-"+transactionid+": credits not available. Proceeding with paypalxmode "+paypal_payment_option);
String totamt=CurrencyFormat.getCurrencyFormat("",grandtotal,true);
 originalServiceFee=CurrencyFormat.getCurrencyFormat("",originalServiceFee,true);
 double tamt=Double.parseDouble(totamt);
 double serfee=Double.parseDouble(originalServiceFee);
 double collectingservicefee=Double.parseDouble(collectingServiceFee);
 double nts_commission=Double.parseDouble(ntscommission);
 double final_collecting_fee=serfee+nts_commission;
 if(collectingservicefee>0) final_collecting_fee=collectingservicefee;
  if((tamt-final_collecting_fee)<final_collecting_fee){
	final_collecting_fee=(tamt*0.4);
	paypal_payment_option="";
 }
 String finalfee=CurrencyFormat.getCurrencyFormat("",Double.toString(final_collecting_fee),true);
 
if("Chained".equalsIgnoreCase(paypal_payment_option) && final_collecting_fee>0)
{
System.out.println("paypalxpaymentdata-"+transactionid+": in chained");
//paypalxdetails.updateServicefee(finalfee,transactionid);
try{
if("TWD".equalsIgnoreCase(currencycode) || "JPY".equalsIgnoreCase(currencycode) || "HUF".equalsIgnoreCase(currencycode)){
   finalfee=Double.toString(Math.round(Double.parseDouble(finalfee)));
   finalfee=CurrencyFormat.getCurrencyFormat("",finalfee,true);
   System.out.println("In paypal Chained case finalfee is :: "+finalfee+" transactionid :: "+transactionid);
}
}catch(Exception e){
   System.out.println("Exception occured in paypalxpaymentdata for rounding finalfee value:: "+eventid+" :: "+transactionid+" :: "+e.getMessage());
 }
DbUtil.executeUpdateQuery("update event_reg_details_temp set paymentmode='chained',collected_servicefee=CAST(? as NUMERIC) where tid=?",new String[]{finalfee,transactionid});
System.out.println("paypalxpaymentdata.jsp parallel paypal selected");
receiverEmailItems.add(0,paypal_merchantid);
receiverEmailItems.add(1,ebee_paypal_mailid);
amountItems.add(0,totamt);
System.out.println("originalServiceFee: "+originalServiceFee);
System.out.println("ntscommission: "+ntscommission);
amountItems.add(1,finalfee);
primaryItems.add(0,"true");
primaryItems.add(1,"false");
}
else{
System.out.println("paypalxpaymentdata-"+transactionid+": in simple");
DbUtil.executeUpdateQuery("update event_reg_details_temp set paymentmode='simple' where tid=?",new String[]{transactionid});
paypalfeepayer="EACHRECEIVER";
receiverEmailItems.add(0,paypal_merchantid);
amountItems.add(0,totamt);
primaryItems.add(0,"false");
}
ReceiverList list = new ReceiverList();
System.out.println("len"+receiverEmailItems.size());
for(int i=0;i<receiverEmailItems.size(); i++)
{
String recreceiverEmail=(String) receiverEmailItems.get(i);
System.out.println("recreceiverEmail"+recreceiverEmail);
if(recreceiverEmail != null && recreceiverEmail.length()!= 0)
{
Receiver rec1 = new Receiver();
rec1.setAmount(new BigDecimal((String) amountItems.get(i)));
rec1.setEmail((String) receiverEmailItems.get(i));
if(paypal_payment_option.equalsIgnoreCase("chained")){
System.out.println("(String) primaryItems.get(i)"+(String) primaryItems.get(i));
if ("true".equalsIgnoreCase((String) primaryItems.get(i))) {
rec1.setPrimary(new Boolean(true));
} else {
rec1.setPrimary(new Boolean(false));	
}
}
list.getReceiver().add(rec1);
}
}
String memo="";
PayRequest payRequest   = new PayRequest();		
ClientDetailsType cl = new ClientDetailsType();
RequestEnvelope en = new RequestEnvelope();
payRequest.setMemo("Registration at Eventbee for \""+eventname+"\"\n\nEventbee Transaction ID: "+transactionid);
payRequest.setFeesPayer(paypalfeepayer);
payRequest.setCancelUrl(cancelURL);
payRequest.setReturnUrl(returnURL);
payRequest.setCurrencyCode(currencycode);
payRequest.setClientDetails(ClientInfoUtil.getMyAppDetails());
payRequest.setReceiverList(list);
payRequest.setRequestEnvelope(ClientInfoUtil.getMyAppRequestEnvelope());
payRequest.setActionType("PAY");
String trackingId=transactionid+(new Date().getTime());
payRequest.setTrackingId(trackingId);
payRequest.setIpnNotificationUrl(paypal_notify_url);
System.out.println("payRequest "+ payRequest);
AdaptivePayments ap = new AdaptivePayments();
System.out.println("ap declared:");
//System.out.println("ap declared:"+common.com.paypal.platform.sdk.CallerServices.getPayPalBaseEndpoint());
System.out.println("API Base ENDPOINT: "+common.com.paypal.platform.sdk.CallerServices.getClientprops().getProperty("API_BASE_ENDPOINT"));
System.out.println("X-PAYPAL-SECURITY-USERID: "+common.com.paypal.platform.sdk.CallerServices.getClientprops().getProperty("X-PAYPAL-SECURITY-USERID"));
System.out.println("X-PAYPAL-APPLICATION-ID: "+common.com.paypal.platform.sdk.CallerServices.getClientprops().getProperty("X-PAYPAL-APPLICATION-ID"));
PayResponse payResp  = ap.pay(payRequest);
System.out.println("API Base ENDPOINT after pay: "+common.com.paypal.platform.sdk.CallerServices.getClientprops().getProperty("API_BASE_ENDPOINT"));

System.out.println("**** 1.Pay: Success: Created payKey is "+ payResp.getPayKey());
session.setAttribute("payResponseRef", payResp);			    
nextUrl=paypal_form_url;
paykey=payResp.getPayKey();
SetPaymentOptionsRequest sp= new SetPaymentOptionsRequest();;
sp.setRequestEnvelope(en);
sp.setPayKey(paykey);
SenderOptions sop=new SenderOptions();
sop.setReferrerCode("Eventbee_SP");
sp.setSenderOptions(sop);
System.out.println("reffercode::"+sop.getReferrerCode());
SetPaymentOptionsResponse spres=ap.setPaymentOption(sp);
spres.getResponseEnvelope();
System.out.println("spres::"+spres.getResponseEnvelope().getAck());
//After generating paykey we are inserting paykey and tid in to the table paypalkeys
//DbUtil.executeUpdateQuery("update paypal_payment_data set paykey=?,time=now() where ebee_tran_id=?", new String []{paykey,transactionid});
DbUtil.executeUpdateQuery("update paypal_payment_data set paykey=?,tracking_id=?,time=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS') where ebee_tran_id=?", new String []{paykey,trackingId,DateUtil.getCurrDBFormatDate(),transactionid});
}
catch (Exception e) {
paykey=null;
System.out.println("CONFIGERRORException"+e.getMessage());
paypalxdetails.updateApiErrorDetailsToDb(eventid,transactionid,e);
//response.sendRedirect("APIError.jsp?eid="+eventid);
System.out.println("converting from paypalx to normal paymal for:"+eventid+"::tid::"+transactionid);
DbUtil.executeUpdateQuery("update event_reg_details_temp set paymentmode=NULL where tid=?",new String[]{transactionid});
response.sendRedirect(sslserveraddress+"/embedded_reg/paymentdata.jsp?tid="+transactionid+"&eid="+eventid+"&paytype=paypal");
return;
}
%>
<%
if(paykey!=null){
%>
<form name='paytypeform' id='paytypeform'action="<%=paypal_form_url%>" method="post" target="_top">
<input type="hidden" name="cmd" value="_ap-payment">
<input type="hidden" name="paykey" value="<%=paykey%>">
</form>
<script>
document.getElementById('paytypeform').submit();	
</script>
<%}
else{%>
Unable to process paypal payment, please try back later.
<%}%>
