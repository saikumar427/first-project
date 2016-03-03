<%
response.setStatus(301);
response.setHeader( "Location", "/main/user/signup" );
response.setHeader( "Connection", "close" );
%> 