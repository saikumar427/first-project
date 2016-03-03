<%@ page import="java.io.*, java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>


<table border='0' cellpadding='0' cellspacing='0' width='100%'>
<tr><td height='5'></td></tr>

<tr><td align='center'>This is preview</td></tr>
<tr><td><hr size='-1' color='silver' noshade='true' /> </td></tr>
<tr><td>
<%
     HashMap pagemap=(HashMap)session.getAttribute("PAGE_HASH_NETWORK");
     
		
		String statement=request.getParameter("statement");
		String autoProcess=request.getParameter("autoProcess");
		String processStatement="";
		processStatement=("text".equals(autoProcess))?GenUtil.textToHtml(statement,true):statement;
		out.println(processStatement);
			
	
%>
</td></tr>
<tr><td><hr size='-1' color='silver' noshade='true' /> </td></tr>
<tr><td align='center'><input type='button' name='close' value='Close' onclick='javascript:window.close()' /></td></tr>
</table>

