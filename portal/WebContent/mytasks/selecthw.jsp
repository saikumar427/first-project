<%@ page import="com.eventbee.general.*" %>


<%
String groupid=request.getParameter("groupid");
String evtname=request.getParameter("evtname");

String link="<a href='/mytasks/attendeelist_report.jsp?GROUPID="+groupid+"&evtname="+evtname+"'>Attendee List</a>";
request.setAttribute("tasktitle","Event Manage > "+link+ " > Name Tags" );
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/listreport/selecthw.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	