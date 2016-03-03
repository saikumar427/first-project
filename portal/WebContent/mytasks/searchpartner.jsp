<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.event.EventDB" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%@ include file="/main/eventmgmtauth.jsp" %>

<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
if(!EventMgmtAuth.authenticateManageRequest(groupid, pageContext,"SEARCH_PARTNER")){	
%>
<jsp:forward page="/guesttasks/errormessage.jsp" />
<%
}

String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String evtlink="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+evtname+"</a>";

request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");

if("Approved".equals(request.getParameter("filter"))){
request.setAttribute("tasktitle"," Event Manage > "+evtlink+" > Approved Partners");
}
else if("Pending".equals(request.getParameter("filter"))){
request.setAttribute("tasktitle"," Event Manage > "+evtlink+" > Pending Partners");
}
else if("Suspended".equals(request.getParameter("filter")))
{
request.setAttribute("tasktitle"," Event Manage > "+evtlink+" > Suspended Partners");
}
else{
request.setAttribute("tasktitle"," Event Manage > "+evtlink+" > Search Partner");
}
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventbeeticket/searchpartner.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	