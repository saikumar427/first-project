<%@ page import="com.eventbee.general.*"%>

<%
String groupid=request.getParameter("GROUPID");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String evtlink="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+evtname+"</a>";
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("tasktitle","  Event Manage > "+evtlink);
%>


<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventbeeticket/update.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	