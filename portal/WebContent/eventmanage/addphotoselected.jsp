<%
String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
response.sendRedirect(appname+"/mytasks/uploadphotos.jsp?type=Photos&isnew=yes");
%>