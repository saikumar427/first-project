<%@ page import="com.eventbee.general.*"%>
<%@ include file="/main/eventmgmtauth.jsp" %>

<%
String groupid=request.getParameter("GROUPID");
if(!EventMgmtAuth.authenticateManageRequest(groupid, pageContext,"DISABLE_NTS")){	
	%>
	<jsp:forward page="/guesttasks/errormessage.jsp" />
	<%
	}
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String evtlink="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";

request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("tasktitle"," Event Manage > "+evtlink+" > Disable Network Ticket Selling ");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventbeeticket/disableevent.jsp";
	%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		