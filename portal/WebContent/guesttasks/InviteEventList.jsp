<%
  request.setAttribute("mtype","My Console");
  request.setAttribute("stype","Events");
 request.setAttribute("tasktitle","Invite Event Manager");
  %>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventdetails/InviteEventList.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	