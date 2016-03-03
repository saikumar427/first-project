
<%@ page import="com.eventbee.general.*" %>


<%
if(("event".equals(request.getParameter("type"))||("attendeepage".equals(request.getParameter("type"))))){
	


String groupid=request.getParameter("GROUPID");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null)
eventname=" ";
String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
request.setAttribute("tasktitle","Event Manage > "+link ); 
request.setAttribute("tasktitle","Event Manage >"+link);
	request.setAttribute("mtype","My Console");
	}
else
request.setAttribute("mtype","My Public Pages");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/customevents/savethemes.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	
