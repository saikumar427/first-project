<%@ page import="com.eventbee.general.*"%>
<%@ include file="/main/eventmgmtauth.jsp" %>

<%
String groupid=request.getParameter("GROUPID");
if(!EventMgmtAuth.authenticateManageRequest(groupid, pageContext, "EMAIL_CUSTOMIZE")){	
	%>
	<jsp:forward page="/guesttasks/errormessage.jsp" />
	<%
	}
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null)
eventname=" ";
String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
request.setAttribute("tasktitle","Event Manage > "+link+" > Customize Email Template");
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

taskpage="/eventmanage/emailtemplate.jsp";
%>

<%@ include file="/templates/taskpagebottom.jsp" %>


