<%
String partnerid=request.getParameter("partnerid");
request.setAttribute("CustomLNF_Type","Community");
request.setAttribute("CustomLNF_ID",partnerid);
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%
	taskpage="/createevent/networkevtlistdone.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	