<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%

String BACK_PAGE=(String)session.getAttribute("BACK_PAGE");
if(BACK_PAGE==null||"".equals(BACK_PAGE))
	BACK_PAGE="common";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"processauth.jsp",null,"BACK_PAGE i.e purpose value is------"+BACK_PAGE,null);

String headermsg=EbeeConstantsF.get(BACK_PAGE+".loginsubheadermsg","Eventbee Member? Enter your login information and click on Continue button");
HashMap hm=null;
%>

<table cellspacing="0" class="block" width="100%" valign="top" border="0">
<tr class='evenbase'><td><table width="100%" class="block" cellspacing="2">
<form name='loginform' method="POST"  action="/portal/eventlistauth/processevtauth.jsp" >

<tr><td colspan="2"  /></tr>
<tr class="subheader"><td colspan="2" /><%=headermsg %> <br/><br/></td></tr>
<% if(request.getAttribute("error") !=null) { %>
<tr><td align="left" class="error" colspan="2" /><%=(String)request.getAttribute("error") %></tr>

<%} %>

<tr><td id='selectionerror' class='error' colspan='2'></td></tr>
<input type="hidden" name="task" value="login" />

<tr>
	<td class="inputlabel" width="36%"  height="30">Bee ID </td>
	<td class="inputvalue"><input description="User" length="10" type="text" name="uname" /></td>
</tr>

<tr>
	<td class="inputlabel" width="36%"  height="30">Password </td>
	<td class="inputvalue">	<input description="Password" length="10" type="password" name="upassword" /></td>
</tr>


<tr><td colspan="2" width="10" heigth="100" /></tr>



<tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
	<td align="center" colspan="2"><input value="Continue" name="submit" type="submit" />
	<input type="button"  value="Cancel" onClick="javascript:window.history.back()"/>
	</td>
</tr>

<tr>
	<td align="center" colspan="2">
		<a HREF="javascript:popupwindow('/portal/guesttasks/loginproblem.jsp?entryunitid=13579&amp;UNITID=13579','Tags','600','400')">Login help?</a>
	
	</td>
</tr>

<tr>
	<td colspan="2" width="10" height="10" />
</tr>
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>" />
<input type="hidden" name="task" value="login" />

</form>
</table>

</td></tr></table>



