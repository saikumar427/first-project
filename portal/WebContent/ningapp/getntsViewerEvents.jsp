<%@ page import="com.eventbee.util.CoreConnector"%>
<%
String ownerstatus=request.getParameter("ownerstatus");

String oid=request.getParameter("oid");

String vid=request.getParameter("vid");

CoreConnector cc1=new CoreConnector("http://www.eventbee.com/ningapp/nts/showActiveEvents");
cc1.setQuery("ownerstatus="+ownerstatus+"&oid="+oid+"&vid="+vid);
cc1.setTimeout(30000);
String st=cc1.MGet();
out.println(st);
%>