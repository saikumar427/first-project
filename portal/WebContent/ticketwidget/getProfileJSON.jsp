<%@page import="com.eventregister.CProfilePageDisplay"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventregister.CRegistrationTiketingManager"%>
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
	//Modified: 24/05/2016 by omshankar*/
%>
<%@page trimDirectiveWhitespaces="true"%>
	
	<%@ page language="java" contentType="application/json; charset=utf-8"
	pageEncoding="utf-8"%>
	
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

CProfilePageDisplay profile = new CProfilePageDisplay();
responseJSON=profile.getProfilesJson(tid,eid);

responseJSON.put("status","success");

String configval=DbUtil.getVal("select value from config a,eventinfo b where a.config_id= b.config_id and b.eventid=CAST(? AS BIGINT) and a.name=?",new String[]{eid, "timeout"});

if(configval==null)configval="15";  
int configvalint=Integer.parseInt(configval);
if(configvalint!=15)
	configvalint+=1;

int totalDiff=0;
int totalSecDiff=60;
//select to_char(now(),'MI:SS')
String timeQuery="select to_char(now()- locked_time,'MI:SS') as  Difference from event_reg_locked_tickets where eventid=? and tid=? order by locked_time desc  limit 1";
String temp=DbUtil.getVal(timeQuery, new String[]{eid,tid});
String timeminarr[] = new String[3];
String timediffence="";
String secdiffence="";
try{
timeminarr= temp.split(":");
timediffence=timeminarr[0];
secdiffence=timeminarr[1];
}catch(Exception e){
	timediffence = "15";
	secdiffence ="00";
}

if(secdiffence==null || "".equals(secdiffence))
	secdiffence="00";
if(timediffence==null || "".equals(timediffence))
   timediffence="0";

try{
	int timediffininteger = Integer.parseInt(timediffence);
	int intsecdiffrence = Integer.parseInt(secdiffence);
	if(timediffininteger<=0)
		timediffininteger=0;
	totalDiff = configvalint - timediffininteger;
	totalSecDiff = totalSecDiff - intsecdiffrence ;
	if(intsecdiffrence>0 || totalSecDiff>=60)totalDiff=totalDiff-1;
	if(totalDiff<=0)totalDiff=0;
	if(intsecdiffrence<=0 || intsecdiffrence>=60) intsecdiffrence=0;
	
	
}catch(Exception e){
	totalDiff = configvalint;
}

responseJSON.put("timediffrence",totalDiff+"");
responseJSON.put("secdiffrence",totalSecDiff+"");
//String promotionVal = DbUtil.getVal("select 'y' from promotion_mail_list where eid=cast(? as bigint) and attrib1=?", new String[]{eid,tid});
String promotionVal = DbUtil.getVal("select value from config where config_id = (select config_id from eventinfo where eventid=CAST(? AS BIGINT)) and name=?", new String[]{eid,"show.ebee.promotions"});
try{
	if("".equals(promotionVal)||promotionVal==null||"No".equalsIgnoreCase(promotionVal))
		promotionVal="false";
	else
		promotionVal="true";
}catch(Exception e){
	promotionVal="false";
	System.out.println("Exception at getProfileJSON"+e.getMessage());
}
responseJSON.put("enablepromotion",promotionVal);

out.println(responseJSON.toString(2));
CRegistrationTiketingManager regtktmgr=new CRegistrationTiketingManager();
regtktmgr.setEventRegTempAction(eid,tid,"profile page");

%>



