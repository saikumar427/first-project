<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Network Event Listing");
%>
<jsp:include page='mytabsmenu.jsp' >
<jsp:param  name='homelink'  value='ntsapp' />
</jsp:include>
<table width='600' cellpadding="0"  cellspacing="0">
<tr><td><table>
<tr><td width='50%' style="border: 1px solid #ddddff; padding:5px;" valign='top'>
<jsp:include page="/customconfig/logic/CustomContentBeelet.jsp">
<jsp:param name="portletid" value="NING_NEL" />
<jsp:param name="forgroup" value="13579" />
</jsp:include></td></tr>
<tr><td>
<jsp:include page="/ntspartner/nelpricingbeelet.jsp">
<jsp:param name="platform" value="ning" />
</jsp:include>
</td></tr></table></td>
<td width='50%' valign='top'><table>
<tr><td width='50%'>
<jsp:include page="/ntspartner/nelparticipationbeelet.jsp">
<jsp:param name="platform" value="ning" />
</jsp:include>
</td></tr></table></td></tr>
</table>
