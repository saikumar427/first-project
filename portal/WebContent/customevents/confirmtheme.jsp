<%
String evtname="";
evtname=request.getParameter("evtname");
if(evtname!=null)
	evtname=java.net.URLEncoder.encode(request.getParameter("evtname"));

%>

<html>
<body>
<form name="confirmtheme">

<table align="center">
<tr align="center"><td> Theme Saved</td></tr>
<tr></tr>
<tr>
<td><a href="/portal/mytasks/custommytheme.jsp?type=<%=request.getParameter("type")%>&evtname=<%=evtname%>&GROUPID=<%=request.getParameter("GROUPID")%>&themeid=<%=request.getParameter("themeid")%>&evtname=<%=evtname%>"&frompage=<%=request.getParameter("frompage")%>>Back to Templates</a></td>&nbsp;&nbsp;
<td><a href="/mytasks/eventmanage.jsp?GROUPID=<%=request.getParameter("GROUPID")%>&evtname=<%=evtname%>">Back to Event Manage</a>
</td>
</table>
</form>
</body>
</html>
