<%


request.setAttribute("mtype","My Settings");
request.setAttribute("stype","Profile");
request.setAttribute("tasktitle","My Profile");
request.setAttribute("tasksubtitle","Updated");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/editprofiles/end.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	
