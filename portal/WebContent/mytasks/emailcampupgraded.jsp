
<%
request.setAttribute("mtype","My Email Marketing");

	String message=request.getParameter("message"); 
	
	if("listquota".equals(message)){
	
		request.setAttribute("message","Mail Quota upgraded successfully");
	} 
	if("campquota".equals(message)){
	
		request.setAttribute("message","Campaign Credits upgraded successfully");
	} 
	
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/emailcamp/upgraded.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	