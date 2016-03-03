<%
String  link=" ";
request.setAttribute("mtype","My Themes");
String title=request.getParameter("title");
String foract=request.getParameter("foract");
   if("edit".equalsIgnoreCase(foract))
        link="<a href='/mytasks/myuserthemes.jsp?themeid="+request.getParameter("themeid")+"&title="+title+"&foract="+foract+"&module="+request.getParameter("module")+"' >Edit Theme</a>";
      else
       link="<a href='/mytasks/myuserthemes.jsp?themeid="+request.getAttribute("themeid")+"&title="+title+"&module="+request.getParameter("module")+"&foract=edit'>Create Theme</a>";
   request.setAttribute("tasktitle",title +" > "+link+ " > Success");
 %>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/usertheme/done.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		
