

<%
String groupid=request.getParameter("GROUPID");
String nvid=request.getParameter("nvid");
session.setAttribute(nvid+"_EventDisplay",groupid);
out.print("<data>Success<data>");
%>