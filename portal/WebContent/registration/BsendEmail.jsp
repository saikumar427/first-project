<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.boxoffice.classes.BSendEmailThread"%>
<%@page import="com.eventregister.BRegistrationConfirmationEmail"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%
	//Author: Venkat Reddy
	//Version: 0.1
	//File: submitProfileInfo.jsp 
	//Created: 1/05/2014 
	//Modified: 1/05/2014 by venkat reddy*/
%>
<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	
	
<%
		String tid = request.getParameter("transaction_id");
		String eid = request.getParameter("event_id");
		String email = request.getParameter("email");
		JSONObject responseJSON=new JSONObject();
		if(tid==null||"".equals(tid)&&email==null||"".equals(email)||eid==null&&"".equals(eid)){
			responseJSON.put("status", "fail");
			responseJSON.put("reason", "required parameters missing");
			out.println(responseJSON);
			return;	
		}



		HashMap<String,String> paramMap=new HashMap<String,String>();
		paramMap.put("tid",tid);
		paramMap.put("eid",eid);
		paramMap.put("bcc", "");
		paramMap.put("mailto", email);
		paramMap.put("powertype", "Ticketing");

		(new Thread(new BSendEmailThread(paramMap))).start();
		responseJSON.put("status", "success");		
		out.println(responseJSON);
		%>

