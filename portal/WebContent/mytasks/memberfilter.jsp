<%
	request.setAttribute("mtype","My Console");
	request.setAttribute("stype","Network");
	request.setAttribute("ltype","Search");
	request.setAttribute("tasktitle","Member List");
	request.setAttribute("tasksubtitle","Search");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/search/memberfilter.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	