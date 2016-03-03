<%@ page import="com.eventbee.general.* "%>
<%
String evtname=request.getParameter("evtname");
if(evtname!=null)
evtname=java.net.URLEncoder.encode(evtname);
%>
<body>
<table align='center'>             
<tr><td align="center"><%=EbeeConstantsF.get("Agent.status.update.done.message","Status Updated Successfully")%></td></tr>
<tr><td align="center"><a href="/portal/mytasks/eventmanage.jsp?evtname=<%=evtname%>&GROUPID=<%=request.getParameter("GROUPID")%>&UNITID=13579">Back to Event Manage </a></td></tr>
</table>
</body>
