<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%
	Presentation presentation=new Presentation(pageContext);
	presentation.includeRequiredStyles();

%>
<table  valign="top" align="<%=alignment%>" border="0" cellPadding="0" cellSpacing="0" class="portalback">
<%@ include file="/stylesheets/IncludePortalPage.jsp" %>
</table>
