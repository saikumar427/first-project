<%
response.setStatus(301);
response.setHeader( "Location", "/main/email-marketing" );
response.setHeader( "Connection", "close" );
%>