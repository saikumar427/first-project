<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%

String BACK_PAGE=(String)session.getAttribute("BACK_PAGE");
if(BACK_PAGE==null||"".equals(BACK_PAGE))
	BACK_PAGE="common";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"processauth.jsp",null,"BACK_PAGE i.e purpose value is------"+BACK_PAGE,null);

String headermsg=EbeeConstantsF.get("eventattendee.loginsubheadermsg","[Optional] Enter your Login info to auto-fill your information");
HashMap hm=null;
%>

<table cellspacing="0" class="taskbox" width="100%" valign="top" border="0">
<tr ><td><table width="100%"  cellspacing="2">

<tr <td class="subheader"><%=headermsg %> </td></tr>
<% if(request.getAttribute("error") !=null) { %>
<tr><td align="left" class="error" ><%=(String)request.getAttribute("error") %></tr>

<%} %>

<tr><td id='selectionerror' class='error' ></td></tr>
<input type="hidden" name="task" value="login" />

<tr >
	<td class="inputlabel"   height="10">Bee ID 
	<input description="User" length="10" type="text" name="uname" />

	&nbsp;&nbsp;&nbsp;Password <input description="Password" length="10" type="password" name="upassword" />
	&nbsp;&nbsp;&nbsp;<input name="submit1" type="submit" value="Login" class="button" title="Login" /></td>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
</tr>

<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>" />
<input type="hidden" name="task" value="login" />

</table>

</td></tr></table>



