<%@ page import="com.eventbee.general.*" %>
<%@ include file="/main/eventmgmtauth.jsp" %>

<%
	String groupid=request.getParameter("GROUPID");
	if(!EventMgmtAuth.authenticateManageRequest(groupid, pageContext,"EDIT_EVENT_VIEW")){	
	%>
	<jsp:forward page="/guesttasks/errormessage.jsp" />
	<%
	}
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
	if(eventname==null)
	eventname=" ";
	String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
	request.setAttribute("tasktitle","Event Manage > "+link+" > Edit Event");
        request.setAttribute("mtype","My Console");
       request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/createevent/editevent.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	