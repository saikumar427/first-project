<%@ page import="com.paypal.svcs.types.ap.*,com.paypal.svcs.services.*,src.paypalsamples.utils.*, com.eventbee.general.EbeeConstantsF"%>
<%
String paykey=null;
String message="success";
String ermsg="";
String paypal_payment_option="";
paypal_payment_option=request.getParameter("payoption");
String email=request.getParameter("email");
String currency=request.getParameter("currency");
String ebee_paypal_mailid=EbeeConstantsF.get("eventbee.paypalx.account.email","satya_1320824537_biz@gmail.com");
if(currency==null || "".equals(currency))currency="USD";
System.out.println("email: "+email);
System.out.println("currency:"+currency);
try {
    System.out.println("calling manager test");
    String paypalfeepayer="EACHRECEIVER";
	ReceiverList list = new ReceiverList();
	Receiver rec1 = new Receiver();
	rec1.setAmount(new java.math.BigDecimal("25.00"));
	rec1.setEmail(email);
  if("Chained".equalsIgnoreCase(paypal_payment_option))
    rec1.setPrimary(new Boolean(true));
else
	rec1.setPrimary(new Boolean(false));


  
  
  list.getReceiver().add(rec1);
if("Chained".equalsIgnoreCase(paypal_payment_option))
{	System.out.println("chained");
    paypalfeepayer="PRIMARYRECEIVER";
    Receiver rec2 = new Receiver();
	rec2.setAmount(new java.math.BigDecimal("1.00"));
	System.out.println("ebee_paypal_mailid: "+ebee_paypal_mailid);
	rec2.setEmail(ebee_paypal_mailid);
	rec2.setPrimary(new Boolean(false));
	list.getReceiver().add(rec2);
}
	
	
PayRequest payRequest   = new PayRequest();		
payRequest.setFeesPayer(paypalfeepayer);
payRequest.setCancelUrl("http://www.eventbee.com");
payRequest.setReturnUrl("http://www.eventbee.com");
payRequest.setCurrencyCode(currency);
payRequest.setClientDetails(ClientInfoUtil.getMyAppDetails());
payRequest.setReceiverList(list);
payRequest.setRequestEnvelope(ClientInfoUtil.getMyAppRequestEnvelope());
payRequest.setActionType("PAY");
payRequest.setIpnNotificationUrl("http://www.eventbee.com");
System.out.println("payRequest "+ payRequest);
//AdaptivePayments ap = new AdaptivePayments();
adaptivepayments.AdaptivePayments ap = new adaptivepayments.AdaptivePayments();
System.out.println("ap declared:");
//System.out.println("ap declared:"+common.com.paypal.platform.sdk.CallerServices.getPayPalBaseEndpoint());
System.out.println("API Base ENDPOINT: "+common.com.paypal.platform.sdk.CallerServices.getClientprops().getProperty("API_BASE_ENDPOINT"));
System.out.println("X-PAYPAL-SECURITY-USERID: "+common.com.paypal.platform.sdk.CallerServices.getClientprops().getProperty("X-PAYPAL-SECURITY-USERID"));
System.out.println("X-PAYPAL-APPLICATION-ID: "+common.com.paypal.platform.sdk.CallerServices.getClientprops().getProperty("X-PAYPAL-APPLICATION-ID"));
PayResponse payResp  = ap.pay(payRequest);
System.out.println("API Base ENDPOINT after pay: "+common.com.paypal.platform.sdk.CallerServices.getClientprops().getProperty("API_BASE_ENDPOINT"));
System.out.println("**** 1.Pay: Success: Created payKey is "+ payResp.getPayKey());
session.setAttribute("payResponseRef", payResp);			    
paykey=payResp.getPayKey();
}catch (Exception e) {
System.out.println("Execption at getting paykey:"+e.getMessage());
ermsg=e+"";}
if(paykey==null) {message="Invalid Paypal merchant Email <br/> Cause: "+ermsg;System.out.println("fail");}
else
 {System.out.println("paykey"+paykey);}
%>

<%=message%>
