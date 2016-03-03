<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
	String userid=request.getParameter("userid");
	String password=request.getParameter("password");
	String trackcode=request.getParameter("trackcode");
	DbUtil.executeUpdateQuery("update accountlevel_track_partners set password=? where userid=CAST(? as BIGINT) and lower(trackname) =?",new String [] {password,userid,trackcode.toLowerCase()});
%>
