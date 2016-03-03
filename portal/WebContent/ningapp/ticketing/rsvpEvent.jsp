<%@ page import="com.eventbee.general.DbUtil" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Events");
String evtid=request.getParameter("GROUPID");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
String link="<a href='/ningapp/ticketing/eventmanage.jsp?evtname="+evtname+"&GROUPID="+evtid+"'>"+evtname+"</a>";

request.setAttribute("tasktitle","Event Manage > "+link+" > RSVP ");

%>

<jsp:include page='/ningapp/taskheader.jsp' />

<jsp:include page='/editevent/rsvpEvent.jsp' />


