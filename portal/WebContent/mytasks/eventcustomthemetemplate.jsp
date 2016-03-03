<%@ page import="com.eventbee.general.*" %>
<%@ include file="/main/eventmgmtauth.jsp" %>


<%

String groupid=request.getParameter("GROUPID");
String mgrtokenid=request.getParameter("mgrtokenid");
if(!EventMgmtAuth.authenticateManageRequest(groupid, pageContext,"THEME_TEMPLATE")){	
%>
<jsp:forward page="/guesttasks/errormessage.jsp" />
<%
}

	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
	if(eventname==null)
	eventname=" ";
	String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"&mgrtokenid="+mgrtokenid+"'>"+eventname+"</a>";
	
String templink="<a href='/mytasks/eventcustomthemetemplate.jsp?type=event&GROUPID="+groupid+"&mgrtokenid="+mgrtokenid+"'>Theme Templates</a>";

	String act=request.getParameter("act");
	
	if("editcss".equals(act))
	act="CSS";
	else if("editdata".equals(act))
	act="HTML";
	else act="";
	if(!"".equals(act)){
	request.setAttribute("tasktitle","Event Manage > "+link+ " > "+templink+" > "+act);
	}
	else
	request.setAttribute("tasktitle","Event Manage > "+link+ " > "+templink);
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/customevents/customthemetemplate.jsp";
	%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		