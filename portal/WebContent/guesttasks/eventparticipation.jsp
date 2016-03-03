<%@ page import="com.eventbee.general.*" %>

<%
String evtid=request.getParameter("eid");
//request.setAttribute("CustomLNF_Type","EventDetails");
//request.setAttribute("CustomLNF_ID",request.getParameter("eid"));
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("eid")});
String listurl="/event?eid="+evtid;
String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";
request.setAttribute("tasktitle","My Network Ticket Selling > "+evtlink+ " > Participate" );
request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%	
	taskpage="/guesttasks/networkparticipation.jsp";
	footerpage="/main/eventfootermain.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		      		
	