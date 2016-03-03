<%
request.setAttribute("mtype","My Themes");
String title=request.getParameter("title");
request.setAttribute("tasktitle",title +" > Themetemplates");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%
taskpage="/mythemes/mythemetemplate.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		