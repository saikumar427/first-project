<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
	String eventid=request.getParameter("groupid");
	String password=request.getParameter("password");
	String trackcode=request.getParameter("trackcode");
	DbUtil.executeUpdateQuery("update trackURLs set password=? where eventid=? and trackingcode =?",new String [] {password,eventid,trackcode});
%>
