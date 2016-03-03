<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
	String eventid=request.getParameter("groupid");
	String message=request.getParameter("message");
	String trackcode=request.getParameter("trackcode");
	DbUtil.executeUpdateQuery("update trackURLs set message=? where eventid=? and trackingcode =?",new String [] {message,eventid,trackcode});
%>
