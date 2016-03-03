<%@ page import="com.eventbee.general.*" %>


<%
String groupid=request.getParameter("GROUPID");
String trackingcode=request.getParameter("trackingcode");

String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null)
eventname=" ";
String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
request.setAttribute("tasktitle","Event Manage > "+link+" > "+trackingcode+" - Tracking URL Report");
request.setAttribute("mtype","My Console");
	

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/ntspartner/trackingreports.jsp";
%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	