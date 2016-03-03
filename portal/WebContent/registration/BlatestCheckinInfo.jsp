<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.boxoffice.classes.BMakeEmptyProfileInfo"%>
<%
	// Author: Venkat Reddy
	// Version: 0.1 
	// File: authenticateUser.jsp
	// created: 18/08/2014	
	// modified: 18/08/2014 by venkat reddy
%>
<%@page trimDirectiveWhitespaces="true"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.EventbeeLogger"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>	

<%
	JSONObject responseObject = new JSONObject();
	boolean resultFlag = false;
	String time = request.getParameter("time");
	String api_key = request.getParameter("api_key");
	String eid = request.getParameter("event_id");
	String edate = request.getParameter("event_date");	
	

	if (eid == null || "".equals(eid)|| api_key == null || "".equals(api_key)||time == null || "".equals(time) ){
		responseObject = new JSONObject();
		responseObject.put("status", "fail");
		responseObject.put("reason", "required parameters missing");
		out.println(responseObject.toString(2));
		return;
	}
	if(edate==null)
		edate="";
	else
		edate=edate.trim();
		JSONArray checkin=new JSONArray();
		JSONArray undoCheckin=new JSONArray();
		
	DBManager dbManager=new DBManager();
	System.out.println("time::"+time+"::");
	String query="select tid,ticketid,attendeekey,eventid,checkinstatus,to_char(checkedintime,'YYYY-MM-DD HH24:MI:SS') as time  from event_scan_status where checkedintime >= TIMESTAMP '"+time+"' and eventid=?";
	StatusObj sObj=dbManager.executeSelectQuery(query, new String[]{eid});
	JSONObject eachAtttendee=null;
	System.out.println("entries::"+sObj.getCount());
	for(int i=0;i<sObj.getCount();i++){
		eachAtttendee=new JSONObject();
		eachAtttendee.put("tid", dbManager.getValue(i, "tid", ""));		
		eachAtttendee.put("attendeekey", dbManager.getValue(i, "attendeekey", ""));	
		if("1".equalsIgnoreCase(dbManager.getValue(i, "checkinstatus", "")))
				checkin.put(eachAtttendee);
		else
			undoCheckin.put(eachAtttendee);		
		if(i==sObj.getCount()-1)
			responseObject.put("sync_time",dbManager.getValue(i, "time", "") );
	}
		
	responseObject.put("checkin",checkin);
	responseObject.put("undo_checkin",undoCheckin);
	responseObject.put("status", "success");
	if(!responseObject.has("sync_time"))
		responseObject.put("sync_time","1970-09-01 00:00:00" );
	
	out.println(responseObject.toString(2));
%>

