<%@ page import="com.eventbee.general.*" %>
<%
String evtid=request.getParameter("groupid");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("groupid")});
String listurl="/mytasks/networkticketsellingpage.jsp";
String evtlink="<a href='"+listurl+"'>My Network Ticket Selling</a>";
String groupid=request.getParameter("groupid");
request.setAttribute("tasktitle",""+evtlink+" > "+evtname+" > Get Approval");
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("layout", "EE");
request.setAttribute("backurl","/mytasks/networkticketsellingpage.jsp");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/ntspartner/getntsapproval.jsp";
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>