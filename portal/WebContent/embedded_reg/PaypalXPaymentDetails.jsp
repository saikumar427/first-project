<%@page import="com.eventbee.general.DateUtil"%>
<%@ page import="java.util.HashMap,com.eventbee.creditcard.PaymentTypes,com.eventbee.general.DBManager,com.eventbee.general.DbUtil,com.eventbee.general.StatusObj"%>
<%@ page import="com.paypal.svcs.services.*"%>
<%!
public class PaypalXPaymentDetails{
public  String getPaymentMode(String eid){
String paymentmode=null;
try{
String query="select paymentoption from paypalx_events where eventid=CAST(? AS INTEGER)";
String query1="select paymentoption from manager_paypalx_settings where mgr_id=(select mgr_id from eventinfo where eventid=CAST(? AS INTEGER))";
StatusObj sb=null;
DBManager db=new DBManager();
String paymentoption=null;
sb=db.executeSelectQuery(query,new String []{eid});
if(sb.getStatus())
{
paymentoption=db.getValue(0,"paymentoption","");
}
else
{
sb=db.executeSelectQuery(query1,new String []{eid});

if(sb.getStatus()){

paymentoption=db.getValue(0,"paymentoption","");
}
}
if(paymentoption==null){

 /*Stringcurrency=DbUtil.getVal("select currency_code from event_currency where eventid=?",new String[]{eid});
if(currency==null)
currency="USD";
if("USD".equals(currency))
paymentmode="paypalx";
else
paymentmode="";*/
paymentmode="paypalx";
}
else{
if("Chained".equalsIgnoreCase(paymentoption)||"simple".equalsIgnoreCase(paymentoption))
paymentmode="paypalx";
else
paymentmode="";
}
}
catch(Exception e){
}

return paymentmode;
}
public HashMap getPaypalxFeedetails(String eventid){
String eventLevelDetailsQuery="select * from paypalx_events where eventid=CAST(? AS INTEGER)";
String ManagerLevelDetailsQuery="select * from manager_paypalx_settings where mgr_id=(select mgr_id from eventinfo where eventid=CAST(? AS INTEGER))";
DBManager db=new DBManager();
HashMap hm=new HashMap();
StatusObj sb=db.executeSelectQuery(eventLevelDetailsQuery,new String[]{eventid});
if(sb.getStatus()){
hm.put("paymentoption",db.getValue(0,"paymentoption",""));
hm.put("servicefee",db.getValue(0,"servicefee",""));
}
else{
sb=db.executeSelectQuery(ManagerLevelDetailsQuery,new String[]{eventid});
if(sb.getStatus()){
hm.put("paymentoption",db.getValue(0,"paymentoption",""));
hm.put("servicefee",db.getValue(0,"servicefee",""));

}else{

hm.put("paymentoption","Chained");
hm.put("servicefee","1.00");
}
}
return hm;
}

HashMap fillpaypalxData(String eventid,String serveraddress,String transactionid){
HashMap payMap=new HashMap();
try{
HashMap attribmap=PaymentTypes.getPaymentTypeInfo(eventid,"Event","paypal");
String currencycode=DbUtil.getVal("select currency_code from event_currency where eventid=?", new String []{eventid});
if(currencycode==null||"".equals(currencycode))
currencycode="USD";
String paypal_form_url=EbeeConstantsF.get("paypalx.form.url","https://www.paypal.com/webscr");
String paypal_notify_url=EbeeConstantsF.get("paypalx.new.reg.notify.url","http://www.eventbee.com/embedded_reg/paypalxnotification.jsp");
String paypalmerchantid=GenUtil.getHMvalue(attribmap,"attrib_1","0");
String paypallang=GenUtil.getHMvalue(attribmap,"attrib_3","US");
String paypalfeepayer=GenUtil.getHMvalue(attribmap,"attrib_4","PRIMARYRECEIVER");
String paypal_payment_option=GenUtil.getHMvalue(attribmap,"attrib_2","parallel");
payMap.put("currencycode",currencycode);
payMap.put("paypal_form_url",paypal_form_url);
payMap.put("paypal_notify_url",paypal_notify_url);
payMap.put("paypalmerchantid",paypalmerchantid);
payMap.put("paypallang",paypallang);
}//End of try
catch (Exception e){
	
}
return payMap;

}

void updateApiErrorDetailsToDb(String eid,String tid,Exception e){
try{
String str="";
 PPFaultMessage obj = (PPFaultMessage) e;
 List<com.paypal.svcs.types.common.ErrorData> list=obj.getFaultInfo().getError();
  for(com.paypal.svcs.types.common.ErrorData err:list){    
   str=str+err.getErrorId();
   str=str+","+err.getDomain();    
  str=str+","+err.getSeverity(); 
  str=str+","+err.getMessage(); 
   }
 DbUtil.executeUpdateQuery("insert into paypalx_api_problems(eventid,created_at,errordesc,tid) values(CAST(? AS INTEGER),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?)",new String[]{eid,DateUtil.getCurrDBFormatDate(),str,tid});
}
catch(Exception e1){
System.out.println("Exception Occured while processing"+e.getMessage() );
}
}


void updateServicefee(String servicefee,String tid){
DbUtil.executeUpdateQuery("update event_reg_details_temp set collected_servicefee=CAST(? AS NUMERIC) where tid=?",new String[]{servicefee,tid});
}


}

%>