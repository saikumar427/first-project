<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.* "%>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>

<%
String agentid=request.getParameter("agentid");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"changestatus1.jsp","null","agentid value is  :"+agentid,null);
String GROUPID=request.getParameter("GROUPID");
String status=F2FEventDB.getVal(F2FEventDB.status_Query,agentid);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"changestatus1.jsp","null","status value is  :"+status,null);
request.setAttribute("subtabtype","My Events");
String evtname=request.getParameter("evtname");
if(evtname!=null)
evtname=java.net.URLEncoder.encode(evtname);



%>


<body>
<form name="changestatus" action="/eventbeeticket/statusUpdate"  method="post">
<table align="center" class="block" cellspacing="0">
<input type='hidden' name='evtname' value='<%=evtname%>'/>
<tr><td valign="top" class="inputlabel" width="30%" height="30">Current Status</td>
<%
if ("Pending".equals(status))
status="Approval Waiting";
if ("suspend".equalsIgnoreCase(status))
status="Suspended";
%>
<td class="inputvalue"> <%=status%></td>
</tr>
<input type="hidden" name="agentid" value="<%=request.getParameter("agentid")%>" />
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>" />
<tr>
<td valign="top" class="inputlabel">New Status</td>
<td class="inputvalue">
<select name="status1" >
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"changestatus1.jsp","null","status value is  :"+status,null);
if ("Approval Waiting".equals(status)){
%>
  <option value ="Active">Approve</option>
  <option value ="Decline">Decline</option>
  <%}else{
  if ("Active".equals(status)){
  %>
  <option value ="Suspend">Suspend</option>
  <%}else{%>
  <option value ="Active">Approve</option>
  <option value ="Decline">Decline</option>
  <option value ="Pending">Approval Waiting </option>
  <option value ="Suspend">Suspend</option>
  <%}}%>
</select>
</td>
</tr>
<tr><td colspan="2" height="10"></td></tr>
<tr>
	<td colspan="2" align="center">
	<input type="button" name="back" value="Back" onclick="javascript:window.history.back()" />  
	<input type="submit" name="Submit" value="Update"  />
	</td>
</tr>
</table>
</form>
</body>
