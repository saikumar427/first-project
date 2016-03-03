<%@ page import="java.util.*,java.io.*,javax.servlet.http.*"%>
<%
String type=request.getParameter("type");
if("Community".equals(type))
response.sendRedirect("/communityreport");
else
response.sendRedirect("/pdfreport");
%>
