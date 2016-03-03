<%
String subtitle="",title="";
  request.setAttribute("mtype","My Themes");
   title=request.getParameter("title");
  
  String foract=request.getParameter("foract");
  if("edit".equalsIgnoreCase(foract))
  subtitle="Edit Theme";
  else
  subtitle="Create Theme";
  request.setAttribute("tasktitle",title +" > "+subtitle);
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/usertheme/usertheme.jsp";
	%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
		

	
		
