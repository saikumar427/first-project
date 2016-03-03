
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.oppertunities.OpperInfo,com.eventbee.general.EventbeeConnection" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%

HashMap hm=(HashMap)session.getAttribute("groupinfo");

String redirmes= LinkUtil.getRedirectPage( hm);

session.setAttribute("cinfo",null);
session.setAttribute("COUPON_HASH",new HashMap());
((Map)session.getAttribute("errorMap")).clear();
String operation=((operation=(String)session.getAttribute("operation"))==null)?"":operation;
String message= ((message=(String)session.getAttribute("message"))==null)?"Done":message;
message=EbeeConstantsF.get(message,message);
String tit= (String)session.getAttribute("title");
if(tit==null){
tit= "Coupon";
}
%>
<%
request.setAttribute("tasktitle","Coupon");
request.setAttribute("tasksubtitle",operation);
request.setAttribute("tabtype","events");
%>

<table align="center" width="100%">
<tr><td align="center" class="inform"><%= message%> </td></tr>
<tr><td align="center" class="inform"> <a href='/mytasks/eventmanage.jsp;jsessionid=<%=session.getId()%>?GROUPID=<%=request.getParameter("GROUPID")%>&UNITID=13579'>Back To Event Manage</a> </td></tr>
</table>
