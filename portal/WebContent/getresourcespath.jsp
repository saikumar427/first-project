<%@ page import="com.eventbee.general.EbeeConstantsF"%>
<%
   String resourceaddress="";
	resourceaddress="//"+EbeeConstantsF.get("resourcessslserveraddress","localhost");
	/*  if("https".equalsIgnoreCase(request.getHeader("x-forwarded-Proto")))
     resourceaddress="//"+EbeeConstantsF.get("resourcessslserveraddress","www.eventbee.com");
   else
	  resourceaddress="//"+EbeeConstantsF.get("resourcesserveraddress","images.eventbee.com"); */
%>