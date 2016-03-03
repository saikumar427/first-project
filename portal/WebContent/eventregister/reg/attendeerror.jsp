<%@ page import="com.eventbee.general.*"%>

<%
Object obj=(Object)session.getAttribute("regerrors");
out.println("<table>");
out.print(GenUtil.displayErrMsgs("<tr><td class='error'>",obj,"</td></tr>" ));
out.println("</table>");
%>