<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>


<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null)
eventname=" ";
String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
request.setAttribute("tasktitle","Event Manage > "+link+" > Tracking URLs - All Reports");
request.setAttribute("mtype","My Console");
%>

<%@ include file="/templates/taskpagetop.jsp" %>
<%
	taskpage="/ntspartner/trackingreportsummary.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
	
