<%
if(("event".equals(request.getParameter("type"))||("attendeepage".equals(request.getParameter("type"))))){
	request.setAttribute("mtype","My Console");
	request.setAttribute("tasktitle","Event Manage > "+request.getParameter("evtname") );	
}
else
	request.setAttribute("mtype","My Public Pages");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/customevents/custommytheme.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	
