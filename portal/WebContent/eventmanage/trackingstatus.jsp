<%@ page import="com.eventbee.general.*"%>
<% 
String trackcode=request.getParameter("trackcode");
String eventid=request.getParameter("eventid");
String status=request.getParameter("status");
DbUtil.executeUpdateQuery("update trackURLs set status=? where eventid=? and trackingcode =?",new String [] {status,eventid,trackcode});

%>
