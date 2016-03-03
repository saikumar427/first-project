<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.formatting.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.*,com.eventbee.authentication.*"%>
<%


String groupid=request.getParameter("GROUPID");


%>
<form name='form1' action="/portal/eventregister/eventrsvpprocessing.jsp" method="post">
<input type='hidden' name='GROUPID' value='<%=groupid%>' />
<table>
<%if("yes".equals(request.getParameter("iserror"))){%>
<tr><td class="error" valign='top' align='center'>Invalid Login</td></tr>
<%}%>
</table>
  <table>
	<tr><td class="inform" valign='top'>
	<input type='radio' name='login' value="yes" checked='checked' ></td><td colspan='3'>If you have <%=EbeeConstantsF.get("application.name","Eventbee")%> account, enter your account information to auto-fill your profile form
        </td></tr><tr><td></td><td>Login <input type='text' name="loginName"  value="">
     <td>Password <input type='password' name="password" value="" >
        </td>
  </tr>
    <tr><td>
   <input type='radio' name='login' value="none"%>
    </td><td>I do not have <%=EbeeConstantsF.get("application.name","Eventbee")%> account</td></tr>
    <%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
   <tr><td align='center' colspan='3'> 
  
   <input value="Continue" type="submit" name="submit" value="Continue" />
     </td></tr>
   </table>
  </form>

