<%@ page import="org.json.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.creditcard.PaymentTypes,com.eventbee.general.formatting.*"%>
<%@ include file="regxmlgenerator.jsp" %>
<%!

HashMap getAmounts(String tid){
String totalsQuery="select nettotal,tax from event_reg_details where tid=?";
DBManager db=new DBManager();
HashMap hm=new HashMap();
StatusObj sb=db.executeSelectQuery(totalsQuery,new String[]{tid});
if(sb.getStatus()){
hm.put("netamount",db.getValue(0,"nettotal",""));
hm.put("tax",db.getValue(0,"tax",""));

}
return hm;
}
%>
<%
String eventid=request.getParameter("eid");
String TransactionId=request.getParameter("tid");
String paypal_merchantid=null;
HashMap amountsMap=null;
String total=null;
String tax=null;
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{eventid});
String itemname=eventname+" Event Registration Charges";
DbUtil.executeUpdateQuery("update event_reg_details set selectedpaytype=? where tid=?",new String[]{"paypal",TransactionId});
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
String xmldata=getXmlContent(eventid,TransactionId);
StatusObj statobjn=null;
String ebee_tran_id=DbUtil.getVal("select ebee_tran_id from paypal_payment_data where ebee_tran_id=?", new String []{TransactionId});
if(ebee_tran_id==null)
	statobjn= DbUtil.executeUpdateQuery("insert into paypal_payment_data (ebee_tran_id,ebee_xml_data,time,refid,ref_type) values(?,?,now(),?,?)", new String []{TransactionId,xmldata,eventid,"EVENT"});
else
	statobjn= DbUtil.executeUpdateQuery("update paypal_payment_data set ebee_xml_data=?,time=now() where ebee_tran_id=?", new String []{xmldata,TransactionId});
amountsMap=getAmounts(TransactionId);
total=(String)amountsMap.get("netamount");
tax=(String)amountsMap.get("tax");
String paypalamount=CurrencyFormat.getCurrencyFormat("",total+"",true);
String paypaltax=CurrencyFormat.getCurrencyFormat("",tax+"",true);



JSONObject object=new JSONObject();
object.put("amount",paypalamount);
object.put("tax",paypaltax);
object.put("currency_code",currencycode);
object.put("notify_url",paypal_notify_url);
object.put("item_name",itemname);
object.put("business",paypal_merchantid);
object.put("action",paypal_form_url);
out.println(object.toString());
%>

