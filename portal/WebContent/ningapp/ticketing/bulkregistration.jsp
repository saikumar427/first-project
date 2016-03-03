<%@ page import="com.eventbee.general.*" %>
<%
String groupid=request.getParameter("GROUPID");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null) eventname=" ";
String tokenid=request.getParameter("tokenid");
String evtlink="<a href='/ningapp/ticketing/eventmanage.jsp?GROUPID="+groupid+"&tokenid="+tokenid+"'>"+eventname+"</a>";

String link="<a href='/ningapp/ticketing/attendeelist_report.jsp?GROUPID="+groupid+"&tokenid="+tokenid+"'>Attendee List</a>";
request.setAttribute("tasktitle","Event Manage > "+evtlink+" > "+link+ " > Add Attendee" );
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
%>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<jsp:include page="/ningapp/taskheader.jsp"/> 

<jsp:include page="/bulkregistration/entryform.jsp"> 
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>' />
<jsp:param  name='platform'  value='ning' />
<jsp:param  name='tokenid'  value='<%=tokenid%>' />
</jsp:include>

