<%@ page import="com.eventbee.hub.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>

<%
	
	
%>
<%
String groupid=request.getParameter("GROUPID");
String unitid="13579";
String message=request.getParameter("message");
if(!"Member approved".equals(message)){
	
	message=EbeeConstantsF.get("hub."+request.getParameter("message"),"Your request to join Community is sent to Moderator");

%>
<table width='100%' >
	<tr><td align='center'><%= message%></td></tr>
	<tr><td align='center'><a href='/hub/clubview.jsp?GROUPID=<%=groupid%>'>Back to Community Page</a></td></tr>
	
</table>
<%}
else
{%>
<table width='100%' >
	<tr><td align='center'><%= message%></td></tr>
	<tr><td align='center'><a href='/mytasks/clubmanage.jsp?GROUPID=<%=groupid%>'>Back to Community Manage Page</a></td></tr>
	
</table>
<%}%>