<%@ page import="com.eventbee.general.*" %>


<%
String groupid=request.getParameter("GROUPID");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null)
eventname=" ";
String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
request.setAttribute("tasktitle","Event Manage > "+link+" > RSVP" );
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/editevent/rsvpEvent.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		