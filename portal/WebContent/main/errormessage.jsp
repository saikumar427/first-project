<%
String errormessage=(String)request.getAttribute("errormessage");
if(errormessage==null) errormessage="Sorry, request cannot be processed at this time";
%>
<table width="100%">
<tr><td height="20"></td></tr>
<tr>
<td align="center" height="20"><%=errormessage%></td>
</tr>
<tr><td height="100"></td></tr>
</table>