<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>



<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy() { }
</script>


<script language="JavaScript">
	document.validateloginform.name.focus();
</script>




<form name='validateloginform' id="validateloginform" method="POST"  action="/hub/validatelogindetails.jsp" onSubmit="validatelogin(); return false;">
<div  align="center"  id="changeloginerrormsg">Change your Password</div>

<table  cellspacing="0" class="inputvalue" width="100%" valign="top" border="0" id="container">

<tr>

<td colspan="2" width="10" height="10" /></tr>


<% if(request.getAttribute("error") !=null) { %>
<tr><td align="center" class="error" colspan="2" /><%=(String)request.getAttribute("error") %></tr>

<%} %>
<!--<tr>
	<td>User Name</td>
	<td class="inputvalue"><input description="User" length="10" type="text" name="name" /></td>
</tr>-->


<tr>
	<td>Password</td>
	<td class="inputvalue">	<input description="Password" length="10" type="password" name="password" /></td>
</tr>

<tr>
	<td>Confirm Password</td>
	<td class="inputvalue">	<input description="Password" length="10" type="password" name="cpassword" /></td>
</tr>
<tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
	<td align="center" colspan="2"><input value="Go" name="go" type="submit" /></td>
</tr>

<tr><td colspan="2" width="10" heigth="100" /></tr>

<tr>
	<td align="center" colspan="2">
		<a HREF="/portal/loginproblems/loginproblem.jsp?entryunitid=13579&UNITID=13579">Login help?</a>
	</td>
</tr>

<tr>
	<td colspan="2" width="10" height="10" />
</tr>
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>">
<input type="hidden" name="UNITID" value="13579">
</form>
</table>





