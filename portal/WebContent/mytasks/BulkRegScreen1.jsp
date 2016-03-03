<%@ page import="com.eventbee.general.*" %>


<%
String groupid=request.getParameter("GROUPID");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null)
eventname=" ";
String evtlink="<a href='/mytasks/eventmanage.jsp?evtname="+java.net.URLEncoder.encode(eventname)+"&GROUPID="+groupid+"'>"+eventname+"</a>";

String link="<a href='/mytasks/attendeelist_report.jsp?evtname="+java.net.URLEncoder.encode(eventname)+"&GROUPID="+groupid+"'>Attendee List</a>";
request.setAttribute("tasktitle","Event Manage > "+evtlink+" > "+link+ " > Add Attendee" );
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/bulkregistration/BulkRegScreen1.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		 	