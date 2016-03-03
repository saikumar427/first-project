<%@ page import="java.util.HashMap,com.eventregister.RegistrationTiketingManager,org.json.JSONObject"%>

<%
String fbuserid=request.getParameter("fbuserid");
String eventid=request.getParameter("eid");
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
HashMap hm=new HashMap();
HashMap ntsdetails=new HashMap();
hm.put("fbuserid",fbuserid);
hm.put("eventid",eventid);
hm.put("ntsenable","Y");
hm.put("fname",request.getParameter("fname"));
hm.put("lname",request.getParameter("lname"));
hm.put("email",request.getParameter("email"));
hm.put("network",request.getParameter("network"));
String ntscode="",display_ntscode="";
try{
		ntsdetails=regtktmgr.getPartnerNTSCode(hm);
		ntscode=(String)ntsdetails.get("nts_code");
	display_ntscode=(String)ntsdetails.get("display_ntscode");
	}
	catch(Exception e){
		System.out.println("exception in nts code: "+e.getMessage());
	}
	JSONObject jobj=new JSONObject();
	jobj.put("ntscode",ntscode);
	jobj.put("display_ntscode",display_ntscode);
	out.println(jobj);
%>