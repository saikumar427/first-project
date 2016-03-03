
<%
String operation=request.getParameter("operation");
request.setAttribute("mtype","My Email Marketing");
if("Add".equals(operation)){
request.setAttribute("tasktitle","Campaign");
request.setAttribute("tasksubtitle","Add");
}else if("Create".equals(operation)){
request.setAttribute("tasktitle","Campaign > Add");
}else if("Edit".equals(operation)){
request.setAttribute("tasktitle","Campaign > Update");
}else if("Delete".equals(operation)){
request.setAttribute("tasktitle","Email Campaign");
request.setAttribute("tasksubtitle","Delete");
}
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/emailcamp/Done.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	