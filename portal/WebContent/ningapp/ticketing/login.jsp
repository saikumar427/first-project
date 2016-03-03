<%@ page import="com.eventbee.general.*" %>



<table  class='gadget' cellpadding="0" cellspacing="0" style="border: 1px solid #ddddff" align="center" width="95%"  valign="top">
<tr ><td>
<div align="center" ><b>Already an Eventbee member? Please Login</b></div>
<form name='loginform' id="loginform" method="POST"  action="/portal/ningapp/ticketing/loginprocess.jsp" >
<table  cellspacing="0"  width="100%" valign="top" border="0" align="center" class='gadget'>
<tr><td id="loginerrormsg" colspan="2"></td></tr>
<tr><td align="center" valign="middle">Bee ID:  
	<input description="User" size="15" type="text" id="login"  name="login" />    
	Password:  <input description="Password"  id="password" size="15" type="password" name="password" />
	<input class="button" value="Go" name="go" type="button"  onClick="SubmitLogin('<%=oid%>');" /></td>
</tr>
</table>
</form>
</td></tr></table>
