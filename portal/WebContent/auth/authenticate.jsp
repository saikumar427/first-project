<%@ page import="java.io.*, java.util.*, com.eventbee.looknfeel.LooknFeel" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,org.eventbee.sitemap.util.LinksGenerator" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>

<%
//if(session.getAttribute("authData")==null){
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"Authenticate.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
if(AuthUtil.getAuthData(pageContext)==null){

%>

<%--<jsp:forward page='/auth/authenticateMessage.jsp' />--%>
<jsp:forward page='/auth/listauth.jsp' />

<%
}
%>
