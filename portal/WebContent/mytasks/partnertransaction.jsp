<%@ page import="com.eventbee.general.*" %>


<%

String groupid=request.getParameter("groupid");
String agentid=request.getParameter("agentid");
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
	if(eventname==null)
	eventname=" ";
	String link="<a href='/mytasks/partner_reports.jsp?GROUPID="+groupid+"&agentid="+agentid+"'>"+eventname+"</a>";

	request.setAttribute("tasktitle","Network Ticket Selling > "+link+" > Transaction Report");
	
	request.setAttribute("mtype","Network Ticket Selling");
	request.setAttribute("stype","My Earnings");
       
       
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/ntspartner/transaction.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	
