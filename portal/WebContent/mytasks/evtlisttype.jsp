<%
String link="<a href='/mytasks/addevent.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Event Details</a>";
request.setAttribute("tasktitle","Add Event > "+link+" > Listing Options");
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
	
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/createevent/listtype.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	