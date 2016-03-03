<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.authentication.*" %>

<%!
	String CLASS_NAME="publicpages/blogpage.jsp";
%>

<%
	String userid="",username="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
		userid=authData.getUserID();
		username=authData.getLoginName();
	}
	
	String url=ShortUrlPattern.get(username)+"/blog";
	String themeurl="/eroller/rollerlogin.jsp?act=eeditTheme";
	String manageurl="/eroller/rollerlogin.jsp?act=eeditWebsite";
%>
	
	<div class='memberbeelet-header'>My Blog Page </div>
	<table cellpadding="5" cellspacing="0" align="center" width="100%">
	<tr><td  class='evenbase'  valign='center'>URL:</td><td class='evenbase'> <textarea rows='2' cols='33' onClick='this.select()'><%=url%></textarea></td></tr>
	<tr><td  class='evenbase' colspan='2'><a href='javascript:popupwindow("<%=url%>","<%="Community"%>","850","500");'>Preview</a></td></tr>
	<tr><td  class='evenbase' colspan='2'><br/><b>Look And Feel</b></td></tr>
	<tr><td  class='evenbase' colspan='2'><br/>Current Theme: <a href="<%=themeurl%>">View/Change</a></td></tr>
	<tr><td  class='evenbase'colspan='2'><br/>Settings: <a href='<%=manageurl%>'>Manage</a></td></tr>
	</table>
