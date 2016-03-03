
<%
request.setAttribute("mtype","My Email Marketing");
request.setAttribute("stype","Members");
request.setAttribute("showtabs","show");

request.setAttribute("linktohighlight",request.getParameter("status"));
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/listmgmt/members.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	