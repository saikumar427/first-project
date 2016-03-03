<%@ page import="com.eventbee.general.*" %>


<%
String type=request.getParameter("evttype");

if("event".equals(type)){
	String groupid=request.getParameter("groupid");
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
	if(eventname==null)
	eventname=" ";
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
	taskpage="/listreport/registrations_report.jsp";
%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	