<%@page import="com.eventregister.BSubmitProfileJSON"%>
<%@page import="com.customquestions.beans.BAttribOption"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.eventbee.general.EncodeNum"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.customquestions.beans.BCustomAttribute"%>
<%@page import="com.customquestions.beans.BCustomAttribSet"%>
<%@page import="com.customquestions.BCustomAttribsDB"%>
<%@page import="com.eventbee.general.EventbeeLogger"%>
<%@page import="com.eventregister.BProfileActionDB"%>
<%@page import="com.eventregister.BRegistrationTiketingManager"%>
<%@page import="com.eventregister.BRegistrationDBHelper"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="java.util.HashMap"%>
<%@ page import="org.json.JSONObject"%>
<%
	//Author: Venkat Reddy
	//Version: 0.1
	//File: submitProfileInfo.jsp 
	//Created: 30/05/2014 
	//Modified: 30/05/2014 by venkat reddy*/
%>
<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	<%@ include file="cors.jsp" %>


<%
	String tid = request.getParameter("transaction_id");
	String eid = request.getParameter("event_id");
	String edate = request.getParameter("event_date");
	String seatingEnabled = request.getParameter("seating_enabled");
	String buyerInfo=request.getParameter("buyer_info");
	String attendeeInfo=request.getParameter("attendee_info");	
	String userAgent=request.getHeader("User-Agent");

	
	if(userAgent==null){
		userAgent="Box Office";
	}
	JSONObject finalResponseString=new JSONObject();
	
	try{
		BSubmitProfileJSON submitProfileAns=new BSubmitProfileJSON();
		finalResponseString=submitProfileAns.doSubmitProfileAction(tid ,eid,edate, seatingEnabled, buyerInfo,attendeeInfo, userAgent);
	}catch(Exception e){
		
	}

	out.print(finalResponseString.toString());
%>
