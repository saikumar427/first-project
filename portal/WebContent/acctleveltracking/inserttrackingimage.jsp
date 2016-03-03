<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
	String userid=request.getParameter("userid");
	String image=request.getParameter("image");
	String trackcode=request.getParameter("trackcode");
	DbUtil.executeUpdateQuery("update accountlevel_track_partners set photourl=? where userid=to_number(?,'999999999999999999') and lower(trackname) =?",new String [] {image,userid,trackcode.toLowerCase()});
%>