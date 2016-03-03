<%@ page import="com.eventbee.general.*" %>
<%
	String groupid=request.getParameter("groupid");
	String alreadyexists=DbUtil.getVal("select 'yes' from event_custom_urls where eventid=?",new String[]{groupid});
	if("yes".equals(alreadyexists)){
	out.print("Success");
	}else
	out.print("No Custom URL");
%>

	