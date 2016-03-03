
<%
String operation=request.getParameter("operation");
request.setAttribute("mtype","My Email Marketing");
if("Delete".equals(operation)){
request.setAttribute("tasktitle","Mailing List(s) > Delete");
//request.setAttribute("tasksubtitle","Delete");
}else if("Create".equals(operation)){
request.setAttribute("tasktitle","Mailing List > Create");
//request.setAttribute("tasksubtitle","Create");
}
else{
request.setAttribute("tasktitle","Mailing List > "+request.getParameter("listname"));
request.setAttribute("tasksubtitle","Edit Done");
}



%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/lists/Done.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	