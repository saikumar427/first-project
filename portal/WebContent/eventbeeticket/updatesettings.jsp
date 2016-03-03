<%@ page import="java.util.*,java.io.*,java.io.IOException"%>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.StatusObj,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.WriteSelectHTML" %>
<%@ page import="java.util.*,java.io.IOException,com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>

<jsp:include page="/auth/authenticate.jsp" /> 
<%
request.setAttribute("subtabtype","My Pages");
String groupid=request.getParameter("GROUPID");
String unitid=request.getParameter("UNITID");
%>


<body>
<form  action="disablef2fsponsor.jsp" method="post">
<input type="hidden" name="GROUPID" value='<%=groupid%>'>
<input type="hidden" name="UNITID" value='<%=unitid%>'>
<table align="center" class="block">
<tr>                
<td colspan="2" align="center"><%=EbeeConstantsF.get("participant.created","Created Participant Page")%></td></tr>
<tr></tr><tr></tr><tr><td align="center">
<a href="/portal/mytasks/partnernetwork.jsp?type=Events">Back to Network Ticket Selling</a>
</td>
</tr>
</table>
</form>
</body>


