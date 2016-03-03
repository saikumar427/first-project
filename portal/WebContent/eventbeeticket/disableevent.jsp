<%
 String platform = request.getParameter("platform");
String url="/eventbeeticket/updateConfig";
     if("ning".equals(platform)){ 	
 	url="/ningapp/updateConfig";
     }
String evtname=request.getParameter("evtname");

if(evtname!=null)
evtname=java.net.URLEncoder.encode(evtname);
request.setAttribute("subtabtype","My Pages");
String groupid=request.getParameter("GROUPID");
String unitid=request.getParameter("UNITID");
%>


<form action="<%=url%>">
<input type='hidden' name='evtname' value='<%=evtname%>'/>
<input type='hidden' name='GROUPID' value='<%=groupid%>'/>
<input type='hidden' name='UNITID' value='<%=unitid%>'/>
<input type='hidden' name='platform' value='<%=platform%>'/>

<table align="center" class='block'>          
<tr><td>  Do you really want to disable Eventbee Network Ticket Selling feature on your event?
 Disabling Eventbee Network Ticket Selling feature no longer allows any new
 participant to join this program. To disable individual Eventbee Network Ticket
 Selling participant (if any active), click on Status link of the
 individual participant and change the status to disabled. </td></tr>
<tr><td height="10"></td></tr>
<tr><td><center><input type="submit" name="submit" value="Submit">
<input type="button"  value="Cancel" onClick="javascript:window.history.back()"/></center></td></tr>
</table>
</form>
