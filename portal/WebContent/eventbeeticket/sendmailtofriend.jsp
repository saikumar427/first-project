<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ include file="/../plaxo_js.jsp" %>
<%
String groupid=request.getParameter("groupid");
String userid="";
String firstname="";
String lastname="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
	 firstname=authData.getFirstName();
	lastname=authData.getLastName();
}
String email=DbUtil.getVal("select email from user_profile where user_id=?",new String[] {userid});
if(email==null)
	email="";
String mgrname=DbUtil.getVal("select login_name from authentication where user_id=(select mgr_id::varchar from eventinfo where eventid=CAST(? AS INTEGER))",new String[]{groupid});
%>

<form name="emailtopartner" id="emailtopartner" action="/portal/eventbeeticket/sendpartnerrequestmail.jsp" method="post" >
<input type="hidden" name="eventid" value="<%=groupid%>">
<table width="100%">
	
<tr>
<td width="25%">To<br/><span class="smallestfont" >(comma separated)</span></td>
<td><textarea id="emailsString" name="email" style="display: none;"></textarea>
	<textarea id="toheader" name="emailsString" rows='10' cols='50' onfocus="this.value=(this.value==' ')?'':this.value"> </textarea>
	</td>
</tr>
<tr><td colspan="2" height="5"</tr>

<tr><td colspan="2" height="5"</tr>
<tr>
<td width="15%">Subject</td>
<td width="85%"><input type="text" name="subject" size="60" value="Become my event Partner"></td>
</tr>
<tr><td colspan="2" height="5"</tr>
<tr>
<td width="15%">Message</td>
<td width="85%"><textarea id="message" name="message" rows='10' cols='50' onfocus="this.value=(this.value==' ')?'':this.value">
Hi,
<br><br>
I would like to add you as my ticket selling Partner on my events. Please sign up at <a href="http://www.eventbee.com/guesttasks/signup.jsp">Eventbee</a>, and get your tracking URLs for my events.
<br><br>
Tracking URL allows you to monitor your ticket sales in real time, and allows you to create custom branded event page of your own.
<br><br>
http://www.eventbee.com/guesttasks/signup.jsp
<br><br>
Thanks,<br>
<%=firstname%> <%=lastname%>
</textarea></td>
</tr>
<tr><td colspan="2" height="5"</tr>
<tr>
<td colspan="2" align="center"><input type="button" value="Send" onclick="sendinvitation(<%=groupid%>);">
<input type="button" value="Cancel" onclick="back();">
</td></tr>
</table>
