<%@ include file="/stylesheets/toplnf.jsp" %>
<%
if("13578".equals(request.getParameter("UNITID")))
alignment="center";
//if("13579".equals(request.getParameter("UNITID"))){
if(AuthUtil.getAuthData(pageContext)== null)
alignment="center";
else
alignment="left";
//}
%>
<table  valign="top" align="<%=alignment%>" border="0" cellPadding="0" cellSpacing="0"  height="450" class="portalback">
<%@ include file="/stylesheets/IncludePortalPage.jsp" %>
</table>
<%@ include file="/stylesheets/bottomlnf.jsp" %>
