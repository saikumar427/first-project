<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
request.setAttribute("subtabtype","My Themes");
%>

<%
String msg=request.getParameter("msg");
String message="Done successfully";
if(msg!=null&&"edit".equals(msg))
message="Theme updated successfully";

if(msg!=null&&"add".equals(msg))
message="Theme created successfully";

%>
<table class='block' width='100%' cellspacing='0' cellpadding='0'>


<tr><td align='center' height='70'><br/><a href="/portal/mytasks/mythemes.jsp">Back to My Themes</a><br/></td></tr>

<tr><td height='100'></td></tr>

</table>
