<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
	String eventid=request.getParameter("groupid");
	String image=request.getParameter("image");
	String trackcode=request.getParameter("trackcode");
	DbUtil.executeUpdateQuery("update trackURLs set photo=? where eventid=? and trackingcode =?",new String [] {image,eventid,trackcode});
%>