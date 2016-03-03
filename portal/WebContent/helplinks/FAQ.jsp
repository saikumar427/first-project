<%
response.setStatus(301);
response.setHeader( "Location", "/main/faq" );
response.setHeader( "Connection", "close" );
%>