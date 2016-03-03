<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Network Ticket Selling");
String oid=(String)session.getAttribute("oid");
%>
<jsp:include page='/ningapp/mytabsmenu.jsp' >
<jsp:param name="oid" value="<%=oid%>" />
</jsp:include>

<table width='600' cellpadding="0"  cellspacing="0">
<tr><td><table>
<tr><td>
<jsp:include page="displayownerpage.jsp"/>
</td></tr></table></td>
<td width='50%' valign='top'><table>
<tr><td width='50%'>
<jsp:include page="topNtsevents.jsp" />

</td></tr></table></td></tr>
</table>

