<%
request.setAttribute("tasktitle","Community");
request.setAttribute("tasksubtitle","Information");


request.setAttribute("mtype","My Pages");
request.setAttribute("stype","Community");

%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/club/clubinfo.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		