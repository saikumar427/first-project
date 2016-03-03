<%@page import="com.eventbee.general.OTPMailThread"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.DateUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.GenerateOTP" %>
<%@page import="com.eventbee.util.CoreConnector"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%!
public void sendEmail(String eid,String email,String name, String otp){
	
	HashMap<String,String> inputparams=new HashMap<String,String>();
	inputparams.put("email",email);
	inputparams.put("eid",eid);
	inputparams.put("name",name);
	inputparams.put("otp",otp);
	(new Thread(new OTPMailThread(inputparams))).start();
}
%>

<%  
JSONObject json=new JSONObject();
try{
	String profilekey = request.getParameter("profilekey");
	String email = request.getParameter("email");
	String eid = request.getParameter("eid");
	String tid = request.getParameter("tid");
	String name = request.getParameter("name");
	String type = request.getParameter("type");
	String genOTP="";
	genOTP = GenerateOTP.genPassword(); 
	String insertQuery="insert into buyer_att_page_visits(eventid,tid,profilekey,access_mode,email,page_type,status,otp,access_time,expires_at) "+ 
					" values(CAST(? AS BIGINT),?,?,'OTP',?,'buyer','Pending',CAST(? AS BIGINT),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS')+ interval '10 minutes')";
	if("resend".equals(type)){
		String updateOTPQuery="update buyer_att_page_visits set status='Cancelled' where profilekey=? and status='Pending'";
		DbUtil.executeUpdateQuery(updateOTPQuery, new String[] {profilekey});
		DbUtil.executeUpdateQuery(insertQuery, new String[] {eid,tid,profilekey,email,genOTP,DateUtil.getCurrDBFormatDate(),DateUtil.getCurrDBFormatDate()});
	}else{
		String updateOTPQuery="update buyer_att_page_visits set otp=?,expires_at=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS')+ interval '10 minutes' where profilekey=? and status='Pending'";
		DbUtil.executeUpdateQuery(updateOTPQuery, new String[] {genOTP,DateUtil.getCurrDBFormatDate(),profilekey});
	}
	sendEmail(eid,email,name,genOTP);
	json.put("status","success");
}catch(Exception e){
	  System.out.println("Exception occured in sending supportmail:"+e.getMessage());
	  json.put("status","fail");
}
out.println(json.toString());
%>