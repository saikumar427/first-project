<%@page import="com.eventregister.CRegistrationTiketingManager"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONObject"%>
<%
String eventid = request.getParameter("event_id");
String tid = request.getParameter("transaction_id");
String nts_enable = request.getParameter("nts_enable");
String requestNTSData = request.getParameter("ntsDetails");
String referral_ntscode = request.getParameter("referral_ntscode");


	/* {"id":"1642729096052582",
	"email":"omshankar@eventbee.com",
	"first_name":"Om",
	"gender":"male",
	"last_name":"Eventbee",
	"link":"https://www.facebook.com/app_scoped_user_id/1642729096052582/",
	"locale":"en_US",
	"name":"Om Eventbee",
	"timezone":5.5,
	"updated_time":"2016-01-02T04:52:48+0000",
	"verified":false} */
	CRegistrationTiketingManager regTktMgr=new CRegistrationTiketingManager();
	JSONObject ntsObj = new JSONObject(requestNTSData);
	String ntscode="";
	String display_ntscode="";
	HashMap ntsdata=new HashMap();
	HashMap ntsdetails=new HashMap();
	System.out.println("in ntsDetails.jsp");
	if(!"0".equals(ntsObj.get("id"))){
		ntsdata.put("fbuserid",ntsObj.get("id"));
		ntsdata.put("eventid",eventid);
		ntsdata.put("ntsenable",nts_enable);
		ntsdata.put("fname",ntsObj.get("first_name"));
		ntsdata.put("lname",ntsObj.get("last_name"));
		ntsdata.put("email",ntsObj.get("email"));
		ntsdata.put("network","facebook");
		try{
			System.out.println("calling get nts code method: "+ntsObj.get("id"));
			ntsdetails=regTktMgr.getPartnerNTSCode(ntsdata);
			
			ntscode=(String)ntsdetails.get("nts_code");
			System.out.println("obtained nts code: "+ntscode);
			display_ntscode=(String)ntsdetails.get("display_ntscode");
		}
		catch(Exception e){
			System.out.println("exception in nts code: "+e.getMessage());
		}
	}
	ntsdata.put("ntscode",ntscode);
	ntsdata.put("ntsenable",nts_enable);
	ntsdata.put("tid", tid);
	ntsdata.put("referral_ntscode",referral_ntscode);
	regTktMgr.updateDetailsTempNTSDetails(ntsdata);
%>