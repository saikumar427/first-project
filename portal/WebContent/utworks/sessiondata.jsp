<%@ page language="java" import="java.util.Enumeration"%>
<%
String s[]=request.getParameterValues("removeditems");
if(s!=null)
{
	for(int i=0;i<s.length;i++)
	{	
		
		System.out.println(s[i]);
		session.removeAttribute(s[i]);
	}
}
%>
<html>
<title>Session-Management</title>

<header>
<center><h2>Session Management</h2></center>
<hr>

</header>
<body>
<form action="" method="post">
<br>
<center>
<table border=1>
<th>check</th>
<th>Session Names</th>
<th>Session values</th>

<%
Enumeration e=(Enumeration)session.getAttributeNames();
while (e.hasMoreElements()) {
	  String name = (e.nextElement()).toString();
	  out.println("<tr><td><input type='checkbox' name='removeditems' value='"+name+"'></td>");
	  out.println("<td>"+name+"</td>");
	  out.println("<td>"+session.getValue(name)+"</td>");
	  }
%>

</tr>
</table>
<br>
<input type="submit" value="Remove" name="remove" >
</center>
</form>
</body>
</html>

