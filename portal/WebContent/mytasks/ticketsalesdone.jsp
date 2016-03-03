<%@ page import="com.eventbee.general.*"%>

<%
String groupid=request.getParameter("GROUPID");
String participationtype=request.getParameter("participationtype");
String nts_approvaltype=request.getParameter("nts_approvaltype");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String evtlink="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+evtname+"</a>";
DbUtil.executeUpdateQuery("update group_agent_settings set participationtype=?, nts_approvaltype=? where groupid=?  ",new String [] {participationtype,nts_approvaltype,groupid});
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("tasktitle"," Event Manage > "+evtlink+" > Network Ticket Selling Enabled");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventbeeticket/done.jsp";
	%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		