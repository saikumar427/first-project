<%
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%
	taskpage="/maillistbeelet/emailsubscribedone.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		