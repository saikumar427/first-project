<%@ page import="com.eventbee.general.*" %>


<%

	String groupid=request.getParameter("GROUPID");
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
	if(eventname==null)
	eventname=" ";
	String link="<a href='/mytasks/networkticketsellingpage.jsp'>My Network Ticket Selling</a>";
	
	if("manager".equals(request.getParameter("filter"))){
	request.setAttribute("mtype","My Console");
	request.setAttribute("stype","Events");

	request.setAttribute("tasktitle","Event Manage > "+eventname+" > Report");
	}else{
	request.setAttribute("mtype","Network Ticket Selling");
	request.setAttribute("stype","My Earnings");

	request.setAttribute("tasktitle",link+" > "+eventname+" > Report");
	}
	//request.setAttribute("mtype","My Console");
	
	

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%
	taskpage="/ntspartner/partner_reports.jsp";
%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

