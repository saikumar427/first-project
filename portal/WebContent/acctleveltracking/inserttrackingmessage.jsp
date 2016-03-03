<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
	String userid=request.getParameter("userid");
	String message=request.getParameter("message");
	String trackcode=request.getParameter("trackcode");
	DbUtil.executeUpdateQuery("update accountlevel_track_partners set message=? where userid=CAST(? as BIGINT) and lower(trackname) =?",new String [] {message,userid,trackcode.toLowerCase()});
%>
