<%

request.setAttribute("mtype","My Public Pages");
if("event".equals(request.getParameter("purpose")))

request.setAttribute("tasktitle","My Events  Page");
else 
request.setAttribute("tasktitle","My Network  Page");
request.setAttribute("tasksubtitle","Photo Added");


%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/photoupload/done.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	