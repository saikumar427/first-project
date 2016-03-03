<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Earnings");
%>
<jsp:include page='/ningapp/mytabsmenu.jsp' />
<table width='600' cellpadding="0"  cellspacing="0">
<tr><td><table>
<tr><td width='50%' style="border: 1px solid #ddddff; padding:5px;" valign='top'>
<jsp:include page="/ningapp/CustomContentBeelet.jsp">
<jsp:param name="portletid" value="NING_APP_PARTNER" />
<jsp:param name="forgroup" value="13579" />
</jsp:include></td></tr>
<tr><td>
<%@ include file="/ningapp/networkticketselling.jsp"%>
</td></tr>
<tr><td width='50%'>
<jsp:include page="/ningapp/networkeventlisting.jsp" />
</td></tr>
</table></td>
<td width='50%' valign='top'><table>
<tr><td width='50%'>
<jsp:include page="/ningapp/myearnings.jsp" />
</td></tr></table></td></tr>
</table>
