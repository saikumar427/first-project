<%@ page import="java.util.HashMap, com.eventregister.RegistrationTiketingManager, org.json.JSONObject, com.eventbee.general.formatting.CurrencyFormat, com.eventregister.RegistrationDBHelper"%>
<%
String eid=request.getParameter("eid");
String ntsenable=request.getParameter("ntsenable");
String fbuserid=request.getParameter("fbuserid");
String tid=request.getParameter("tid");
String ntscode="",display_ntscode="";
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
HashMap ntsdetails=new HashMap();
HashMap ntsdata=new HashMap();
ntsdata.put("fbuserid",fbuserid);
ntsdata.put("eventid",eid);
ntsdata.put("ntsenable",ntsenable);
ntsdata.put("tid",tid);
ntsdata.put("fname",request.getParameter("fname"));
ntsdata.put("lname",request.getParameter("lname"));
ntsdata.put("email",request.getParameter("email"));
try{
	ntsdetails=regTktMgr.getPartnerNTSCode(ntsdata);
	ntscode=(String)ntsdetails.get("nts_code");
	display_ntscode=(String)ntsdetails.get("display_ntscode");
}
catch(Exception e){
	System.out.println("exception in nts code: "+e.getMessage());
}
ntsdata.put("ntscode",ntscode);
RegistrationDBHelper regdbhelper=new RegistrationDBHelper();

JSONObject creditdetails=regdbhelper.getCreditDetails(ntsdata);
HashMap regDetails=regTktMgr.getRegTotalAmounts(tid);
creditdetails.put("totalamount",(String)regDetails.get("grandtotamount"));
String currencyconverter="1";
currencyconverter=regdbhelper.getcurrencyconversion(eid);
creditdetails.put("currencyconverter",currencyconverter);
creditdetails.put("ntscode",ntscode);
creditdetails.put("display_ntscode",display_ntscode);
String availablecredits="0.00";
String totalamtcredits=(String)regDetails.get("grandtotamount");
try{
	availablecredits=Double.toString(Double.parseDouble((String)creditdetails.get("availablecredits")) - Double.parseDouble((String)creditdetails.get("usedcredits")) - Double.parseDouble((String)creditdetails.get("reservedcredits")));
	totalamtcredits=Double.toString(Double.parseDouble(totalamtcredits)/Double.parseDouble((String)creditdetails.get("currencyconverter")));
}catch(Exception e){}
availablecredits=CurrencyFormat.getCurrencyFormat("", availablecredits, true);
totalamtcredits=CurrencyFormat.getCurrencyFormat("", totalamtcredits, true);
creditdetails.put("availablecredits",availablecredits);
creditdetails.put("totalamtcredits",totalamtcredits);
out.println(creditdetails.toString());

%>