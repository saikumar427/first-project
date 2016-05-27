<%@page import="com.eventregister.CRegistrationTiketingManager"%>
<%@page import="com.eventbee.general.DateUtil"%>
<%@page import="com.eventregister.CSubmitProfileJSON"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.eventbee.general.EncodeNum"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.EventbeeLogger"%>
<%@page import="com.eventregister.BProfileActionDB"%>
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
	//Modified: 27/05/2016 by om shankar*/
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
	String enablepromotion = request.getParameter("enablepromotion");
  	if(enablepromotion==null)enablepromotion="";
  	
  	CRegistrationTiketingManager regTktMgr=new CRegistrationTiketingManager();
  	
	if(userAgent==null){
		userAgent="Box Office";
	}
	
	String customerIp=request.getHeader("x-forwarded-for");
	if(customerIp==null || "".equals(customerIp)) 
		customerIp=request.getRemoteAddr();
	userAgent=request.getHeader("User-Agent")+"["+customerIp+"]";
	
	JSONObject finalResponseString=new JSONObject();
	String buyerFname="";
	String buyerLname = "";
	String buyerEmail="";
	String buyerPhone = "";
	try{
		CSubmitProfileJSON submitProfileAns=new CSubmitProfileJSON();
		JSONObject buyerJSON = new JSONObject(buyerInfo);
		finalResponseString=submitProfileAns.doSubmitProfileAction(tid ,eid,edate, seatingEnabled, buyerInfo,attendeeInfo, userAgent);
		if("yes".equals(enablepromotion)){
				try{
				if(buyerJSON.has("fname")){
					if(buyerJSON.getJSONObject("fname").getString("value")!=null)
						buyerFname=buyerJSON.getJSONObject("fname").getString("value");
				}
				if(buyerJSON.has("lname")){
					if(buyerJSON.getJSONObject("lname").getString("value")!=null)
						buyerLname=buyerJSON.getJSONObject("lname").getString("value");
				}
					if(buyerJSON.has("email")){
						if(buyerJSON.getJSONObject("email").getString("value")!=null)
							buyerEmail=buyerJSON.getJSONObject("email").getString("value");
					}
				}
				catch(Exception e){
					System.out.println("in exception case of submitProfileAns");
				}
				//StatusObj sb=DbUtil.executeUpdateQuery("insert into promotion_mail_list(eid,attrib1,fname,lname,email,created_at) values(CAST('"+eid+"' as bigint),'"+tid+"','"+buyerFname+"','"+buyerLname+"','"+buyerEmail+"',now())",null);
				String query="insert into promotion_mail_list(eid,attrib1,fname,lname,email,created_at) values(cast(? as bigint),?,?,?,?,now())";
				StatusObj sb=DbUtil.executeUpdateQuery(query,new String[]{eid,tid,buyerFname,buyerLname,buyerEmail});	
		}
		}catch(Exception e){
		
		}

	out.print(finalResponseString.toString());
%>
