<%@ page import="com.eventbee.general.*" %>


<%
String platform = request.getParameter("platform");
 if(platform==null) platform="";
String URLBase="mytasks";
if("ning".equals(platform)){
        URLBase="ningapp/ticketing";
}

String evtname=request.getParameter("evtname");
if(evtname!=null)
evtname=java.net.URLEncoder.encode(evtname);
request.setAttribute("subtabtype","My Pages");
String isedit=request.getParameter("isedit");
String donemessage=("add".equals(isedit) )?EbeeConstantsF.get("Eventbee.Agent.add.message","Eventbee Network Ticket Selling Enabled Successfully"):EbeeConstantsF.get("Eventbee.Agent.update.message","Settings updated successfully");
%>


<body>
<form name="done" >
<table align="center">
<tr><td height="35"></td></tr>
<tr><td class="inform" align="center" ><%=donemessage %></td></tr>
<tr></tr>
<tr>
<td><center><a href="/<%=URLBase%>/eventmanage.jsp?GROUPID=<%=request.getParameter("GROUPID")%>&UNITID=13579&platform=<%=platform%>&evtname=<%=evtname%>">Back to Event Manage</a></center>
</td>
<tr><td height="35"></td></tr>
</table>
</form>
</body>
</html>
