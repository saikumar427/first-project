<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%
String updatethemes="update group_agent set status=? where agentid=?";
String status=request.getParameter("status1");
System.out.println("status is    "+status);
String agentid=request.getParameter("agentid");
System.out.println("agentid is  "+agentid);
request.setAttribute("subtabtype","My Pages");
%>
<%
String groupid=request.getParameter("GROUPID");

StatusObj sobj=DbUtil.executeUpdateQuery(updatethemes,new String [] {status,agentid});
%>
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>" />

<%
response.sendRedirect("/eventbeeticket/update.jsp?UNITID=13579&GROUPID="+groupid);
%>
