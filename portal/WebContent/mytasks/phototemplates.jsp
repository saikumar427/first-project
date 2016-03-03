<%
request.setAttribute("mtype","My Public Pages");
request.setAttribute("tasktitle","Photos Theme Page");
request.setAttribute("tasksubtitle","Theme Templates");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/photogallery/customthemetemplate.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	
