<%@ page import="com.eventbee.general.*" %>
<%@ include file="/main/eventmgmtauth.jsp" %>

<%
String groupid=request.getParameter("GROUPID");
if(!EventMgmtAuth.authenticateManageRequest(groupid, pageContext, "MANUAL_REGISTRATION")){	
	%>
	<jsp:forward page="/guesttasks/errormessage.jsp" />
	<%
	}
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null) eventname=" ";
String evtlink="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
String link="/mytasks/attendeelist_report.jsp?GROUPID="+groupid;
if(request.getParameter("mgrtokenid")!=null){
link+="&mgrtokenid="+request.getParameter("mgrtokenid");
}
String reportlink="<a href='"+link+"'>Attendee List</a>";
request.setAttribute("tasktitle","Event Manage > "+evtlink+" > "+reportlink+" > Add Attendee" );
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%
	taskpage="/bulkregistration/entryform.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		 	