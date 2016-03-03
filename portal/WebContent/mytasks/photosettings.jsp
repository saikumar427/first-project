<%

request.setAttribute("mtype","My Public Pages");
request.setAttribute("tasktitle","My Photos Page > Settings");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/photogallery/settings.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

