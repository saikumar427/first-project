<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>

<% 
String themename="";
String module="eventspage";
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
userid=authData.getUserID();
}
%>

<%
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("My Events Page Theme",request.getParameter("border"),request.getParameter("width"),true) );
String eventspagetheme=getPublicPageThemeName(userid,module);
if(eventspagetheme==null)
eventspagetheme=EbeeConstantsF.get("myeventspage.default.theme","basic");


%>
<table cellpadding="0" cellspacing="0"  width="100%">
<tr class="evenbase"><td>Current Theme: <%=eventspagetheme%></td></tr>
<tr class="evenbase"><td ><a href="/portal/myevents/myeventstheme.jsp?type=eventspage">Apply a different theme</a></td></tr>
<tr class="evenbase"><td ><a href='/portal/mythemes/mythemetemplate.jsp?type=eventspage'>Edit current theme template</a></td></tr>
</table>
<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>



