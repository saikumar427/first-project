
<%@page import="com.eventregister.BRegistrationTiketingManager"%>
<%@page import="com.eventregister.BProfilePageDisplay"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventregister.BDiscountManager"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%
	//Author: Venkat Reddy
	//Version: 0.1
	//File: getProfileJSON.jsp 
	//Created: 23/05/2014 
	//Modified: 26/05/2014 by venkat reddy*/
%>
<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	<%@ include file="cors.jsp" %>

<%
String tid=request.getParameter("transaction_id");
String eid=request.getParameter("event_id");
String apiKey=request.getParameter("api_key");
JSONObject responseJSON=null;

if (eid == null||"".equals(eid) || tid == null||"".equals(tid)||apiKey == null||"".equals(apiKey)) {
	responseJSON=new JSONObject();
	responseJSON.put("status", "fail");
	responseJSON.put("reason", "required parameters missing");
	out.println(responseJSON.toString(2));
	return;

}
BProfilePageDisplay profile=new BProfilePageDisplay();
responseJSON=profile.getProfilesJson(tid,eid);
responseJSON.put("status","success");
out.println(responseJSON.toString(2));
BRegistrationTiketingManager regtktmgr=new BRegistrationTiketingManager();
regtktmgr.setEventRegTempAction(eid,tid,"profile page");

%>



