<%@ page import="com.eventbee.general.DbUtil" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
String groupid=request.getParameter("GROUPID");
String participationtype=request.getParameter("participationtype");
String nts_approvaltype=request.getParameter("nts_approvaltype");
String evtid=request.getParameter("GROUPID");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
String link="<a href='/ningapp/ticketing/eventmanage.jsp?evtname="+evtname+"&GROUPID="+evtid+"'>"+evtname+"</a>";
DbUtil.executeUpdateQuery("update group_agent_settings set participationtype=?, nts_approvaltype=? where groupid=?  ",new String [] {participationtype,nts_approvaltype,groupid});
request.setAttribute("mtype","Events");
String Myevents="<a href='/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+session.getId()+"'>My Events</a>";
request.setAttribute("tasktitle", Myevents+" > Event Manage > "+link+" > Network Ticket Selling Settings");
//request.setAttribute("tasktitle","Event Manage > "+link+" > Network Ticket Selling Settings ");

%>
<jsp:include page='/ningapp/taskheader.jsp' />

<jsp:include page='/eventbeeticket/done.jsp' />
		