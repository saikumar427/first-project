<%@ page import="com.eventbee.general.*,com.eventbee.general.GenUtil" %>
<%@ page import="com.eventbee.useraccount.AccountDB" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<html title="Email to friend">
<head>
  <title>E-Mail this page to a friend</title>
</head>
<body>
<%
	Presentation presentation=new Presentation(pageContext);
	presentation.includeStyles();
%>
  <table cellspacing="0" cellpadding="2" border="0" align="center" width="80%">
  <tr><td class="tasktitle"><b>Email Sent</b></td></tr>
  	<tr><td>
  		Mail Successfully sent to <%=request.getParameter("count")%> recepient(s)
  	</td></tr>
  	<tr><td align="center">
  		<input type="submit" name="submit" value="Close" onClick="javascript:window.close();"/>
  	</td></tr>

  </table>
</body>
</html>
