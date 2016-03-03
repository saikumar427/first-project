<%
response.setStatus(301);
response.setHeader( "Location", "/main/contact" );
response.setHeader( "Connection", "close" );
%>