<%@ page import="com.eventbee.general.*" %>
<%
String trackcode=request.getParameter("trackcode");
request.setAttribute("tasktitle"," Global Tracking Settings > "+trackcode+" - Tracking URL ");
%>
<%@ include file="/templates/taskpagetop.jsp" %>
<%	
	taskpage="/acctleveltracking/managetrackingurls.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		      		
	
