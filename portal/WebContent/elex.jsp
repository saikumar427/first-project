<html>
<head>
<title> Use of Expression Language in jsp</title></head>
<%pageContext.setAttribute("pageColor", "#FFFFDF");
%>
<body>
<table bgcolor="${pageScope.pageColor}" border="1" cellpadding="0" cellspacing="0" align="center" width="50%" height="50%">
<tr>
<td>
<b>Welcome to the Roseindia.net</b></td>
</tr>
<tr>
<td>
You appear to be using the following browser:<br>
${header["user-agent"]}
</td>
</tr>
</table>
</body>
</html>