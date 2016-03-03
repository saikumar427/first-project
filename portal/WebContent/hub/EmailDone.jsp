<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.general.*"%>
<jsp:include page="/auth/checkpermission.jsp" />

<%
	String ntype=(String)request.getAttribute("ntype");
	if(ntype==null)ntype="Add Member";
	String cnt=(String)request.getAttribute("count");
	if(cnt==null)
	cnt=request.getParameter("count");
	if(cnt==null)
	cnt="0";
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	request.setAttribute("subtabtype","Communities");
%>


<table align='center' width='100%' class="taskblock" cellpadding='0' cellspacing='0'>
<tr><td class='inform' align='center'>Email sent to <%=cnt%> member(s)</td></tr>
<tr><td class='inform' align='center'>
<a href='<%=PageUtil.appendLinkWithGroup(   appname+"/mytasks/clubmanage.jsp?GROUPID="+request.getParameter("GROUPID")+"&type=Community", (HashMap)request.getAttribute("REQMAP")     )  %>'>Back to Manage</a> </td>
</tr> 
</table>

