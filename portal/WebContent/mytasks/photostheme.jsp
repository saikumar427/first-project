<%
request.setAttribute("mtype","My Public Pages");
request.setAttribute("tasktitle","My Photos Page > Change Theme");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

        <%

	taskpage="/photogallery/gettheme.jsp";
	%>
	      		
 <%@ include file="/templates/taskpagebottom.jsp" %>
	
	      		
	      		
	     