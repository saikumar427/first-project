<%
if("PUBLICPAGES".equals(request.getParameter("PS")))
request.setAttribute("mtype","My Public Pages");
else if("EVENTDET".equals(request.getParameter("PS"))){
	request.setAttribute("mtype","My Console");
	request.setAttribute("stype","Events");
}else{
	request.setAttribute("mtype","My Console");
	request.setAttribute("stype","Community");
}
request.setAttribute("tasktitle"," Look and Feel ");
%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/configurelnf/submit.jsp";
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>
	