<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.DBManager"  %>
<%@page import="com.eventbee.general.StatusObj"  %>
<%! 
	public static String checkStatus(String eid,String tid, String token){
		StatusObj statobj;
		String query="select status from buyer_att_page_visits where eventid=? and token=? and tid=?";
		String status=DbUtil.getVal(query, new String[]{eid,token,tid});
		if("Success".equalsIgnoreCase(status))
			return "success";
		else
			return "error";
	}
%>
<%
JSONObject json=new JSONObject();
try{
	String eventid = request.getParameter("eid");
	String tid = request.getParameter("tid");
	String token = request.getParameter("token");
	String statusMsg = checkStatus(eventid,tid,token);
	if("success".equals(statusMsg))
		json.put("status","success");
	else
		json.put("status","error");
	
}catch(Exception e){
	System.out.println("Exception at buyerpagechecktidTokenid.jsp "+e);
	json.put("status","error");
}
out.println(json.toString());
%>
