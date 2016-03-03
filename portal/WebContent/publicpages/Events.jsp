<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.authentication.*" %>


<%

	String userid="",username="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
	userid=authData.getUserID();
	username=authData.getLoginName();
	}
	String url=ShortUrlPattern.get(username)+"/events";

%>

	<div class='memberbeelet-header'>My Events Page </div>
	<table cellpadding="5" cellspacing="0" align="center" width="100%">
	<tr><td  class='evenbase' valign='center'>URL:</td><td class='evenbase'>
	<textarea rows='2' cols='33' onClick='this.select()'><%=url%></textarea></td></tr> 
	<tr><td  class='evenbase'  colspan='2'><a href='javascript:popupwindow("<%=url%>","<%="Events"%>","850","500");'>Preview</a></td></tr>
	<tr><td  class='evenbase'  colspan='2'><b><br/>Look And Feel</b></td></tr>
	<tr><td  class='evenbase'  colspan='2'><br/>Current Theme: <a href="/mytasks/eventstheme.jsp?type=eventspage">View/Change</a></td></tr>
	<tr><td  class='evenbase'  colspan='2'><br/>Photo: <a href='/mytasks/eventphoto.jsp?ntype=Photo'>View/Change</a></td></tr>
	<tr><td  class='evenbase'  colspan='2'><br/>Description: <a href='/mytasks/eventsprofile.jsp?ntype=Profile'>View/Change</a></td></tr>
	<tr><td  class='evenbase'  colspan='2'><br/>Settings: <a href='/mytasks/eventscontent.jsp?ntype=Content'>Manage</a></td></tr>
	<tr><td  class='evenbase'  colspan='2'><b><br/>Display Other Member Events</b></td></tr>
	<tr><td  class='evenbase'  colspan='2'><br/>Member List: <a href='/mytasks/eventmanagerlist.jsp'>Manage</a></td></tr>
	<tr><td  class='evenbase'  colspan='2'><br/>Member Events: <a href='/mytasks/managevenueevents.jsp?uid=<%=userid%>'>Manage</a></td></tr>
	</table>
