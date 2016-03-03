<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%
	request.setAttribute("tasktitle","Message");
	String groupid=request.getParameter("GROUPID");
	HashMap hubinfohash=(HashMap)request.getAttribute("HUBINFOHASH");
	String clubname=GenUtil.getHMvalue(hubinfohash,"clubname","");
	
%>
<table width='100%'>
<tr><td >This feature is for <%=clubname %>  Moderator only</td></tr>

<% if(com.eventbee.general.AuthUtil.getAuthData(pageContext) ==null){ %>
<tr><td ><%=EbeeConstantsF.get("Loginto.visit.managepage","Login to visit manage page")%></td></tr>

<%-- <tr><td >Login to visit manage page.</td></tr> --%>
<%}%>
</table>
