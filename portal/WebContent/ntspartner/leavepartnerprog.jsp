<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />

<%
request.setAttribute("subtabtype","Eventbee Partner Network");
String partnerid=request.getParameter("partnerid");
String platform = request.getParameter("platform");	
	String URLBase="/eventpartner/leavepartnerprogram";
	if("ning".equals(platform)){		
		URLBase="/ningapp/leavepartnerprogram";
	}

%>
<form name='frm' method="post" action="<%=URLBase%>" >
<input type='hidden' name='partnerid' value='<%=partnerid%>'/>

<table align="center" class='block'>
<tr><td><%=EbeeConstantsF.get("leave.partner.program","Do you really want to leave Event Partner Network? Leaving Eventbee Partner Network no longer allows you to earn commissions from Eventbee Network Ticket Selling, and Network Event Listing. Click on Submit to leave the partner network.")%></td></tr>
<tr><td height="10"></td></tr>
<tr><td><center><input type="submit" name="submit" value="Submit">
<input type="button"  value="Cancel" onClick="javascript:window.history.back()"/></center></td></tr>
</table>
</form>



