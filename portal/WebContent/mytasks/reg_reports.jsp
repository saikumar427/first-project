<%@ page import="com.eventbee.general.*" %>
<%@ include file="/main/eventmgmtauth.jsp" %>

<%
String type=request.getParameter("evttype");
if("event".equals(type)){
	String groupid=request.getParameter("GROUPID");
	if(!EventMgmtAuth.authenticateManageRequest(groupid, pageContext,"REG_REPORTS")){	
	%>
	<jsp:forward page="/guesttasks/errormessage.jsp" />
	<%
	}

	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
	if(eventname==null)
	eventname="";
	String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";

	request.setAttribute("tasktitle","Event Manage > "+link+" > Registration Report");
	request.setAttribute("mtype","My Console");	
}
else
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>
<%
	taskpage="/listreport/reg_reports.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	