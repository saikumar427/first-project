<%
  request.setAttribute("mtype","My Console");
  request.setAttribute("stype","Events");
 //request.setAttribute("tasktitle","member");
  %>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventdetails/pagersvpevents.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	