<%@ page import="com.eventbee.general.*" %>

<%
String country=request.getParameter("c");

if("I".equalsIgnoreCase(country))
	session.setAttribute("USER_COUNTRY_BY_IP","India");
else if("U".equalsIgnoreCase(country))
	session.setAttribute("USER_COUNTRY_BY_IP","Usa");
else{
   
   session.setAttribute("USER_COUNTRY_BY_IP",null);
   country=GenUtil.GetCountryByIp(request.getRemoteAddr());
}

%>