<%
response.setStatus(301);
response.setHeader( "Location", "/portal/guesttasks/invalidhelppage.jsp" );
response.setHeader( "Connection", "close" );
%>