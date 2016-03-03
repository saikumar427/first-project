<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.customconfig.*" %>




<%= PageUtil.startContent("Configure",request.getParameter("border"),request.getParameter("width"),true) %>

<!-- /contentbeelet/logic/ContentBeeletMain.jsp?portletid=GUEST_CLUB_PAGE&GROUPID=14771&UNITID=13579&GROUPTYPE=Club&PS=clubview -->
<table width='100%'>
	<tr>
	<%
		String contentbeeletlink=PageUtil.appendLinkWithGroup("/contentbeelet/logic/ContentBeeletMain.jsp?portletid=GUEST_CLUB_PAGE",(HashMap)session.getAttribute("groupinfo"));
		
	%>
	
	<td class="tablecell" align="left">
		<a HREF='<%=contentbeeletlink %>'>Add/Delete Text/HTML content</a>
	</td>
	</tr>
	
<tr>
	<td class="tablecell" align="left">
	<a HREF='<%=PageUtil.appendLinkWithGroup(request.getContextPath()+"/polls/logic/PollAtLocation.jsp?location=GUEST_CLUB_PAGE&fromhub=yes" ,(HashMap)session.getAttribute("groupinfo") ) %>'>Add/Delete Poll</a>
	</td>
</tr>
	
</table>
<%=PageUtil.endContent() %>

