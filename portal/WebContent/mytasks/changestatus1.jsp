<%@ page import="com.eventbee.general.*"%>

<%
String groupid=request.getParameter("GROUPID");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null) eventname=" ";
String evtlink="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";

request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("tasktitle","  Event Manage > "+evtlink+" > Participant Status");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventbeeticket/changestatus1.jsp";
	%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		