<%
request.setAttribute("mtype","My Public Pages");
request.setAttribute("tasktitle","My Photos Page");
request.setAttribute("tasksubtitle","Settings updated");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/photogallery/settings1.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

