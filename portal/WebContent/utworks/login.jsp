<%@ page import="com.eventbee.authentication.AuthDB,com.eventbee.authentication.Authenticate,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.DbUtil" %>
<%
if(request.getParameter("logout")!=null){
	session.invalidate();
}
String userid="";
String usereq=request.getParameter("usereq");
if(request.getParameter("submit")!=null ){
 		
		   userid=DbUtil.getVal("select userid from admin_users where role=? and password=? and name='eventbeeadmin'",new String[]{request.getParameter("name"),request.getParameter("password")}); 
	       System.out.println("userid is:"+userid);
		   if(userid==null) userid="";
		   if(!"".equals(userid)){
	       	 session.setAttribute("authDatauttool",userid);
			 response.sendRedirect(usereq+".jsp");
			}else{
	       	request.setAttribute("error","Invalid Login" );
	       }
}
%>
<form method="POST"  action="login.jsp">
<table cellspacing="0" class="inputvalue" width="100%" valign="top" border="0">
<tr>
	<td colspan="2" width="10" height="10" />
</tr>


<% if(request.getAttribute("error") !=null) { %>
<tr><td align="center" class="error" colspan="2" /><%=(String)request.getAttribute("error") %></tr>
<%} %>

<tr>
	<td>Login Name</td>
	<td class="inputvalue"><input description="User" length="10" type="text" name="name" /></td>
</tr>

<tr>
	<td>Password</td>
	<td class="inputvalue">	<input description="Password" length="10" type="password" name="password" /></td>
</tr>

<tr>
	<td align="center" colspan="2"><input value="Login" name="submit" type="submit" /></td>
</tr>

<tr><td colspan="2" width="10" heigth="100" /></tr>
<tr><td colspan="2" width="10" height="10" /></tr>
</table>
<input type="hidden" name="userid" value="<%=userid%>"/>
<input type="hidden" name="usereq" value="<%=usereq%>"/>
</form>

