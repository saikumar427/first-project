<%request.setAttribute("mtype","My Console");
  request.setAttribute("stype","Events");
request.setAttribute("tasktitle","Attendee Profile");
   request.setAttribute("tasksubtitle","Done");
 %>


<%@ include file="/templates/taskpagetop.jsp" %>


<%

	taskpage="/editattendeeprofile/done.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	
