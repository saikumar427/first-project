<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.event.EventDB" %>
<%@ include file="/main/eventmgmtauth.jsp" %>

<%
String groupid=request.getParameter("GROUPID");
if(!EventMgmtAuth.authenticateManageRequest(groupid, pageContext,"NTS_SETTINGS_VIEW")){	
%>
<jsp:forward page="/guesttasks/errormessage.jsp" />
<%
}
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String evtlink="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+evtname+"</a>";

request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("tasktitle"," Event Manage > "+evtlink+" > Network Ticket Selling Settings");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventbeeticket/settask.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	