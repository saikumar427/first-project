<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.authentication.*" %>


<%
	String userid="",username="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
	userid=authData.getUserID();
	username=authData.getLoginName();
	}
	String url=ShortUrlPattern.get(username)+"/network";

%>

<div class='memberbeelet-header'>My Network Page </div>
<table cellpadding="5" cellspacing="0" align="center" width="100%">
<tr><td  class='evenbase' valign='center'>URL:</td><td class='evenbase'>
<textarea rows='2' cols='33' onClick='this.select()'><%=url%></textarea></td></tr> 
<tr><td  class='evenbase' colspan='2'><a href='javascript:popupwindow("<%=url%>","<%="Events"%>","850","500");'>Preview</a></td></tr>
<tr><td  class='evenbase' colspan='2'><br/><b>Look And Feel</b></td></tr>
<tr><td  class='evenbase' colspan='2'><br/>Current Theme: <a href="/mytasks/Networktheme.jsp?type=Snapshot&ltype=theme">View/Change</a></td></tr>
<tr><td  class='evenbase' colspan='2'><br/>Photo: <a href='/mytasks/networkphoto.jsp?ntype=Photo'>View/Change</a></td></tr>
<tr><td  class='evenbase' colspan='2'><br/>Description: <a href='/mytasks/nwpagecontentmain.jsp?type=Snapshot'>View/Change</a></td></tr>
<tr><td  class='evenbase' colspan='2'><br/>Settings: <a href='/mytasks/editnwpref.jsp?type=Snapshot'>View/Change</a></td></tr>
</table>
