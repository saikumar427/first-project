<%
response.setStatus(301);
response.setHeader("Location", "/main/membership-management");
response.setHeader("Connection", "close");
%>