<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%String groupid=request.getParameter("groupid");%>
<form id="login" name="validatesignup" method="POST" action="/portal/webintegration/validate.jsp" onSubmit="validatedata('<%=request.getParameter("groupid")%>'); return false;">
<form name='loginform' method="POST"  action=""><br><br><br>
<center><FONT SIZE="4" COLOR=""><B>Eventbee Member? Login here</B></FONT></center>
<br><br><br><br><br>
<table cellspacing="0" class="inputvalue" width="" valign="top" border="0" align="center">
<tr>
<%if("yes".equals(request.getParameter("error"))){%>
<td align="center" colspan="2" id="loginerror"/><FONT  COLOR="red">Enter valid Bee ID/Password
</font></td>
<%}%>
</tr>
<tr>
	<td class="inputlabel" width="36%"  height="30"><%=EbeeConstantsF.get("login.label","Bee ID")%></td>
	<td class="inputvalue"><input description="User" id="uname" length="10" type="text" name="uname" /></td>
</tr>
<tr>
	<td class="inputlabel" width="36%"  height="30">Password</td>
	<td class="inputvalue">	<input description="Password" id="upassword" length="10" type="password" name="upassword" /></td>
</tr>
<tr>
	<td align="center" colspan="2"><input value="Go" name="submit" type="submit" /></td>
</tr>
<tr><td colspan="2" width="10"  /></tr>

<tr>
	<td colspan="2" width="10" height="10" />
</tr>
</table>
<br><br><br><center>
New to Eventbee?<input type="hidden" name="groupid"  id="groupid" value="<%=groupid%>"/> <a href='#'  onclick='getsignupscreen("/portal/webintegration/signup.jsp?groupid=<%=groupid%>")'>Sign Up</a> Now to become a member, it's FREE!</center>
</form>