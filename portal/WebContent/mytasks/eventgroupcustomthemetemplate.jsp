<%@ page import="com.eventbee.general.*" %>


<%

String event_groupid=request.getParameter("event_groupid");
String GROUPID=request.getParameter("event_groupid");
String group_title=DbUtil.getVal("select group_title from user_groupevents where event_groupid=?",new String[]{event_groupid});
	if(group_title==null)
	group_title=" ";
	String link="<a href='/mytasks/eventgroups.jsp?group_title="+group_title+"&event_groupid="+event_groupid+"&GROUPID="+event_groupid+"'>"+group_title+"</a>";
	
String templink="<a href='/mytasks/eventgroupcustomthemetemplate.jsp?type=event&group_title="+group_title+"&event_groupid="+event_groupid+"&GROUPID="+event_groupid+"'>Theme Templates</a>";

	String act=request.getParameter("act");
	
	if("editcss".equals(act))
	act="CSS";
	else if("editdata".equals(act))
	act="HTML";
	else act="";
	if(!"".equals(act)){
	request.setAttribute("tasktitle","Event Group Manage > "+link+ " > Theme Templates > "+act);
	}
	else
	request.setAttribute("tasktitle","Event Group Manage > "+link+ " > Theme Templates");
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/customevents/groupcustomthemetemplate.jsp";
	%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		