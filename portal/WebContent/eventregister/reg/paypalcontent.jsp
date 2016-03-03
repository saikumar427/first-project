<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.eventsponsors.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.google.checkout.util.Base64Coder" %>
<%@ page import="com.eventbee.creditcard.PaymentTypes"%>

<%


EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");
jBean.setContextUnitid("13579");
double grandtotal=jBean.getGrandTotal();
double tax=jBean.getTaxAmount();
String taxamt=CurrencyFormat.getCurrencyFormat("",tax+"",true);

String totamt=CurrencyFormat.getCurrencyFormat("",grandtotal+"",true);
double grandtotalamt=Double.parseDouble(totamt);
double taxamount=Double.parseDouble(taxamt);

double amount=grandtotalamt-(taxamount);

String paypalamount=CurrencyFormat.getCurrencyFormat("",amount+"",true);

double total=Double.parseDouble(paypalamount);

String eventid=jBean.getEventId();
String ebee_transactionid=jBean.getTransactionId();
String eventname=jBean.getEventName();
String itemname=eventname+" Event Registration Charges";

String paypal_merchantid=null;
String currencycode=DbUtil.getVal("select currency_code from event_currency where eventid=?", new String []{eventid});
if(currencycode==null||"".equals(currencycode))
currencycode="USD";
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.eventbee.com");
String paypal_form_url=EbeeConstantsF.get("paypal.form.url","https://www.sandbox.paypal.com/cgi-bin/webscr");
String paypal_notify_url=EbeeConstantsF.get("paypal.notify.url","http://test.eventbee.com:8080/eventregister/reg/paypalnotification.jsp");

HashMap attrinmap=PaymentTypes.getPaymentTypeInfo(eventid,"Event","paypal");

if(attrinmap!=null){
	paypal_merchantid=(String)attrinmap.get("attrib_1");
}

	String xmldata=EventRegisterManager.writeDatatoXml(jBean);  
	
StatusObj statobjn=null;
String ebee_tran_id=DbUtil.getVal("select ebee_tran_id from paypal_payment_data where ebee_tran_id=?", new String []{jBean.getTransactionId()});
if(ebee_tran_id==null)
	statobjn= DbUtil.executeUpdateQuery("insert into paypal_payment_data (ebee_tran_id,ebee_xml_data,time,refid,ref_type) values(?,?,now(),?,?)", new String []{jBean.getTransactionId(),xmldata,eventid,"EVENT"});
else
	statobjn= DbUtil.executeUpdateQuery("update paypal_payment_data set ebee_xml_data=?,time=now() where ebee_tran_id=?", new String []{xmldata,jBean.getTransactionId()});
	
	
	

String platform=(String)session.getAttribute("platform");	
%>




<form name='paytypeform' action="<%=paypal_form_url%>" method="post" target="_top">
   <input type="hidden" name="cmd" value="_xclick">
   <input type="hidden" name="business" value="<%=paypal_merchantid%>">
   <input type="hidden" name="item_name"   value="<%=itemname%>">
   <input type="hidden" name="item_number"   value="<%=ebee_transactionid%>">
   <input type="hidden" name="amount" value="<%=total%>">
   <input type="hidden" name="no_shipping" value="2">
   <input type="hidden" name="no_note" value="1">
   <input type="hidden" name="currency_code" value="<%=currencycode%>">
   <input type="hidden" name="tax" value="<%=taxamount%>">
   <input type="hidden" name="bn" value="IC_Sample">
   <input type="hidden" name="notify_url" value="<%=paypal_notify_url%>">
   <input type="hidden" name="lc" value="US">
   
   <%if("yes".equals(request.getParameter("fbcontext"))){%>
      <input type="hidden" name="return" value="http://apps.facebook.com/<%=EbeeConstantsF.get("fbapp.eventregapp.name","eventregistration")%>/registerdone?id=<%=ebee_transactionid%>&source=Paypal&fbcontext=yes&GROUPID=<%=eventid%>">
      <input type="hidden" name="cancel_return" value="http://apps.facebook.com/<%=EbeeConstantsF.get("fbapp.eventregapp.name","eventregistration")%>/ticketedit?Gid=<%=eventid%>&context=FB">
   
   <%}
   else if("ning".equals(platform)){
    String ningowner="";
     String ningviewer="";
     String domain="";
     String encodedid="";
     String useragent = request.getHeader("User-Agent");

	if("ning".equals(platform)){
	ningowner=(String)session.getAttribute("ningoid");
	ningviewer=(String)session.getAttribute("ningvid");
	domain=(String)session.getAttribute("domain");
	HashMap hm=new HashMap();
	hm.put("paymenttype","Paypal");
	hm.put("transactionid",ebee_transactionid);
	hm.put("purpose","Registration");
	hm.put("GROUPID",eventid);
	session.setAttribute(eventid+"_"+ningowner+"_registration",hm);
	String tokenid=DbUtil.getVal("select nextval('ning_event_tokenid') as tid",new String[]{});
	encodedid=EncodeNum.encodeNum(tokenid);
	DbUtil.executeUpdateQuery("insert into ning_paypal_tokens(tokenid,encodedid,eventid,ningownerid,ning_domain,transactionid,source,useragent,date) values(?,?,?,?,?,?,?,?,now())",new String[]{tokenid,encodedid,eventid,ningowner,domain,ebee_transactionid,"paypal",useragent});

	}
    %>
   
   
<input type="hidden" name="return" value="<%=serveraddress%>/portal/ningapp/ticketing/ningpaypalconfirmation.jsp?tid=<%=encodedid%>">
<input type="hidden" name="cancel_return" value="<%=serveraddress%>/portal/ningapp/ticketing/paypaledit.jsp?tid=<%=encodedid%>">

   <%}
   
   
   
   else{%>
   	   <input type="hidden" name="return" value="<%=serveraddress%>/portal/guesttasks/processdata.jsp?id=<%=ebee_transactionid%>&source=Paypal&GROUPID=<%=eventid%>">
	    <input type="hidden" name="cancel_return" value="<%=serveraddress%>/guesttasks/regticket.jsp?GROUPID=<%=eventid%>">

   <%}%>
   <!-- From below custom variable we can send any information to eventbee to paypal. But Character limit is 256-->
   <%--<input type="hidden" name="custom" value="<%=ebee_transactionid%>">--%>
       
</form>