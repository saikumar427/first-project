<%


request.setAttribute("tasktitle","Community");
request.setAttribute("tasksubtitle","Done");

request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");


%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/club/done.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		