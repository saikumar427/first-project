<%@ page import="com.eventbee.general.DbUtil,com.eventregister.RegistrationProcessDB,com.eventregister.RegistrationConfirmationEmail,org.json.JSONObject,com.eventregister.RegistrationDBHelper,com.eventregister.RegistrationTiketingManager,java.util.HashMap"%>
<%
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");
String ntscode=request.getParameter("ntscode");
String fbuserid=request.getParameter("fbuserid");
boolean resultflag=false;
RegistrationDBHelper regdbhelper=new RegistrationDBHelper();
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
JSONObject obj=new JSONObject();
HashMap ntsdata=new HashMap();
ntsdata.put("ntscode",ntscode);
JSONObject creditdetails=regdbhelper.getCreditDetails(ntsdata);
HashMap regDetails=regTktMgr.getRegTotalAmounts(tid);
creditdetails.put("totalamount",(String)regDetails.get("grandtotamount"));
String currencyconverter="1";
currencyconverter=regdbhelper.getcurrencyconversion(eid);
creditdetails.put("currencyconverter",currencyconverter);
String availablecredits="0.00";
String totalamtcredits=(String)regDetails.get("grandtotamount");
try{
	availablecredits=Double.toString(Double.parseDouble((String)creditdetails.get("availablecredits")) - Double.parseDouble((String)creditdetails.get("usedcredits")) - Double.parseDouble((String)creditdetails.get("reservedcredits")));
	totalamtcredits=Double.toString(Double.parseDouble(totalamtcredits)/Double.parseDouble((String)creditdetails.get("currencyconverter")));
}catch(Exception e){}
if(Double.parseDouble(availablecredits)<Double.parseDouble(totalamtcredits)){
obj.put("status","Fail");
obj.put("paymenttype","ebeecredits");
obj.put("fbuserid",fbuserid);
out.println(obj.toString());
return;
}

DbUtil.executeUpdateQuery("update event_reg_details_temp set selectedpaytype=?,buyer_ntscode=?,status='Completed' where tid=? and eventid=?",new String[]{"ebeecredits",ntscode,tid,eid});

RegistrationProcessDB rgdb=new RegistrationProcessDB();
RegistrationConfirmationEmail regconfirm=new RegistrationConfirmationEmail();
int result=rgdb.InsertRegistrationDb(tid,eid);
int emailcount=regconfirm.sendRegistrationEmail(tid,eid);

if(result==1&&emailcount==1)
resultflag=true;
if(resultflag)
obj.put("status","Success");
else
obj.put("status","Fail");
out.println(obj.toString());
%>