<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.useraccount.*" %>
<%
String userid="",unitid="";
String createdat="",updatedat="",evtlevel="",listatebee="No";
String visitcount="0",listtype="";
HashMap hm=(HashMap) session.getAttribute("groupinfo");
if(hm!=null){
	HashMap evtstatus=HitDB.getEventStatistics((String)hm.get("groupid"));
	if(evtstatus!=null && !(evtstatus.isEmpty())){
		createdat=(String)evtstatus.get("created_at");
		updatedat=(String)evtstatus.get("updated_at");
		listtype="PBL".equals((String)evtstatus.get("listtype"))?"Yes":"No";
		visitcount=(String)evtstatus.get("count");
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("Event Statistics",request.getParameter("border"),request.getParameter("width"),true) );
			
	
	

%>
	<table class1="portaltable" align="center" cellpadding="0" cellspacing="0" width="100%" border='0'>
	<tr>
		<td class="inputlabel" style="border:0"  align="left" width='50%'>Created On</td>
		<td class="inputvalue"  align="center"><%=createdat%></td>
	</tr>
	<tr >
		<td class="inputlabel" style="border:0"  align="left">Status</td>
		<td class="inputvalue"  align="center"><%=evtstatus.get("status") %></td>					
	</tr>
	<tr >
		<td class="inputlabel" style="border:0"  align="left">Page Visits</td>
		<td class="inputvalue"  align="center"><%=visitcount%></td>					
	</tr>
	<tr >
		<td class="inputlabel" style="border:0"  align="left">Public Event</td>
		<td class="inputvalue"  align="center"><%=listtype%></td>					
	</tr>
	<%
	HashMap config_val=(HashMap) evtstatus.get("configvalues");
	if(config_val!=null && !(config_val.isEmpty())){
		if(((String)config_val.get("event.poweredbyEB"))!=null){
	%>
	<tr >
		<td class="inputlabel" style="border:0" align="left">Power with Online Registration</td>
		<td class="inputvalue"  align="center"><%=EventbeeStrings.makeFirstCharCaps((String)config_val.get("event.poweredbyEB"))%></td>					
	</tr>
	<%
		}
	}
	%>
	
	</table>
<%
	if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent()); 
	}	
}
 %>   
