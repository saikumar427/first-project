<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.socialnetworking.Twitter"%>
<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"%>
<%
	String eventid=request.getParameter("event_id");
    String auth_token=request.getParameter("auth_token");
    String beeid=request.getParameter("bee_id");
    System.out.println("eventid::"+eventid);
    System.out.println("auth_token::"+auth_token);
    System.out.println("bee_id in setTwitAuth ::"+beeid);
    if(beeid==null || "null".equalsIgnoreCase(beeid))beeid="";
    if("".equals(beeid)){
	DbUtil.executeUpdateQuery("delete from twitter_auth where created_at<(current_timestamp-interval '2 days')",null);
	DbUtil.executeUpdateQuery("delete from twitter_auth where auth_token=? and eventid=?",new String[]{auth_token,eventid});
	DbUtil.executeUpdateQuery("insert into twitter_auth(auth_token,eventid,created_at) values(?,?,now())",new String[]{auth_token,eventid});
    }
 
%>