<%@ page import="java.util.HashMap,com.eventbee.general.*" %>

<%
  String CLASS_NAME="donersvp.jsp";
  String status=request.getParameter("status");
  String eventid=request.getParameter("GROUPID");
  String message="";
  
  if("-1".equals(status))
  	message=EbeeConstantsF.get("taskpage.rsvp.error","Your request cannot process at this time");
  else
	message="Thank you, your RSVP information is sent to the Event Manager";


				  
%>
<%
String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
request.setAttribute("tabtype",request.getParameter("evttype"));
%>
<table align="center" width="100%" border="0">
 <tr><td></td></tr>
 <tr><td></td></tr>
 <tr><td></td></tr>	
 <tr><td align="center"><%=message%></td></tr>
 <tr><td height="15"></td></tr>
<tr>
	<td align="center">
		<a href="<%=ShortUrlPattern.get(username)%>/event?eventid=<%=eventid%>">Event page</a>
	</td>
</tr>
<tr><td height="15"></td></tr>
<tr height="230"><td></td></tr>
</table>
