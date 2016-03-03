<%
String status=request.getParameter("status");
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("tasktitle","My Registered Events");
request.setAttribute("tasksubtitle",status);

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/myevents/myRegisteredEventsDetails.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	
