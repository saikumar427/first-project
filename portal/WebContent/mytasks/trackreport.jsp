<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>


<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
String trackcode=request.getParameter("trackcode");

String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=CAST(? as integer)",new String[]{groupid});
if(eventname==null)
eventname=" ";
String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
request.setAttribute("tasktitle","Event Manage > "+link+" > "+trackcode+" - Tracking URL Report");
request.setAttribute("mtype","My Console");
	

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/ntspartner/trackingreports.jsp";
%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	