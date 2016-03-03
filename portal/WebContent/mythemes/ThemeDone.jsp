<%
String str=(String)request.getAttribute("DisplayText");
if(str==null)
str=" ";
%>
<table align='center' >	
<tr><td height="60"><%=str%></td></tr>
<tr><td><a href='<%=request.getAttribute("nexturl") %>'> <%=request.getAttribute("URLText")%></a></td></tr>
<tr><td height="90"></td></tr> 
</table>
