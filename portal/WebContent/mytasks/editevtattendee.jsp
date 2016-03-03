<%request.setAttribute("tasktitle","Attendee List");
request.setAttribute("tasksubtitle","All");
  request.setAttribute("mtype","My Console");
  request.setAttribute("stype","Events");

  
  %>


<%@ include file="/templates/taskpagetop.jsp" %>


<%

	taskpage="/sms/editevtattendee.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	