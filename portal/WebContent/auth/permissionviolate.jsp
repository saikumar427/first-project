<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>

<% 
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	request.setAttribute("tasktitle","Unauthorized");
	if("clubmanage".equals(request.getParameter("authtype")))
		request.setAttribute("tabtype","club");
	else
		request.setAttribute("tabtype","community");
%>

<table   width='100%'  cellspacing="0">

<tr>
<td colspan='2'>
	<table border="0" width="100%" align="center">
		<tr>
			<td align="center"><%=(request.getAttribute("violationmsg")==null)?"You are not allowed to perform this operation":(String)request.getAttribute("violationmsg")%></td>
		</tr>
		<tr>
			<td align="center"><a href='<%=appname%>/club/myhome.jsp?UNITID=<%=request.getParameter("UNITID")%>'>Back to home</a></td>
		</tr>
	</table>

</td>
</tr>
</table>
