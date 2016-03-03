<%@ page import="com.eventbee.general.*"%>




<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String name=request.getParameter("name");
System.out.println("serveraddress--"+serveraddress);
session.setAttribute("NAME",name);
response.sendRedirect(serveraddress+"/sessiongetter.jsp");
%>