<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addmembers.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
String clubname=request.getParameter("clubname");



%>


<%@ include file="/../plaxo_js.jsp" %>

<form  name='emailform' action="/hub/sendmails" method="post">
<table cellspacing="0" class="taskblock" cellpadding="2" border="0" width='100%'>
<input type='hidden' name='ntype' value='Add Member' />
<input type='hidden' name='clubname' value='<%=clubname%>'/>
<input type='hidden' name='GROUPID' value='<%=request.getParameter("GROUPID")%>' />
	<tr>	
	<td colspan="2" align='center' ><a href="#" onclick="showPlaxoABChooser('emailsString', '/home/links/addressimport.html'); return false"><img src="/home/images/wizard_button.gif" alt="Add from my address book"  border='0'/></a></td>
	</tr>
	<tr>
	<td class="inputlabel">Email IDs <br/>(comma separated)</td>
	<td class="inputvalue">
	<textarea id="emailsString" style="display: none;"></textarea>
	<textarea id="toheader" name="emailsString" rows='10' cols='60' onfocus="this.value=(this.value==' ')?'':this.value"></textarea>
	</td>
	</tr>
	<tr>
	<td class="inputlabel">Member Benefits</td>
	<td class="inputvalue">
	<textarea name='memberbenefit' rows='10' cols='60'   ></textarea>
	</td></tr>
	<tr ><td align='center' colspan='2'>
	NOTE: <%= EbeeConstantsF.get("hubmember.add.message","please set the property noticeboard.empty.message in emptybeelts.ebeeprops")%>
 </td></tr>
	<tr><td align='center' colspan='2'>
	<input type="submit" name="submit" value="Submit" />
	<input type="button" name="bbb" value="Cancel" onClick="javascript:history.back()" />
	</td></tr>
	
</table>
</form>


