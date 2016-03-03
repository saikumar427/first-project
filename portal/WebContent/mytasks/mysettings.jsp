<%


request.setAttribute("mtype","My Settings");
request.setAttribute("stype","Account");

/*
Comented By Rajesh on 3 Mar 2007 AS requirement is not to have task bar in this page
*/
//request.setAttribute("tasktitle","My Profile");
//request.setAttribute("tasksubtitle","Update");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/editprofiles/memberprofile.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	