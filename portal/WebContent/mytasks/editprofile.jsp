 <%request.setAttribute("mtype","My Console");
  request.setAttribute("stype","Events");
request.setAttribute("tasktitle","Attendee Profile");
   request.setAttribute("tasksubtitle","Edit");
  
 %>


<%@ include file="/templates/taskpagetop.jsp" %>


<%

	taskpage="/editattendeeprofile/editprofile.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	
