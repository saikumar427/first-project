<%@ page import="com.eventbee.general.formatting.EventbeeStrings,com.eventbee.event.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent(null,"0",request.getParameter("width"),true) );
%>
	<table class='portalback' align='center' cellpadding='0' cellspacing='0' width='100%'>
	<tr><td align='center'>
	<a href="/portal/auth/listauth.jsp?purpose=listevt&unitid=13579&entryunitid=13579" >
	<img src="/home/images/list_event.gif" border='0'/></a>
	</td></tr>					
	</table>
<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>
