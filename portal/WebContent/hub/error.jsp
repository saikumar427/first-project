<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>


<%
String groupid=request.getParameter("GROUPID");
String unitid=request.getParameter("UNITID");
String message=EbeeConstantsF.get("club.nomembership.msg","Membership enrollment is not yet enabled.");

%>
<table width='100%' >
	<tr><td align='center'><%= message%></td></tr>
	<tr><td align='center'><a href="/portal/hub/clubview.jsp?GROUPID=<%=groupid%>">Back to Hub page</a></td></tr>
	
</table>
