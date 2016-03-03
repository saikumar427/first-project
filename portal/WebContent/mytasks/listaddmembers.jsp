
<%
request.setAttribute("mtype","My Email Marketing");
request.setAttribute("stype","Add Members");

if("Upload".equals(request.getParameter("ntype")))
request.setAttribute("ltype","File Upload");
else request.setAttribute("ltype","Manual");
request.setAttribute("showtabs","show");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/listmgmt/addmembers.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	