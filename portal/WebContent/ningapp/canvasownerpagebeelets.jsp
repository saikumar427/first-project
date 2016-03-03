<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*" %>


<%
String viewpurpose=(String)session.getAttribute("purpose");

if("view_event".equals(viewpurpose)){
session.removeAttribute("purpose");
response.sendRedirect("/ningapp/ticketing/canvas_viewer.jsp");
return;
}
%>



<link rel="stylesheet" type="text/css" href="/home/index.css" />
<jsp:include page="/ningapp/taskheader.jsp"/> 


<%
String oid=(String)session.getAttribute("ning_oid");
//session.setAttribute("EventListed","Yes");
String vid=request.getParameter("vid");
if(vid!=null)
session.setAttribute("ningvid",vid);
HashMap ningusermap=(HashMap)session.getAttribute(oid+"_ningsession");
session.setAttribute(oid+"_ningsession",null);


if(ningusermap!=null&&ningusermap.size()>0){
String purpose=(String)ningusermap.get("purpose");
String eventid=(String)ningusermap.get("eventid");
String eventname=(String)ningusermap.get("eventname");
if("manage".equals(purpose))
response.sendRedirect("/ningapp/ticketing/eventmanage.jsp?GROUPID="+eventid+"&eventname="+eventname);
else if("addtickets".equals(purpose))
response.sendRedirect("/ningapp/ticketing/addtickets.jsp?GROUPID="+eventid+"&eventname="+eventname);
else if("addevent".equals(purpose))
response.sendRedirect("/ningapp/ticketing/addevent.jsp?isnew=yes");
else if("status".equals(purpose))
response.sendRedirect("/ningapp/ticketing/myListedEventsDetails.jsp?platform=ning&status="+eventid);

else
response.sendRedirect("/ningapp/ticketing/editPoweredBy.jsp?GROUPID="+eventid+"&eventname="+eventname);
}


else{%>

<table width='100%' cellpadding="0"  cellspacing="0">
<tr><td valign='top' width='65%'><table width='100%'>
<tr><td >
<jsp:include page='/ningapp/ticketing/listedevents.jsp' >
<jsp:param  name='Showmanage'  value='yes' />
</jsp:include>
</td></tr>
<tr><td >
<jsp:include page='/myevents/groupevents.jsp' >
<jsp:param name="platform" value="ning" />
</jsp:include>
</td></tr>
</table></td><td width='1%'></td>
<td width='34%' valign='top'><table>
<tr><td width='100%' style="border: 1px solid #ddddff; padding:5px;" valign='top'>
<jsp:include page="/customconfig/logic/CustomContentBeelet.jsp">
<jsp:param name="portletid" value="NING_APP_CANVAS_OWNER" />
<jsp:param name="forgroup" value="13579" />

</jsp:include>


</td></tr></table></td>
</tr>
</table>

<%}%>


<% if("listedSuccefully".equals((String)session.getAttribute("listStatus"))) { %>


<%}%>