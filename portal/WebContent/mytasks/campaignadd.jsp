
<%

request.setAttribute("mtype","My Email Marketing");
if("Edit".equals(request.getParameter("operation")))
{
request.setAttribute("tasktitle","My Campaign Design > Edit");

}else{
request.setAttribute("tasktitle","My Campaign Design > Create");
}

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/camp/CampaignAddContent.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	