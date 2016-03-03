<%@ page import="com.eventbee.general.*" %>

<%

String eventid=request.getParameter("GROUPID");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{eventid});
		if(eventname==null)		eventname=" ";
		String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+eventid+"'>"+eventname+"</a>";
		request.setAttribute("tasktitle","Event Manage > "+link+" > Network Advertising");

request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
//request.setAttribute("tasktitle","Event Manage > Network Advertising");
//request.setAttribute("tasksubtitle","");



%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/networkadvertising/advertisingtaskpage.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	
