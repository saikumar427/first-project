<%@ page import="com.eventbee.general.*" %>

<%
String groupid=request.getParameter("GROUPID");
String status=request.getParameter("status");
System.out.println("status----"+status);
String eventstatus="";
if("ACTIVE".equals(status)){
eventstatus="Active";
}else if("CLOSED".equals(status)){
eventstatus="Closed";
}else{
eventstatus="Active | Closed | All";
}

String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null)
eventname=" ";
String Myevents="<a href='/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid='+session.getId()>My Events</a>";

request.setAttribute("tasktitle", Myevents+" > "+eventstatus);

%>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<jsp:include page="/ningapp/taskheader.jsp"/> 
<jsp:include page='/myevents/myListedEventsDetails.jsp' />


