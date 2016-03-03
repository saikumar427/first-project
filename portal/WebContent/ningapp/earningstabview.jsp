<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Earnings");
String oid=request.getParameter("oid");
%>
<jsp:include page='mytabsmenu.jsp' >
<jsp:param  name='homelink'  value='ntsapp' />
<jsp:param name="oid" value="<%=oid%>" />
</jsp:include>
<table width='800' cellpadding="0"  cellspacing="0">
<tr><td valign="top"><table>
<tr><td valign="top" width='50%'>
<jsp:include page="/ntspartner/ntsearningsbeelet.jsp">
<jsp:param name="platform" value="ning" />
<jsp:param name="oid" value="<%=oid%>" />
</jsp:include>
</td></tr></table></td>
<td width='50%' valign='top'><table>
<tr><td width='50%'>
<jsp:include page="/ntspartner/earningsummarybeelet.jsp" >
<jsp:param name="platform" value="ning" />
</jsp:include>
</td></tr></table></td></tr>
</table>
